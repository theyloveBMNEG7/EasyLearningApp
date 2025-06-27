import 'package:flutter/material.dart';
import '../../../data/models/tutorial_model.dart';

class TutorialCard extends StatelessWidget {
  final Tutorial tutorial;
  final VoidCallback onTap;

  const TutorialCard({super.key, required this.tutorial, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail image
            Image.asset(
              tutorial.image,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            // Title & meta
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tutorial.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Spacer(),
                      const Icon(Icons.person, size: 14, color: Colors.black54),
                      const SizedBox(width: 4),
                      Text(
                        'Teacher Upload',
                        style: const TextStyle(
                            fontSize: 11, color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
