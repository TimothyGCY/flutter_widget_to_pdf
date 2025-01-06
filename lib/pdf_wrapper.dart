import 'package:flutter/material.dart';
import 'package:flutter_widget_to_pdf/pdf_controller.dart';

class PdfWrapper extends StatefulWidget {
  final Widget child;
  final PdfController controller;
  final GlobalKey wrapperKey;

  PdfWrapper({
    super.key,
    required this.wrapperKey,
    required this.child,
    required this.controller,
  }) {
    controller.pdfKey = wrapperKey;
  }

  @override
  State<PdfWrapper> createState() => _PdfWrapperState();
}

class _PdfWrapperState extends State<PdfWrapper> {
  final GlobalKey wrapperKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(key: widget.wrapperKey, child: widget.child);
  }
}
