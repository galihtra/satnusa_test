import 'package:flutter/material.dart';

import '../screens/homepage.dart';

class SatnusaApp extends StatelessWidget {
  const SatnusaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'QHSE Training',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}