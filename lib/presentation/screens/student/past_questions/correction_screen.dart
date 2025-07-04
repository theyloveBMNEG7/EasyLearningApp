import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/utils/local_question_storage.dart';

class CorrectionScreen extends StatefulWidget {
  final Map<String, String> data;

  const CorrectionScreen({super.key, required this.data});

  @override
  State<CorrectionScreen> createState() => _CorrectionScreenState();
}

class _CorrectionScreenState extends State<CorrectionScreen> {
  String? localPdfPath;
  bool isLoading = true;
  bool isReviewed = false;

  @override
  void initState() {
    super.initState();
    _loadPdfAndStatus();
  }

  Future<void> _loadPdfAndStatus() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/${widget.data['title']}.pdf';

      await Dio().download(widget.data['pdfUrl']!, filePath);

      final reviewed = await LocalQuestionStorage.getReviewedQuestions();
      setState(() {
        localPdfPath = filePath;
        isReviewed = reviewed.contains(widget.data['title']);
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load PDF: $e')),
      );
    }
  }

  Future<void> _markAsReviewed() async {
    await LocalQuestionStorage.markAsReviewed(widget.data['title']!);
    setState(() => isReviewed = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Marked as reviewed')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.data['title'] ?? 'Correction';
    final subject = widget.data['subject'] ?? '';
    final level = widget.data['level'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blueAccent,
        actions: [
          if (!isReviewed)
            IconButton(
              icon: const Icon(Icons.check_circle_outline),
              tooltip: 'Mark as Reviewed',
              onPressed: _markAsReviewed,
            )
          else
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.verified, color: Colors.green),
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : localPdfPath == null
              ? const Center(child: Text('Failed to load PDF.'))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        '$subject • $level',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: PDFView(
                        filePath: localPdfPath!,
                        enableSwipe: true,
                        swipeHorizontal: false,
                        autoSpacing: true,
                        pageFling: true,
                      ),
                    ),
                  ],
                ),
    );
  }
}
