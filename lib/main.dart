import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';

import 'package:text_recognition_mlkit/screens/Image_to_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text recognition',
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: const ImageToTextScreen(title: 'Image to text'),
    );
  }
}
