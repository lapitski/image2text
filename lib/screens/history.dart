import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ///TODO: implement history screen
    return Scaffold(
        appBar: AppBar(
          title: const Text('Recognition history'),
        ),
        body: const SingleChildScrollView(
          child: Center(
            child: Text('Todo'),
          ),
        ));
  }
}
