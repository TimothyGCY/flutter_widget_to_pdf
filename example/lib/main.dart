import 'package:flutter/material.dart';

import 'package:flutter_widget_to_pdf/flutter_widget_to_pdf.dart';
import 'package:flutter_widget_to_pdf/pdf_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey _pdfKey = GlobalKey();
  final PdfController _pdfController = PdfController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: PdfWrapper(
          wrapperKey: _pdfKey,
          controller: _pdfController,
          child: Column(
            children: [
              Text('Row1'),
              Text('Row2'),
              Text('Row3'),
              Text('Row4'),
              Text('Row5'),
            ],
          ),
        ),
        floatingActionButton:
            FloatingActionButton(onPressed: _pdfController.savePdf),
      ),
    );
  }
}
