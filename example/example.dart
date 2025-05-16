import 'package:flutter/material.dart';
import 'package:kib_debug_print/kib_debug_print.dart' show kprint;
import 'package:kib_flutter_utils/kib_flutter_utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ExceptionExampleScreen());
  }
}

class ExceptionExampleScreen extends StatefulWidget {
  const ExceptionExampleScreen({super.key});

  @override
  State<ExceptionExampleScreen> createState() => _ExceptionExampleScreenState();
}

class _ExceptionExampleScreenState extends State<ExceptionExampleScreen> {
  String _errorMessage = '';

  Future<void> _fetchUserData() async {
    try {
      // Simulate API call failure
      await Future.delayed(const Duration(seconds: 1));
      throw NetworkException(
        'Connection failed',
        'https://api.example.com/users',
        statusCode: 500,
      );
    } catch (e, stackTrace) {
      if (e is NetworkException) {
        setState(() {
          _errorMessage =
              'Network error: ${e.message} (Status: ${e.statusCode})';
        });
      } else {
        // Wrap unknown errors with ExceptionX for better tracking
        final exception = ExceptionX(
          message: 'Failed to fetch user data',
          errorType: e.runtimeType,
          error: e,
          stackTrace: stackTrace,
        );

        setState(() {
          _errorMessage = exception.message;
        });

        // Log the exception for debugging
        kprint.err('Error type: ${exception.errorType}');
        kprint.err('Stack trace: ${exception.stackTrace}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exception Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _fetchUserData,
              child: const Text('Fetch User Data'),
            ),
            const SizedBox(height: 20),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
