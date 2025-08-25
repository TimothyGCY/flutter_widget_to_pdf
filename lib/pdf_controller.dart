import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_widget_to_pdf/PdfArgs.dart';
import 'package:flutter_widget_to_pdf/flutter_widget_to_pdf.dart';

class PdfController {
  late GlobalKey pdfKey;

  Future<Uint8List> _convertToImage() async {
    final BuildContext? context = pdfKey.currentContext;
    if (context == null) {
      throw StateError("Context not found");
    }

    RenderRepaintBoundary boundary =
        context.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 2.0);
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    if (byteData == null) {
      throw Exception("Failed to generate image");
    }

    return byteData.buffer.asUint8List();
  }

  Future<bool> savePdf({String? filename}) async {
    return FlutterWidgetToPdf().savePdf(
        PdfArgs(imageBytes: await _convertToImage(), filename: filename));
  }

  Future<void> sharePdf({String? filename}) async {
    FlutterWidgetToPdf().sharePdf(
        PdfArgs(imageBytes: await _convertToImage(), filename: filename));
  }
}
