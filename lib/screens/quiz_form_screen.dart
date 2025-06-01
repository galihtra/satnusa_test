import 'package:flutter/material.dart';
import '../models/quiz.dart';
import '../models/question.dart';

class QuizFormScreen extends StatefulWidget {
  const QuizFormScreen({super.key});

  @override
  State<QuizFormScreen> createState() => _QuizFormScreenState();
}

class _QuizFormScreenState extends State<QuizFormScreen> {
  final _quizFormKey = GlobalKey<FormState>();
  final _quizTitleController = TextEditingController();
  final List<Question> _questions = [];

  // Question Form Controllers
  final _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers =
      List.generate(4, (_) => TextEditingController());
  int _correctAnswerIndex = 0;

  void _addQuestion() {
    if (_questionController.text.trim().isEmpty ||
        _optionControllers.any((c) => c.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all question fields')),
      );
      return;
    }

    final question = Question(
      question: _questionController.text.trim(),
      type: 'single',
      options: _optionControllers.map((c) => c.text.trim()).toList(),
      correct: _optionControllers[_correctAnswerIndex].text.trim(),
    );

    setState(() {
      _questions.add(question);
      _questionController.clear();
      for (final c in _optionControllers) {
        c.clear();
      }
      _correctAnswerIndex = 0;
    });
  }

  void _submitQuiz() {
    if (_quizFormKey.currentState!.validate() && _questions.isNotEmpty) {
      final quiz = Quiz(
        title: _quizTitleController.text.trim(),
        questions: _questions,
        // score will default to 0
      );
      Navigator.pop(context, quiz);
    } else if (_questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one question')),
      );
    }
  }

  @override
  void dispose() {
    _quizTitleController.dispose();
    _questionController.dispose();
    for (final c in _optionControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Quiz')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _quizFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quiz Title
              TextFormField(
                controller: _quizTitleController,
                decoration: const InputDecoration(labelText: 'Quiz Title'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter quiz title' : null,
              ),
              const SizedBox(height: 24),

              const Text('Add Question',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              TextFormField(
                controller: _questionController,
                decoration: const InputDecoration(labelText: 'Question'),
              ),
              const SizedBox(height: 12),

              ListView.builder(
                itemCount: _optionControllers.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ListTile(
                    title: TextFormField(
                      controller: _optionControllers[index],
                      decoration:
                          InputDecoration(labelText: 'Option ${index + 1}'),
                    ),
                    leading: Radio<int>(
                      value: index,
                      groupValue: _correctAnswerIndex,
                      onChanged: (val) {
                        setState(() {
                          _correctAnswerIndex = val!;
                        });
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _addQuestion,
                child: const Text('Add Question to Quiz'),
              ),

              const Divider(height: 32),
              const Text('Questions Preview',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

              ..._questions.map((q) => ListTile(
                    title: Text(q.question),
                    subtitle: Text('Correct: ${q.correct}'),
                  )),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitQuiz,
                child: const Text('Submit Quiz'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
