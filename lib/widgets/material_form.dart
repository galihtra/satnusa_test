import 'package:flutter/material.dart';
import '../models/material.dart';

class MaterialForm extends StatefulWidget {
  final Function(CourseMaterial) onAddMaterial;

  const MaterialForm({Key? key, required this.onAddMaterial}) : super(key: key);

  @override
  _MaterialFormState createState() => _MaterialFormState();
}

class _MaterialFormState extends State<MaterialForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _youtubeUrlController = TextEditingController();
  final _durationController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _youtubeUrlController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final material = CourseMaterial(
        title: _titleController.text,
        youtubeUrl: _youtubeUrlController.text,
        duration: _durationController.text,
        progress: 0.0,
      );
      widget.onAddMaterial(material);
      _titleController.clear();
      _youtubeUrlController.clear();
      _durationController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Material Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _youtubeUrlController,
                decoration: const InputDecoration(labelText: 'YouTube URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a YouTube URL';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(labelText: 'Duration (HH:MM)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter duration';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Add Material'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}