import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/app_dependencies.dart';
import 'features/chat/presentation/cubit/chat_cubit.dart';
import 'features/chat/presentation/screens/chat_screen.dart';

void main() {
  const apiKey = String.fromEnvironment('GEMINI_API_KEY');
  final dependencies = apiKey.trim().isEmpty
      ? null
      : AppDependencies.create(apiKey: apiKey);

  runApp(MyApp(dependencies: dependencies));
}

class MyApp extends StatefulWidget {
  const MyApp({this.dependencies, super.key});

  final AppDependencies? dependencies;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    widget.dependencies?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gemini Chat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5265D8)),
        useMaterial3: true,
      ),
      home: widget.dependencies == null
          ? const _ConfigurationRequiredScreen()
          : BlocProvider(
              create: (_) => ChatCubit(widget.dependencies!.chatService),
              child: const ChatScreen(),
            ),
    );
  }
}

class _ConfigurationRequiredScreen extends StatelessWidget {
  const _ConfigurationRequiredScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.key_off, size: 48),
                SizedBox(height: 16),
                Text(
                  'Gemini is not configured',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Provide GEMINI_API_KEY using --dart-define to run locally. '
                  'For a production app, keep the key on a backend and call '
                  'your backend from the app.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
