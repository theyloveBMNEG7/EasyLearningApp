import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../../../widgets/past_questions/question_card.dart';
import '../../../widgets/past_questions/subject_filter_bar.dart';
import '../../../../data/models/past_question_model.dart';
import '../past_questions/pdf_viewer_screen.dart';

class PastQuestionScreen extends StatefulWidget {
  const PastQuestionScreen({super.key});

  @override
  State<PastQuestionScreen> createState() => _PastQuestionScreenState();
}

class _PastQuestionScreenState extends State<PastQuestionScreen> {
  String selectedSubject = 'All';
  List<PastQuestionModel> allQuestions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPastQuestions();
  }

  Future<void> _fetchPastQuestions() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('past_questions')
        .orderBy('createdAt', descending: true)
        .get();

    final questions = snapshot.docs.map((doc) {
      return PastQuestionModel.fromMap(
        doc.id,
        doc.data() as Map<String, dynamic>,
      );
    }).toList();

    setState(() {
      allQuestions = questions;
      isLoading = false;
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
    final subjects = [
      'All',
      ...{for (var q in allQuestions) q.subject}
    ];

    final filtered = selectedSubject == 'All'
        ? allQuestions
        : allQuestions.where((q) => q.subject == selectedSubject).toList();

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              SubjectFilterBar(
                subjects: subjects,
                selectedSubject: selectedSubject,
                onSelected: (subject) {
                  setState(() => selectedSubject = subject);
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(child: Text('No past questions found.'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final q = filtered[index];
                          return Column(
                            children: [
                              QuestionCard(
                                subject: q.subject,
                                year: q.createdAt.year.toString(),
                                question: q.title,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PdfViewerScreen(
                                        title: q.title,
                                        pdfUrl: q.pdfUrl,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                  onPressed: () => _downloadPdf(
                                    q.pdfUrl,
                                    '${q.title}.pdf',
                                  ),
                                  icon: const Icon(Icons.download,
                                      color: Colors.green),
                                  label: const Text('Download'),
                                ),
                              ),
                              const Divider(height: 24),
                            ],
                          );
                        },
                      ),
              ),
            ],
          );
  }
}
