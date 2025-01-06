import 'dart:typed_data';

import 'package:flutter_widget_to_pdf/PdfArgs.dart';

import 'flutter_widget_to_pdf_platform_interface.dart';

export 'package:flutter_widget_to_pdf/pdf_wrapper.dart';

class FlutterWidgetToPdf {
  final FlutterWidgetToPdfPlatform _plugin =
      FlutterWidgetToPdfPlatform.instance;

  Future<bool> savePdf(PdfArgs args) async =>
      await _plugin.savePdf(args);

  Future<void> sharePdf(PdfArgs args) async =>
      await _plugin.sharePdf(args);
}
