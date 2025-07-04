import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../../../widgets/past_questions/question_card.dart';
import '../../../../data/models/correction_model.dart';
import '../../../../core/utils/local_question_storage.dart';
import 'correction_screen.dart';

class ReviewedQuestionScreen extends StatefulWidget {
  const ReviewedQuestionScreen({super.key});

  @override
  State<ReviewedQuestionScreen> createState() => _ReviewedQuestionScreenState();
}

class _ReviewedQuestionScreenState extends State<ReviewedQuestionScreen> {
  List<CorrectionModel> allCorrections = [];
  Set<String> reviewedTitles = {};
  bool showOnlyReviewed = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('reviewed_questions')
        .orderBy('createdAt', descending: true)
        .get();

    final corrections = snapshot.docs.map((doc) {
      return CorrectionModel.fromMap(
          doc.id, doc.data() as Map<String, dynamic>);
    }).toList();

    final reviewed = await LocalQuestionStorage.getReviewedQuestions();

    setState(() {
      allCorrections = corrections;
      reviewedTitles = reviewed.toSet();
    });
  }

  Future<void> _downloadPdf(String url, String filename) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/$filename';

      final file = File(filePath);
      if (await file.exists()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Already downloaded: $filePath')),
        );
        return;
      }

      await Dio().download(url, filePath);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Downloaded to $filePath')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibleCorrections = showOnlyReviewed
        ? allCorrections.where((c) => reviewedTitles.contains(c.title)).toList()
        : allCorrections;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviewed Corrections'),
        actions: [
          IconButton(
            icon: Icon(
              showOnlyReviewed ? Icons.visibility_off : Icons.visibility,
            ),
            tooltip: showOnlyReviewed ? 'Show All' : 'Show Only Reviewed',
            onPressed: () {
              setState(() => showOnlyReviewed = !showOnlyReviewed);
            },
          ),
        ],
      ),
      body: visibleCorrections.isEmpty
          ? const Center(
              child: Text(
                '⭐ No corrections to display.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: visibleCorrections.length,
              itemBuilder: (context, index) {
                final correction = visibleCorrections[index];
                final isReviewed = reviewedTitles.contains(correction.title);

                return Column(
                  children: [
                    Stack(
                      children: [
                        QuestionCard(
                          subject: correction.subject,
                          year: correction.createdAt.year.toString(),
                          question: correction.title,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CorrectionScreen(data: {
                                  'title': correction.title,
                                  'description': correction.description,
                                  'pdfUrl': correction.pdfUrl,
                                  'subject': correction.subject,
                                  'level': correction.level,
                                }),
                              ),
                            ).then((_) => _loadData());
                          },
                        ),
                        if (isReviewed)
                          const Positioned(
                            top: 8,
                            right: 12,
                            child:
                                Icon(Icons.check_circle, color: Colors.green),
                          ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () => _downloadPdf(
                          correction.pdfUrl,
                          '${correction.title}.pdf',
                        ),
                        icon: const Icon(Icons.download, color: Colors.green),
                        label: const Text('Download'),
                      ),
                    ),
                    const Divider(height: 24),
                  ],
                );
              },
            ),
    );
  }
}
