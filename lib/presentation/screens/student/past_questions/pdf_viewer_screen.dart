import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class PdfViewerScreen extends StatelessWidget {
  final String title;
  final String pdfUrl;

  const PdfViewerScreen({
    super.key,
    required this.title,
    required this.pdfUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, overflow: TextOverflow.ellipsis),
      ),
      body: const Center(child: CircularProgressIndicator()),
      bottomSheet: SizedBox(
        height: MediaQuery.of(context).size.height - kToolbarHeight,
        child: PDF().cachedFromUrl(
          pdfUrl,
          placeholder: (progress) =>
              Center(child: Text('Loading... $progress%')),
          errorWidget: (error) =>
              Center(child: Text('Failed to load PDF: $error')),
        ),
      ),
    );
  }
}
