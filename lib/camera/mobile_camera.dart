import 'package:delivery/confirm_page.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_barcode_sdk/dynamsoft_barcode.dart';
import 'package:flutter_barcode_sdk/flutter_barcode_sdk.dart';
import 'package:flutter_ocr_sdk/mrz_line.dart';

import 'dart:io';

import 'package:flutter/foundation.dart';

import '../data/driver_license.dart';
import '../global.dart';

class MobileCamera {
  BuildContext context;
  CameraController? controller;
  late List<CameraDescription> _cameras;
  Size? previewSize;
  bool _isScanAvailable = true;
  List<BarcodeResult>? barcodeResults;
  List<List<MrzLine>>? mrzLines;
  bool isDriverLicense = true;

  MobileCamera(
      {required this.context,
      required this.uiRefreshCallback,
      required this.isMountedCallback,
      required this.navigationCallback});

  Function uiRefreshCallback;
  Function isMountedCallback;
  Function navigationCallback;

  void initState() {
    initCamera();
  }

  void stopVideo() async {
    if (controller == null) return;
    await controller!.stopImageStream();
    controller!.dispose();
    controller = null;
  }

  void startVideo() async {
    barcodeResults = null;
    mrzLines = null;

    uiRefreshCallback();

    await controller!.startImageStream((CameraImage availableImage) async {
      assert(defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);
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

      if (isDriverLicense) {
        mrzLines = null;
        uiRefreshCallback();
        barcodeReader
            .decodeImageBuffer(
                availableImage.planes[0].bytes,
                availableImage.width,
                availableImage.height,
                availableImage.planes[0].bytesPerRow,
                format)
            .then((results) {
          if (!isMountedCallback!()) return;
          if (MediaQuery.of(context).size.width <
              MediaQuery.of(context).size.height) {
            if (Platform.isAndroid) {
              results = rotate90barcode(results, previewSize!.height.toInt());
            }
          }
          barcodeResults = results;
          uiRefreshCallback();
          if (results.isNotEmpty) {
            Map<String, String>? map = parseLicense(results[0].text);
            if (map != null) {
              stopVideo();
              navigationCallback();
            }
          }

          _isScanAvailable = true;
        });
      } else {
        barcodeResults = null;
        uiRefreshCallback();
        mrzDetector
            .recognizeByBuffer(
                availableImage.planes[0].bytes,
                availableImage.width,
                availableImage.height,
                availableImage.planes[0].bytesPerRow,
                format)
            .then((results) {
          if (results == null || !isMountedCallback()) return;

          if (MediaQuery.of(context).size.width <
              MediaQuery.of(context).size.height) {
            if (Platform.isAndroid) {
              results = rotate90mrz(results, previewSize!.height.toInt());
            }
          }

          mrzLines = results;
          uiRefreshCallback();
          if (results.isNotEmpty) {
            stopVideo();
            navigationCallback();
          }

          _isScanAvailable = true;
        });
      }
    });
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
    return CameraPreview(controller!);
  }

  Future<void> toggleCamera(int index) async {
    if (controller != null) controller!.dispose();

    controller = CameraController(_cameras[index], ResolutionPreset.medium);
    controller!.initialize().then((_) {
      if (!isMountedCallback()) {
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
