import 'dart:typed_data';

import 'package:flutter_widget_to_pdf/PdfArgs.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_widget_to_pdf_method_channel.dart';

abstract class FlutterWidgetToPdfPlatform extends PlatformInterface {
  /// Constructs a FlutterWidgetToPdfPlatform.
  FlutterWidgetToPdfPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterWidgetToPdfPlatform _instance = MethodChannelFlutterWidgetToPdf();

  /// The default instance of [FlutterWidgetToPdfPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterWidgetToPdf].
  static FlutterWidgetToPdfPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterWidgetToPdfPlatform] when
  /// they register themselves.
  static set instance(FlutterWidgetToPdfPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Save PDF to local file system
  Future<bool> savePdf(PdfArgs args);

  /// Share PDF to third-party applications
  Future<void> sharePdf(PdfArgs args);
}
