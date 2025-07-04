import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/auth_service.dart';

class CreateTeacherScreen extends StatefulWidget {
  const CreateTeacherScreen({super.key});

  @override
  State<CreateTeacherScreen> createState() => _CreateTeacherScreenState();
}

class _CreateTeacherScreenState extends State<CreateTeacherScreen> {
  final _formKey = GlobalKey<FormState>();
  final _uidController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _examTypeController = TextEditingController();
  final _specialityController = TextEditingController();

  final _authService = AuthService();

  Future<void> _createTeacher() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _authService.createTeacher(
          uid: _uidController.text.trim(),
          email: _emailController.text.trim(),
          displayName: _nameController.text.trim(),
          mappedExamType: _examTypeController.text.trim(),
          mappedSpeciality: _specialityController.text.trim(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Teacher created successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Teacher')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _uidController,
                decoration: const InputDecoration(labelText: 'Teacher UID'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _examTypeController,
                decoration:
                    const InputDecoration(labelText: 'Mapped Exam Type'),
              ),
              TextFormField(
                controller: _specialityController,
                decoration:
                    const InputDecoration(labelText: 'Mapped Speciality'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createTeacher,
                child: const Text('Create Teacher'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
