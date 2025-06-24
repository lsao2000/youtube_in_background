import 'package:flutter/material.dart';

class DownloadPage extends StatelessWidget {
  const DownloadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloads'),
      ),
      body: Center(
        child: Text(
          'This feature is coming soon!',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
    );
  }
}
