import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleClassScreen extends StatefulWidget {
  const ScheduleClassScreen({super.key});

  @override
  State<ScheduleClassScreen> createState() => _ScheduleClassScreenState();
}

class _ScheduleClassScreenState extends State<ScheduleClassScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedLevel;

  final List<String> levels = ['L1', 'L2', 'HND1', 'HND2', 'BTS1', 'BTS2'];

  Future<void> _submitSchedule() async {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _selectedTime != null) {
      try {
        final DateTime fullDateTime = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        );

        final scheduleData = {
          'subject': _subjectController.text.trim(),
          'note': _noteController.text.trim(),
          'level': _selectedLevel,
          'scheduled_at': fullDateTime.toIso8601String(),
          'created_at': DateTime.now().toIso8601String(),
        };

        await FirebaseFirestore.instance
            .collection('schedules')
            .add(scheduleData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Class scheduled successfully")),
        );

        _formKey.currentState!.reset();
        setState(() {
          _selectedDate = null;
          _selectedTime = null;
          _selectedLevel = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Failed to schedule class: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please complete all fields")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Schedule Live Class",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField("Subject", _subjectController),
                  const SizedBox(height: 16),
                  _buildDropdownField("Select Level", levels),
                  const SizedBox(height: 16),
                  _buildDatePicker(context),
                  const SizedBox(height: 16),
                  _buildTimePicker(context),
                  const SizedBox(height: 16),
                  _buildTextField("Optional Notes", _noteController,
                      maxLines: 3),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _submitSchedule,
                      icon: const Icon(Icons.schedule, color: Colors.white),
                      label: const Text(
                        "Schedule Class",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: (value) =>
          value == null || value.isEmpty ? 'Please enter $label' : null,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> items) {
    return DropdownButtonFormField<String>(
      value: _selectedLevel,
      hint: Text(label),
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: (value) => setState(() => _selectedLevel = value),
      validator: (value) => value == null ? 'Please select a level' : null,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        if (date != null) setState(() => _selectedDate = date);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Select Date',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(
          _selectedDate != null
              ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
              : 'Tap to pick date',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildTimePicker(BuildContext context) {
    return InkWell(
      onTap: () async {
        final time = await showTimePicker(
            context: context, initialTime: TimeOfDay.now());
        if (time != null) setState(() => _selectedTime = time);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Select Time',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(
          _selectedTime != null
              ? _selectedTime!.format(context)
              : 'Tap to pick time',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
