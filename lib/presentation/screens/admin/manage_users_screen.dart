import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminUserManagementScreen extends StatefulWidget {
  const AdminUserManagementScreen({super.key});

  @override
  State<AdminUserManagementScreen> createState() =>
      _AdminUserManagementScreenState();
}

class _AdminUserManagementScreenState extends State<AdminUserManagementScreen> {
  String _selectedRole = 'all';

  @override
  Widget build(BuildContext context) {
    final query = FirebaseFirestore.instance.collection('users');

    final filteredQuery = _selectedRole == 'all'
        ? query
        : query.where('role', isEqualTo: _selectedRole);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Users"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Text("Filter by role: "),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedRole,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text("All")),
                    DropdownMenuItem(value: 'student', child: Text("Students")),
                    DropdownMenuItem(value: 'teacher', child: Text("Teachers")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: filteredQuery.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return const Center(child: CircularProgressIndicator());

                final users = snapshot.data!.docs;

                if (users.isEmpty) {
                  return const Center(child: Text("No users found."));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: users.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final doc = users[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final name = data['name'] ?? 'Unnamed';
                    final email = data['email'] ?? 'No email';
                    final role = data['role'] ?? 'unknown';
                    final isActive = data['isActive'] ?? true;

                    return ListTile(
                      tileColor: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      leading: CircleAvatar(
                        backgroundColor:
                            role == 'teacher' ? Colors.green : Colors.blue,
                        child: Text(name[0].toUpperCase()),
                      ),
                      title: Text(name),
                      subtitle: Text('$email\nRole: $role'),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch(
                            value: isActive,
                            onChanged: (value) {
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(doc.id)
                                  .update({'isActive': value});
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                _confirmDeleteUser(context, doc.id, name),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteUser(BuildContext context, String userId, String name) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete User"),
        content: Text(
            "Are you sure you want to delete $name? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .delete();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("$name has been deleted.")),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
