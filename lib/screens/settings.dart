import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
   ///TODO: implement settings screen
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: const SingleChildScrollView(
          child: Center(
            child: Text('Todo'),
          ),
        ));
  }
}