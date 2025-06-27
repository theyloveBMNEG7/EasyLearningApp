import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../layouts/student/student_layout.dart';

class PastQuestionSection extends StatelessWidget {
  const PastQuestionSection({super.key});

  final List<Map<String, String>> _pastPapers = const [
    {
      'subject': 'Biology',
      'file': 'bio_2024.pdf',
      'image': 'assets/images/biology.jpg',
    },
    {
      'subject': 'Accounting',
      'file': 'acct_2023.pdf',
      'image': 'assets/images/accounting.jpg',
    },
    {
      'subject': 'Chemistry',
      'file': 'chem_2022.pdf',
      'image': 'assets/images/chemistry.jpg',
    },
    {
      'subject': 'Literature',
      'file': 'lit_2024.pdf',
      'image': 'assets/images/literature.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title & View All
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Popular Courses',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w900,
                fontFamily: 'OpenSans',
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StudentLayout(initialIndex: 1),
                  ),
                );
              },
              child: const Text(
                'View All',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // GridView for Past Papers
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _pastPapers.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, index) {
            final paper = _pastPapers[index];

            return Material(
              borderRadius: BorderRadius.circular(14),
              elevation: 3,
              color: Colors.white,
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {}, // Optional: PDF preview
                child: Column(
                  children: [
                    // Image Top
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(14)),
                      child: Image.asset(
                        paper['image']!,
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Subject name below image
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            paper['subject']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )),

                    const Spacer(),

                    // Action icons
                    Padding(
                      padding: const EdgeInsets.only(right: 6, bottom: 6),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const FaIcon(FontAwesomeIcons.download,
                                  size: 15, color: Colors.greenAccent),
                              tooltip: 'Download',
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const FaIcon(
                                  FontAwesomeIcons.shareFromSquare,
                                  size: 15,
                                  color: Colors.blueAccent),
                              tooltip: 'Share',
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const FaIcon(FontAwesomeIcons.trashCan,
                                  size: 15, color: Colors.redAccent),
                              tooltip: 'Delete',
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
