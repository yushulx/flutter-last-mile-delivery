import 'package:flutter/material.dart';
import 'package:flutter_barcode_sdk/dynamsoft_barcode.dart';
import 'package:flutter_barcode_sdk/flutter_barcode_sdk.dart';
import 'package:flutter_document_scan_sdk/flutter_document_scan_sdk.dart';
import 'package:flutter_ocr_sdk/flutter_ocr_sdk.dart';
import 'package:flutter_ocr_sdk/mrz_line.dart';

import 'data/profile_data.dart';

List<MaterialPageRoute> routes = [];
ProfileData data = ProfileData();
FlutterBarcodeSdk barcodeReader = FlutterBarcodeSdk();
FlutterOcrSdk mrzDetector = FlutterOcrSdk();
FlutterDocumentScanSdk docScanner = FlutterDocumentScanSdk();
int NOT_CHECKED = -10;
int licenseStatus = NOT_CHECKED;

Future<void> initBarcodeSDK() async {
  await barcodeReader.setLicense(
      'DLS2eyJoYW5kc2hha2VDb2RlIjoiMjAwMDAxLTE2NDk4Mjk3OTI2MzUiLCJvcmdhbml6YXRpb25JRCI6IjIwMDAwMSIsInNlc3Npb25QYXNzd29yZCI6IndTcGR6Vm05WDJrcEQ5YUoifQ==');
  await barcodeReader.init();
  await barcodeReader.setBarcodeFormats(BarcodeFormat.ALL);
}

Future<void> initMRZSDK() async {
  await mrzDetector.init(
      "DLS2eyJoYW5kc2hha2VDb2RlIjoiMjAwMDAxLTE2NDk4Mjk3OTI2MzUiLCJvcmdhbml6YXRpb25JRCI6IjIwMDAwMSIsInNlc3Npb25QYXNzd29yZCI6IndTcGR6Vm05WDJrcEQ5YUoifQ==");
  await mrzDetector.loadModel();
}

Future<void> initDocumentSDK() async {
  await docScanner.init(
      'DLS2eyJoYW5kc2hha2VDb2RlIjoiMjAwMDAxLTE2NDk4Mjk3OTI2MzUiLCJvcmdhbml6YXRpb25JRCI6IjIwMDAwMSIsInNlc3Npb25QYXNzd29yZCI6IndTcGR6Vm05WDJrcEQ5YUoifQ==');
}

List<BarcodeResult> rotate90barcode(List<BarcodeResult> input, int height) {
  List<BarcodeResult> output = [];
  for (BarcodeResult result in input) {
    int x1 = result.x1;
    int x2 = result.x2;
    int x3 = result.x3;
    int x4 = result.x4;
    int y1 = result.y1;
    int y2 = result.y2;
    int y3 = result.y3;
    int y4 = result.y4;

    BarcodeResult newResult = BarcodeResult(
        result.format,
        result.text,
        height - y1,
        x1,
        height - y2,
        x2,
        height - y3,
        x3,
        height - y4,
        x4,
        result.angle,
        result.barcodeBytes);

    output.add(newResult);
  }

  return output;
}

List<List<MrzLine>> rotate90mrz(List<List<MrzLine>> input, int height) {
  List<List<MrzLine>> output = [];

  for (List<MrzLine> area in input) {
    List<MrzLine> tmp = [];
    for (int i = 0; i < area.length; i++) {
      MrzLine line = area[i];
      int x1 = line.x1;
      int x2 = line.x2;
      int x3 = line.x3;
      int x4 = line.x4;
      int y1 = line.y1;
      int y2 = line.y2;
      int y3 = line.y3;
      int y4 = line.y4;

      MrzLine newline = MrzLine();
      newline.confidence = line.confidence;
      newline.text = line.text;
      newline.x1 = height - y1;
      newline.y1 = x1;
      newline.x2 = height - y2;
      newline.y2 = x2;
      newline.x3 = height - y3;
      newline.y3 = x3;
      newline.x4 = height - y4;
      newline.y4 = x4;

      tmp.add(newline);
    }
    output.add(tmp);
  }

  return output;
}

Widget createOverlay(
    List<BarcodeResult>? barcodeResults, List<List<MrzLine>>? mrzResults) {
  return CustomPaint(
    painter: OverlayPainter(barcodeResults, mrzResults),
  );
}

class OverlayPainter extends CustomPainter {
  List<BarcodeResult>? barcodeResults;
  List<List<MrzLine>>? mrzResults;

  OverlayPainter(this.barcodeResults, this.mrzResults);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    if (barcodeResults != null) {
      for (var result in barcodeResults!) {
        double minX = result.x1.toDouble();
        double minY = result.y1.toDouble();
        if (result.x2 < minX) minX = result.x2.toDouble();
        if (result.x3 < minX) minX = result.x3.toDouble();
        if (result.x4 < minX) minX = result.x4.toDouble();
        if (result.y2 < minY) minY = result.y2.toDouble();
        if (result.y3 < minY) minY = result.y3.toDouble();
        if (result.y4 < minY) minY = result.y4.toDouble();

        canvas.drawLine(Offset(result.x1.toDouble(), result.y1.toDouble()),
            Offset(result.x2.toDouble(), result.y2.toDouble()), paint);
        canvas.drawLine(Offset(result.x2.toDouble(), result.y2.toDouble()),
            Offset(result.x3.toDouble(), result.y3.toDouble()), paint);
        canvas.drawLine(Offset(result.x3.toDouble(), result.y3.toDouble()),
            Offset(result.x4.toDouble(), result.y4.toDouble()), paint);
        canvas.drawLine(Offset(result.x4.toDouble(), result.y4.toDouble()),
            Offset(result.x1.toDouble(), result.y1.toDouble()), paint);

        TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: result.text,
            style: const TextStyle(
              color: Colors.yellow,
              fontSize: 22.0,
            ),
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout(minWidth: 0, maxWidth: size.width);
        textPainter.paint(canvas, Offset(minX, minY));
      }
    }

    if (mrzResults != null) {
      for (List<MrzLine> area in mrzResults!) {
        for (MrzLine line in area) {
          canvas.drawLine(Offset(line.x1.toDouble(), line.y1.toDouble()),
              Offset(line.x2.toDouble(), line.y2.toDouble()), paint);
          canvas.drawLine(Offset(line.x2.toDouble(), line.y2.toDouble()),
              Offset(line.x3.toDouble(), line.y3.toDouble()), paint);
          canvas.drawLine(Offset(line.x3.toDouble(), line.y3.toDouble()),
              Offset(line.x4.toDouble(), line.y4.toDouble()), paint);
          canvas.drawLine(Offset(line.x4.toDouble(), line.y4.toDouble()),
              Offset(line.x1.toDouble(), line.y1.toDouble()), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(OverlayPainter oldDelegate) => true;
}
