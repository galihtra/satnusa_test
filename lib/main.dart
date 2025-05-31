import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satnusa_test/providers/quiz_score_provider.dart';

import 'app/satnusa_app.dart';
import 'providers/course_provider.dart';
import 'providers/date_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DateProvider()),
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => QuizScoreProvider()),
      ],
      child: const SatnusaApp(),
    ),
  );
}
