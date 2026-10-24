import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izmir_go/app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      // Errors surface immediately with a "Tekrar dene" button instead of silent retries.
      retry: (_, _) => null,
      child: const IzmirGoApp(),
    ),
  );
}
