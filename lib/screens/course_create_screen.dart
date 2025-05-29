import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satnusa_test/screens/quiz_form_screen.dart';
import '../models/course.dart';
import '../models/material.dart';
import '../models/quiz.dart';
import '../models/trainer.dart';
import '../providers/course_provider.dart';
import '../widgets/material_form.dart';
import '../widgets/quiz_form.dart';

class CourseCreateScreen extends StatefulWidget {
  const CourseCreateScreen({Key? key}) : super(key: key);

  @override
  _CourseCreateScreenState createState() => _CourseCreateScreenState();
}

class _CourseCreateScreenState extends State<CourseCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _courseImageUrlController = TextEditingController();
  final _trainerNameController = TextEditingController();
  final _trainerTitleController = TextEditingController();
  final _trainerImageUrlController = TextEditingController();

  List<CourseMaterial> _materials = [];
  List<Quiz> _quizzes = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _courseImageUrlController.dispose();
    _trainerNameController.dispose();
    _trainerTitleController.dispose();
    _trainerImageUrlController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = "${picked.toLocal()}".split(' ')[0];
    }
  }

  void _addMaterial(CourseMaterial material) {
    setState(() {
      _materials.add(material);
    });
  }

  void _addQuiz(Quiz quiz) {
    setState(() {
      _quizzes.add(quiz);
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final course = Course(
      title: _titleController.text,
      description: _descriptionController.text,
      startDate: _startDateController.text,
      endDate: _endDateController.text,
      courseImageUrl: _courseImageUrlController.text,
      trainer: Trainer(
        name: _trainerNameController.text,
        title: _trainerTitleController.text,
        imageUrl: _trainerImageUrlController.text,
      ),
      materials: _materials,
      quizzes: _quizzes,
    );

    try {
      await Provider.of<CourseProvider>(context, listen: false)
          .addCourse(course);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Course created successfully!')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create course: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Course'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Course Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _startDateController,
                      decoration:
                          const InputDecoration(labelText: 'Start Date'),
                      readOnly: true,
                      onTap: () => _selectDate(context, _startDateController),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a start date';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _endDateController,
                      decoration: const InputDecoration(labelText: 'End Date'),
                      readOnly: true,
                      onTap: () => _selectDate(context, _endDateController),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select an end date';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _courseImageUrlController,
                decoration:
                    const InputDecoration(labelText: 'Course Image URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Trainer Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _trainerNameController,
                decoration: const InputDecoration(labelText: 'Trainer Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter trainer name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _trainerTitleController,
                decoration: const InputDecoration(labelText: 'Trainer Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter trainer title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _trainerImageUrlController,
                decoration:
                    const InputDecoration(labelText: 'Trainer Image URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter trainer image URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Course Materials',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              MaterialForm(onAddMaterial: _addMaterial),
              ..._materials.map((material) => ListTile(
                    title: Text(material.title),
                    subtitle: Text(material.youtubeUrl),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _materials.remove(material);
                        });
                      },
                    ),
                  )),
              const SizedBox(height: 16),
              const Text('Quizzes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const QuizFormScreen()),
                  );
                  if (result != null && result is Quiz) {
                    _addQuiz(result);
                  }
                },
                child: const Text('Add New Quiz'),
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Create Course'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
