import 'package:flutter/material.dart';
import '../models/quiz.dart';
import '../models/question.dart';

class QuizForm extends StatefulWidget {
  final Function(Quiz) onAddQuiz;

  const QuizForm({Key? key, required this.onAddQuiz}) : super(key: key);

  @override
  _QuizFormState createState() => _QuizFormState();
}

class _QuizFormState extends State<QuizForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final List<Question> _questions = [];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _addQuestion(Question question) {
    setState(() {
      _questions.add(question);
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _questions.isNotEmpty) {
      final quiz = Quiz(
        title: _titleController.text,
        questions: _questions,
      );
      widget.onAddQuiz(quiz);
      _titleController.clear();
      setState(() {
        _questions.clear();
      });
    } else if (_questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one question')),
      );
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
                decoration: const InputDecoration(labelText: 'Quiz Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              const Text('Questions', style: TextStyle(fontWeight: FontWeight.bold)),
              ..._questions.map((question) => ListTile(
                title: Text(question.question),
                subtitle: Text('Type: ${question.type}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _questions.remove(question);
                    });
                  },
                ),
              )),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _showAddQuestionDialog(context),
                child: const Text('Add Question'),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Add Quiz'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showAddQuestionDialog(BuildContext context) async {
  final questionController = TextEditingController();
  String questionType = 'single';
  final List<TextEditingController> optionControllers = [
    TextEditingController(),
    TextEditingController(),
  ];
  final List<String> optionValues = ['', '']; // Store option values separately
  final List<bool> isOptionCorrect = [false, false]; // Track correct options

  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add New Question'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: questionController,
                    decoration: const InputDecoration(labelText: 'Question'),
                  ),
                  DropdownButton<String>(
                    value: questionType,
                    items: const [
                      DropdownMenuItem(value: 'single', child: Text('Single Choice')),
                      DropdownMenuItem(value: 'multiple', child: Text('Multiple Choice')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        questionType = value!;
                        // Reset all selections when type changes
                        for (int i = 0; i < isOptionCorrect.length; i++) {
                          isOptionCorrect[i] = false;
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text('Options', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...optionControllers.asMap().entries.map((entry) {
                    final index = entry.key;
                    final controller = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller,
                              decoration: const InputDecoration(hintText: 'Option'),
                              onChanged: (value) {
                                optionValues[index] = value;
                              },
                            ),
                          ),
                          Checkbox(
                            value: isOptionCorrect[index],
                            onChanged: (value) {
                              setState(() {
                                if (questionType == 'single' && value == true) {
                                  // For single choice, uncheck all others
                                  for (int i = 0; i < isOptionCorrect.length; i++) {
                                    isOptionCorrect[i] = false;
                                  }
                                }
                                isOptionCorrect[index] = value ?? false;
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  }),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        optionControllers.add(TextEditingController());
                        optionValues.add('');
                        isOptionCorrect.add(false);
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  // Validate inputs
                  if (questionController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a question')),
                    );
                    return;
                  }

                  if (optionValues.any((value) => value.isEmpty)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all options')),
                    );
                    return;
                  }

                  // Collect correct answers
                  final correctAnswers = <String>[];
                  for (int i = 0; i < isOptionCorrect.length; i++) {
                    if (isOptionCorrect[i]) {
                      correctAnswers.add(optionValues[i]);
                    }
                  }

                  if (correctAnswers.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select at least one correct answer')),
                    );
                    return;
                  }

                  // Create the question
                  final question = Question(
                    question: questionController.text,
                    type: questionType,
                    options: List<String>.from(optionValues),
                    correct: questionType == 'single' ? correctAnswers.first : correctAnswers,
                  );

                  _addQuestion(question);
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      );
    },
  );

  // Clean up controllers
  questionController.dispose();
  for (var controller in optionControllers) {
    controller.dispose();
  }
}
}