import 'dart:typed_data';

/// Parameters to be passed to native
class PdfArgs {
  final String? filename;
  final Uint8List imageBytes;

  const PdfArgs({required this.imageBytes, this.filename});

  Map<String, dynamic> toJson() => {
        'filename': filename,
        'imageBytes': imageBytes,
      };
}
