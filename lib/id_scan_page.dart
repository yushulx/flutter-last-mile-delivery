import 'package:delivery/confirm_page.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_barcode_sdk/dynamsoft_barcode.dart';
import 'package:flutter_barcode_sdk/flutter_barcode_sdk.dart';
import 'package:flutter_ocr_sdk/mrz_line.dart';
import 'package:flutter_ocr_sdk/mrz_result.dart';
import 'data/driver_license.dart';
import 'global.dart';

import 'dart:io';

import 'package:flutter/foundation.dart';

class IdScanPage extends StatefulWidget {
  const IdScanPage({super.key});

  @override
  State<IdScanPage> createState() => _IdScanPageState();
}

class _IdScanPageState extends State<IdScanPage> with WidgetsBindingObserver {
  bool _isDriverLicense = true;
  CameraController? _controller;
  late List<CameraDescription> _cameras;
  Size? _previewSize;
  bool _isScanAvailable = true;
  List<BarcodeResult>? _barcodeResults;
  List<List<MrzLine>>? _mrzLines;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initCamera();
  }

  Future<void> toggleCamera(int index) async {
    if (_controller != null) _controller!.dispose();

    _controller = CameraController(_cameras[index], ResolutionPreset.medium);
    _controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }

      _previewSize = _controller!.value.previewSize;

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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    stopVideo();
    super.dispose();
  }

  void stopVideo() async {
    if (_controller == null) return;
    await _controller!.stopImageStream();
    _controller!.dispose();
    _controller = null;
  }

  void startVideo() async {
    setState(() {
      _barcodeResults = null;
      _mrzLines = null;
    });

    await _controller!.startImageStream((CameraImage availableImage) async {
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

      if (_isDriverLicense) {
        setState(() {
          _mrzLines = null;
        });
        barcodeReader
            .decodeImageBuffer(
                availableImage.planes[0].bytes,
                availableImage.width,
                availableImage.height,
                availableImage.planes[0].bytesPerRow,
                format)
            .then((results) {
          if (!mounted) return;
          if (MediaQuery.of(context).size.width <
              MediaQuery.of(context).size.height) {
            if (Platform.isAndroid) {
              results = rotate90barcode(results, _previewSize!.height.toInt());
            }
          }
          setState(() {
            _barcodeResults = results;
          });

          if (results.isNotEmpty) {
            Map<String, String>? map = parseLicense(results[0].text);
            if (map != null) {
              stopVideo();
              MaterialPageRoute route = MaterialPageRoute(
                builder: (context) => const ConfirmPage(),
              );
              routes.add(route);
              Navigator.push(
                context,
                route,
              ).then((value) => initCamera());
            }
          }

          _isScanAvailable = true;
        });
      } else {
        setState(() {
          _barcodeResults = null;
        });
        mrzDetector
            .recognizeByBuffer(
                availableImage.planes[0].bytes,
                availableImage.width,
                availableImage.height,
                availableImage.planes[0].bytesPerRow,
                format)
            .then((results) {
          if (results == null || !mounted) return;

          if (MediaQuery.of(context).size.width <
              MediaQuery.of(context).size.height) {
            if (Platform.isAndroid) {
              results = rotate90mrz(results, _previewSize!.height.toInt());
            }
          }
          setState(() {
            _mrzLines = results;
          });

          if (results.isNotEmpty) {
            stopVideo();
            MaterialPageRoute route = MaterialPageRoute(
              builder: (context) => const ConfirmPage(),
            );
            routes.add(route);
            Navigator.push(
              context,
              route,
            ).then((value) => initCamera());
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      toggleCamera(0);
    }
  }

  Widget getButtons() {
    if (_isDriverLicense) {
      return Row(children: [
        GestureDetector(
            onTap: () {
              setState(() {
                _isDriverLicense = true;
                _mrzLines = null;
              });
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: 50,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xff323234),
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFFfe8e14),
                      width: 2,
                    ),
                  ),
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    width: 20.0,
                    height: 20.0,
                    decoration: const BoxDecoration(
                      color: Color(0xFFfe8e14),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  const Text(
                    'Driver License',
                    style: TextStyle(color: Color(0xFFfe8e14)),
                  )
                ]),
              ),
            )),
        GestureDetector(
            onTap: () {
              setState(() {
                _isDriverLicense = false;
                _barcodeResults = null;
              });
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: 50,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xff0C0C0C),
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    width: 20.0,
                    height: 20.0,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  const Text(
                    'Passport',
                    style: TextStyle(color: Colors.white),
                  )
                ]),
              ),
            ))
      ]);
    } else {
      return Row(children: [
        GestureDetector(
            onTap: () {
              setState(() {
                _isDriverLicense = true;
              });
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: 50,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xff0C0C0C),
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    width: 20.0,
                    height: 20.0,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  const Text(
                    'Driver License',
                    style: TextStyle(color: Colors.white),
                  )
                ]),
              ),
            )),
        GestureDetector(
            onTap: () {
              setState(() {
                _isDriverLicense = false;
              });
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: 50,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xff323234),
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFFfe8e14),
                      width: 2,
                    ),
                  ),
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    width: 20.0,
                    height: 20.0,
                    decoration: const BoxDecoration(
                      color: Color(0xFFfe8e14),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  const Text(
                    'Passport',
                    style: TextStyle(color: Color(0xFFfe8e14)),
                  )
                ]),
              ),
            ))
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          routes.removeLast();
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text(
              'Scan Identity Documents',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                routes.removeLast();
                Navigator.of(context).pop();
              },
            ),
          ),
          body: Stack(
            children: <Widget>[
              if (_controller != null && _previewSize != null)
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  bottom: 50,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Stack(
                      children: [
                        if (_controller != null && _previewSize != null)
                          SizedBox(
                              width: MediaQuery.of(context).size.width <
                                      MediaQuery.of(context).size.height
                                  ? _previewSize!.height
                                  : _previewSize!.width,
                              height: MediaQuery.of(context).size.width <
                                      MediaQuery.of(context).size.height
                                  ? _previewSize!.width
                                  : _previewSize!.height,
                              child: CameraPreview(_controller!)),
                        Positioned(
                          top: 0.0,
                          right: 0.0,
                          bottom: 50,
                          left: 0.0,
                          child: createOverlay(_barcodeResults, _mrzLines),
                        ),
                      ],
                    ),
                  ),
                ),
              Positioned(bottom: 0, child: getButtons()),
            ],
          ),
        ));
  }
}
