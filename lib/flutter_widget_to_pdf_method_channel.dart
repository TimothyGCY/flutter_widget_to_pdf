import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_widget_to_pdf_platform_interface.dart';

/// An implementation of [FlutterWidgetToPdfPlatform] that uses method channels.
class MethodChannelFlutterWidgetToPdf extends FlutterWidgetToPdfPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_widget_to_pdf');

  @override
  Future<bool> savePdf(Uint8List byteData, {String? filename}) async {
    return await methodChannel.invokeMethod('SAVE_PDF', {
      'imageBytes': byteData,
      'filename': filename,
    });
  }

  @override
  Future<void> sharePdf(Uint8List byteData) async {
    await methodChannel.invokeMethod('SHARE_PDF', {'imageByte': byteData});
  }
}
