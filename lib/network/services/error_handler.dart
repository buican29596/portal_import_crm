import 'package:flutter/material.dart';

class ErrorHandler {
  static void showError(BuildContext context, String message) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ErrorScreen(errorMessage: message),
      ),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final String errorMessage;

  const ErrorScreen({Key? key, required this.errorMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                errorMessage,
                style: TextStyle(fontSize: 18, color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Quay lại màn hình trước đó
                },
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}