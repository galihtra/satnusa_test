import 'package:flutter/material.dart';

import '../screens/course_create_screen.dart';
import '../screens/home_page.dart';

class SatnusaApp extends StatelessWidget {
  const SatnusaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QHSE Training',
      debugShowCheckedModeBanner: false,
      routes: {
        '/create': (context) => const CourseCreateScreen(),
      },
      home: const HomePage(),
    );
  }
}