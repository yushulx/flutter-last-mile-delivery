import 'dart:math';
import 'dart:ui';

import 'package:delivery/data/profile_data.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_barcode_sdk/dynamsoft_barcode.dart';
import 'package:flutter_barcode_sdk/flutter_barcode_sdk.dart';
import 'package:flutter_document_scan_sdk/document_result.dart';
import 'package:flutter_ocr_sdk/mrz_line.dart';

import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter_ocr_sdk/mrz_parser.dart';
import 'package:flutter_ocr_sdk/mrz_result.dart';

import '../data/driver_license.dart';
import '../global.dart';
import '../utils.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

enum ScanType { id, barcode, document }

class MobileCamera {
  BuildContext context;
  CameraController? controller;
  late List<CameraDescription> _cameras;
  Size? previewSize;
  bool _isScanAvailable = true;
  List<BarcodeResult>? barcodeResults;
  List<List<MrzLine>>? mrzLines;
  List<DocumentResult>? documentResults;
  bool isDriverLicense = true;
  ScanType scanType = ScanType.id;
  bool isFinished = false;

  MobileCamera(
      {required this.context,
      required this.cbRefreshUi,
      required this.cbIsMounted,
      required this.cbNavigation,
      required this.scanType});

  Function cbRefreshUi;
  Function cbIsMounted;
  Function cbNavigation;

  void initState() {
    initCamera();
  }

  void stopVideo() async {
    if (controller == null) return;
    if (!kIsWeb) {
      await controller!.stopImageStream();
    }

    controller!.dispose();
    controller = null;
  }

  Future<void> webCamera() async {
    if (controller == null) return;

    Future.delayed(const Duration(milliseconds: 20), () async {
      if (controller == null || cbIsMounted() == false) return;

      XFile file = await controller!.takePicture();

      if (scanType == ScanType.id) {
        if (isDriverLicense) {
          mrzLines = null;
          cbRefreshUi();
          barcodeReader.decodeFile(file.path).then((results) {
            if (!cbIsMounted()) return;
            barcodeResults = results;
            cbRefreshUi();
            if (results.isNotEmpty) {
              try {
                Map<String, String>? map = parseLicense(results[0].text);
                if (map != null) {
                  stopVideo();
                  if (!isFinished) {
                    isFinished = true;
                    cbNavigation();
                  }
                }
              } catch (e) {
                print(e);
              }
            }

            _isScanAvailable = true;
          });
        } else {
          barcodeResults = null;
          cbRefreshUi();
          mrzDetector.recognizeByFile(file.path).then((results) {
            if (results == null || !cbIsMounted()) return;

            mrzLines = results;
            cbRefreshUi();
            if (results.isNotEmpty) {
              MrzResult information = MrzResult();

              try {
                for (List<MrzLine> area in results) {
                  if (area.length == 2) {
                    information = MRZ.parseTwoLines(area[0].text, area[1].text);
                  } else if (area.length == 3) {
                    information = MRZ.parseThreeLines(
                        area[0].text, area[1].text, area[2].text);
                  }
                }
              } catch (e) {
                print(e);
              }

              if (information.surname == '') {
                information.surname = 'Not found';
              }

              if (information.givenName == '') {
                information.givenName = 'Not found';
              }

              if (information.nationality == '') {
                information.nationality = 'Not found';
              }

              if (information.passportNumber == '') {
                information.passportNumber = 'Not found';
              }

              stopVideo();
              if (!isFinished) {
                isFinished = true;
                ProfileData scannedData = ProfileData();

                scannedData.firstName = information.givenName;
                scannedData.lastName = information.surname;
                scannedData.nationality = information.nationality;
                scannedData.idNumber = information.passportNumber;
                cbNavigation(scannedData);
              }
            }
          });
        }
      } else if (scanType == ScanType.barcode) {
        barcodeReader.decodeFile(file.path).then((results) {
          if (!cbIsMounted()) return;

          barcodeResults = results;

          if (results.isNotEmpty) {
            stopVideo();
            if (!isFinished) {
              isFinished = true;
              var random = Random();
              var element = orders[random.nextInt(orders.length)];
              cbNavigation(element);
            }
          }

          _isScanAvailable = true;
        });
      } else if (scanType == ScanType.document) {
        documentResults = await docScanner.detectFile(file.path);
        if (!cbIsMounted()) return;

        documentResults = filterResults(documentResults,
            previewSize!.width.toInt(), previewSize!.height.toInt());

        if (documentResults == null || documentResults!.isEmpty) {
          webCamera();
          return;
        }

        final data = await file.readAsBytes();
        ui.Image sourceImage = await decodeImageFromList(data);
        ByteData? byteData =
            await sourceImage.toByteData(format: ui.ImageByteFormat.rawRgba);

        Uint8List bytes = byteData!.buffer.asUint8List();
        int width = sourceImage.width;
        int height = sourceImage.height;
        int stride = byteData.lengthInBytes ~/ sourceImage.height;
        int format = ImagePixelFormat.IPF_ARGB_8888.index;

        docScanner
            .normalizeBuffer(bytes, width, height, stride, format,
                documentResults![0].points)
            .then((normalizedImage) {
          if (normalizedImage != null) {
            decodeImageFromPixels(normalizedImage.data, normalizedImage.width,
                normalizedImage.height, PixelFormat.rgba8888, (ui.Image img) {
              cbNavigation(img);
            });
          }
        });
      }
      webCamera();
    });
  }

  void mobileCamera() async {
    await controller!.startImageStream((CameraImage availableImage) async {
      assert(defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);
      if (cbIsMounted() == false) return;
      int format = ImagePixelFormat.IPF_NV21.index;

      switch (availableImage.format.group) {
        case ImageFormatGroup.yuv420:
          format = ImagePixelFormat.IPF_NV21.index;
          break;
        case ImageFormatGroup.bgra8888:
          format = ImagePixelFormat.IPF_ARGB_8888.index;
          break;
        default:
          format = ImagePixelFormat.IPF_RGB_888.index;
      }

      if (!_isScanAvailable) {
        return;
      }

      _isScanAvailable = false;

      if (scanType == ScanType.id) {
        if (isDriverLicense) {
          mrzLines = null;
          cbRefreshUi();
          barcodeReader
              .decodeImageBuffer(
                  availableImage.planes[0].bytes,
                  availableImage.width,
                  availableImage.height,
                  availableImage.planes[0].bytesPerRow,
                  format)
              .then((results) {
            if (!cbIsMounted()) return;
            if (MediaQuery.of(context).size.width <
                MediaQuery.of(context).size.height) {
              if (Platform.isAndroid) {
                results = rotate90barcode(results, previewSize!.height.toInt());
              }
            }
            barcodeResults = results;
            cbRefreshUi();
            if (results.isNotEmpty) {
              Map<String, String>? map = parseLicense(results[0].text);
              if (map != null) {
                stopVideo();
                if (!isFinished) {
                  isFinished = true;
                  cbNavigation();
                }
              }
            }

            _isScanAvailable = true;
          });
        } else {
          barcodeResults = null;
          cbRefreshUi();
          mrzDetector
              .recognizeByBuffer(
                  availableImage.planes[0].bytes,
                  availableImage.width,
                  availableImage.height,
                  availableImage.planes[0].bytesPerRow,
                  format)
              .then((results) {
            if (results == null || !cbIsMounted()) return;

            if (MediaQuery.of(context).size.width <
                MediaQuery.of(context).size.height) {
              if (Platform.isAndroid) {
                results = rotate90mrz(results, previewSize!.height.toInt());
              }
            }

            mrzLines = results;
            cbRefreshUi();
            if (results.isNotEmpty) {
              MrzResult information = MrzResult();

              try {
                for (List<MrzLine> area in results) {
                  if (area.length == 2) {
                    information = MRZ.parseTwoLines(area[0].text, area[1].text);
                  } else if (area.length == 3) {
                    information = MRZ.parseThreeLines(
                        area[0].text, area[1].text, area[2].text);
                  }
                }
              } catch (e) {
                print(e);
              }

              if (information.surname == '') {
                information.surname = 'Not found';
              }

              if (information.givenName == '') {
                information.givenName = 'Not found';
              }

              if (information.nationality == '') {
                information.nationality = 'Not found';
              }

              if (information.passportNumber == '') {
                information.passportNumber = 'Not found';
              }

              stopVideo();
              if (!isFinished) {
                isFinished = true;
                ProfileData scannedData = ProfileData();

                scannedData.firstName = information.givenName;
                scannedData.lastName = information.surname;
                scannedData.nationality = information.nationality;
                scannedData.idNumber = information.passportNumber;
                cbNavigation(scannedData);
              }
            }

            _isScanAvailable = true;
          });
        }
      } else if (scanType == ScanType.barcode) {
        barcodeReader
            .decodeImageBuffer(
                availableImage.planes[0].bytes,
                availableImage.width,
                availableImage.height,
                availableImage.planes[0].bytesPerRow,
                format)
            .then((results) {
          if (!cbIsMounted()) return;
          if (MediaQuery.of(context).size.width <
              MediaQuery.of(context).size.height) {
            if (Platform.isAndroid) {
              results = rotate90barcode(results, previewSize!.height.toInt());
            }
          }
          barcodeResults = results;

          if (results.isNotEmpty) {
            stopVideo();
            if (!isFinished) {
              isFinished = true;
              var random = Random();
              var element = orders[random.nextInt(orders.length)];
              cbNavigation(element);
            }
          }

          _isScanAvailable = true;
        });
      } else if (scanType == ScanType.document) {
        docScanner
            .detectBuffer(
                availableImage.planes[0].bytes,
                availableImage.width,
                availableImage.height,
                availableImage.planes[0].bytesPerRow,
                format)
            .then((results) {
          if (!cbIsMounted()) return;
          results = filterResults(
              results, availableImage.width, availableImage.height);
          if (results.isEmpty) {
            _isScanAvailable = true;
            return;
          }
          if (MediaQuery.of(context).size.width <
              MediaQuery.of(context).size.height) {
            if (Platform.isAndroid) {
              results = rotate90document(results, previewSize!.height.toInt());
            }
          }
          documentResults = results;

          if (results.isNotEmpty) {
            if (!isFinished) {
              isFinished = true;

              Uint8List data;
              Uint8List imageBuffer = availableImage.planes[0].bytes;
              int imageWidth = availableImage.width;
              int imageHeight = availableImage.height;
              if (format == ImagePixelFormat.IPF_NV21.index) {
                List<Uint8List> planes = [];
                for (int planeIndex = 0; planeIndex < 3; planeIndex++) {
                  Uint8List buffer;
                  int width;
                  int height;
                  if (planeIndex == 0) {
                    width = availableImage.width;
                    height = availableImage.height;
                  } else {
                    width = availableImage.width ~/ 2;
                    height = availableImage.height ~/ 2;
                  }

                  buffer = Uint8List(width * height);

                  int pixelStride =
                      availableImage.planes[planeIndex].bytesPerPixel!;
                  int rowStride = availableImage.planes[planeIndex].bytesPerRow;
                  int index = 0;
                  for (int i = 0; i < height; i++) {
                    for (int j = 0; j < width; j++) {
                      buffer[index++] = availableImage.planes[planeIndex]
                          .bytes[i * rowStride + j * pixelStride];
                    }
                  }

                  planes.add(buffer);
                }

                imageBuffer = planes[0];
                data = yuv420ToRgba8888(planes, imageWidth, imageHeight);
                if (MediaQuery.of(context).size.width <
                    MediaQuery.of(context).size.height) {
                  if (Platform.isAndroid) {
                    data = rotate90Degrees(data, imageWidth, imageHeight);
                    imageWidth = availableImage.height;
                    imageHeight = availableImage.width;
                  }
                }
              } else {
                data = imageBuffer;
              }

              docScanner
                  .normalizeBuffer(
                      data,
                      imageWidth,
                      imageHeight,
                      imageWidth * 4,
                      ImagePixelFormat.IPF_ARGB_8888.index,
                      results[0].points)
                  .then((normalizedImage) {
                if (normalizedImage != null) {
                  decodeImageFromPixels(
                      normalizedImage.data,
                      normalizedImage.width,
                      normalizedImage.height,
                      PixelFormat.rgba8888, (ui.Image img) {
                    cbNavigation(img);
                  });
                }
              });
            }
          }

          _isScanAvailable = true;
        });
      }
    });
  }

  void startVideo() async {
    barcodeResults = null;
    mrzLines = null;
    documentResults = null;

    isFinished = false;

    cbRefreshUi();

    if (kIsWeb) {
      webCamera();
    } else {
      mobileCamera();
    }
  }

  Future<void> initCamera() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;

      toggleCamera(0);
    } on CameraException catch (e) {
      print(e);
    }
  }

  Widget getPreview() {
    if (controller == null) {
      return Container(
        child: const Text('No camera available!'),
      );
    }

    return CameraPreview(controller!);
  }

  Future<void> toggleCamera(int index) async {
    if (controller != null) controller!.dispose();

    controller = CameraController(_cameras[index], ResolutionPreset.medium);
    controller!.initialize().then((_) {
      if (!cbIsMounted()) {
        return;
      }

      previewSize = controller!.value.previewSize;

      startVideo();
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            break;
          default:
            break;
        }
      }
    });
  }
}
