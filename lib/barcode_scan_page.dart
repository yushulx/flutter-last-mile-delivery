import 'dart:math';

import 'package:delivery/delivery_page.dart';
import 'package:flutter/material.dart';

import 'camera/mobile_camera.dart';
import 'global.dart';

class BarcodeScanPage extends StatefulWidget {
  const BarcodeScanPage({super.key});

  @override
  State<BarcodeScanPage> createState() => _BarcodeScanPageState();
}

class _BarcodeScanPageState extends State<BarcodeScanPage>
    with WidgetsBindingObserver {
  late MobileCamera _mobileCamera;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _mobileCamera = MobileCamera(
        context: context,
        cbRefreshUi: refreshUI,
        cbIsMounted: isMounted,
        cbNavigation: navigation,
        scanType: ScanType.barcode);
    _mobileCamera.initState();
  }

  void navigation() {
    var random = Random();
    var element = mockOrders[random.nextInt(mockOrders.length)];
    orders.add(element);
    routes.removeLast();
    Navigator.of(context).pop();
  }

  void refreshUI() {
    setState(() {});
  }

  bool isMounted() {
    return mounted;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _mobileCamera.stopVideo();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_mobileCamera.controller == null ||
        !_mobileCamera.controller!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _mobileCamera.controller!.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _mobileCamera.toggleCamera(0);
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
              'Scan Package Barcode',
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
              if (_mobileCamera.controller != null &&
                  _mobileCamera.previewSize != null)
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  bottom: 0,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Stack(
                      children: [
                        if (_mobileCamera.controller != null &&
                            _mobileCamera.previewSize != null)
                          SizedBox(
                              width: MediaQuery.of(context).size.width <
                                      MediaQuery.of(context).size.height
                                  ? _mobileCamera.previewSize!.height
                                  : _mobileCamera.previewSize!.width,
                              height: MediaQuery.of(context).size.width <
                                      MediaQuery.of(context).size.height
                                  ? _mobileCamera.previewSize!.width
                                  : _mobileCamera.previewSize!.height,
                              child: _mobileCamera.getPreview()),
                        Positioned(
                          top: 0.0,
                          right: 0.0,
                          bottom: 0,
                          left: 0.0,
                          child: createOverlay(_mobileCamera.barcodeResults,
                              _mobileCamera.mrzLines),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ));
  }
}
