import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_to_pdf/PdfArgs.dart';

import 'flutter_widget_to_pdf_platform_interface.dart';

/// An implementation of [FlutterWidgetToPdfPlatform] that uses method channels.
class MethodChannelFlutterWidgetToPdf extends FlutterWidgetToPdfPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_widget_to_pdf');

  @override
  Future<bool> savePdf(PdfArgs args) async {
    return await methodChannel.invokeMethod('SAVE_PDF', args.toJson());
  }

  @override
  Future<void> sharePdf(PdfArgs args) async {
    await methodChannel.invokeMethod('SHARE_PDF', args.toJson());
  }
}
