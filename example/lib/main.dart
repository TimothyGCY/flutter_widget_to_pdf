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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 56, child: FlutterLogo()),
              Text(
                'Row1',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                'Row2',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                'Row3',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                'Row4',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                'Row5',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: _pdfController.savePdf,
              tooltip: 'Save to file',
              child: Icon(Icons.print_outlined),
            ),
            const SizedBox(width: 24),
            FloatingActionButton(
              onPressed: _pdfController.sharePdf,
              tooltip: 'Share',
              child: Icon(Icons.share_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
