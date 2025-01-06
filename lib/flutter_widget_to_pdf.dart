import 'dart:typed_data';

import 'flutter_widget_to_pdf_platform_interface.dart';

export 'package:flutter_widget_to_pdf/pdf_wrapper.dart';

class FlutterWidgetToPdf {
  final FlutterWidgetToPdfPlatform _plugin =
      FlutterWidgetToPdfPlatform.instance;

  Future<bool> savePdf(Uint8List byteData, {String? filename}) async =>
      await _plugin.savePdf(byteData, filename: filename);

  Future<void> sharePdf(Uint8List byteData) async =>
      await _plugin.sharePdf(byteData);
}
