# flutter_widget_to_pdf

A Flutter plugin to convert widgets into PDF

## Installation

```yaml
# This plugin is yet to be published, so let's just still with using Git URL
dependencies:
  flutter_widget_to_pdf:
    url: https://github.com/TimothyGCY/flutter_widget_to_pdf.git
```

## Usage

```dart
// Create a key
final GlobalKey _pdfKey = GlobalKey();
// Instantiate a PDF controller
final PdfController _pdfController = PdfController();

// Wrap the widget you wished to be in PDF using `PdfWrapper`
@override
Widget build(BuildContext context) {
    return Scaffold(
      body: PdfWrapper(
        wrapperKey: _pdfKey,
        controller: _pdfController,
        children: [
          // Widgets to be included into PDF
        ],
      ),
    );
}

// Save PDF to local device
void savePDF() {
    _pdfController.savePdf();
}

// Share PDF to somewhere else
void sharePDF() {
    _pdfController.sharePdf();
}
```

> **> [!NOTE]
> For Web, `sharePdf()` works exactly the same as `savePdf()`
