// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter_widget_to_pdf/PdfArgs.dart';

import 'flutter_widget_to_pdf_platform_interface.dart';

/// A web implementation of the FlutterWidgetToPdfPlatform of the FlutterWidgetToPdf plugin.
class FlutterWidgetToPdfWeb extends FlutterWidgetToPdfPlatform {
  /// Constructs a FlutterWidgetToPdfWeb
  FlutterWidgetToPdfWeb();

  static void registerWith(Registrar registrar) {
    FlutterWidgetToPdfPlatform.instance = FlutterWidgetToPdfWeb();
  }

  bool _downloadPdf(Uint8List bytes, {String? filename}) {
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..download = '${filename ?? DateTime.now().microsecondsSinceEpoch}.pdf'
      ..click();
    return true;
  }

  @override
  Future<bool> savePdf(PdfArgs args) async {
    return _downloadPdf(args.imageBytes, filename: args.filename);
  }

  @override
  Future<void> sharePdf(PdfArgs args) async {
    _downloadPdf(args.imageBytes);
  }
}
