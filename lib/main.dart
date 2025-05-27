import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/satnusa_app.dart';
import 'providers/date_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DateProvider()),
      ],
      child: const SatnusaApp(),
    ),
  );
}


