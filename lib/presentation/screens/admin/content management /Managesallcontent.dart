import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageAllContentTab extends StatelessWidget {
  const ManageAllContentTab({super.key});

  final List<String> collections = const [
    'tutorials',
    'past_questions',
    'corrections',
    'books',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: collections.map((collection) {
        return ExpansionTile(
          title: Text(collection.replaceAll('_', ' ').toUpperCase()),
          children: [
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection(collection).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) return const Text("No content found.");

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final title = data['title'] ?? data['topic'] ?? 'Untitled';

                    return ListTile(
                      title: Text(title),
                      subtitle: Text("ID: ${doc.id}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              // TODO: Navigate to edit screen
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection(collection)
                                  .doc(doc.id)
                                  .delete();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text("Deleted from $collection")),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        );
      }).toList(),
    );
  }
}
