import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';

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
      home: const MyHomePage(title: 'Image to text'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ITextRecognizer _recognizer;
  File? imageFile;
  String? recognizedText;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _recognizer = MLKitTextRecognizer();
  }

  @override
  void dispose() {
    super.dispose();
    if (_recognizer is MLKitTextRecognizer) {
      (_recognizer as MLKitTextRecognizer).dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Material(
        child: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: imageFile != null
                    ? Image.file(imageFile!)
                    : const Center(
                        child: Text('- Take a photo -'),
                      )),
            const SizedBox(height: 16.0),
            Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.black54),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0))),
                  child: Text(recognizedText ?? 'No text'),
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: takePicture,
        tooltip: 'Take a photo',
        child: const Icon(Icons.camera),
      ),
    );
  }

  takePicture() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image == null) {
      return;
    }

    resetPreviousRequest();

    processImage(image.path);
  }

  void processImage(String imgPath) async {
    _toggleIsLoading();
    recognizedText = await _recognizer.processImage(imgPath);
    imageFile = File(imgPath);
    print('Recognized text: $recognizedText');
    _toggleIsLoading();
  }

  resetPreviousRequest() {
    setState(() {
      imageFile = null;
      recognizedText = null;
    });
  }

  _toggleIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }
}

abstract class ITextRecognizer {
  Future<String> processImage(String imgPath);
}

class MLKitTextRecognizer extends ITextRecognizer {
  late TextRecognizer recognizer;

  MLKitTextRecognizer() {
    recognizer = TextRecognizer();
  }

  void dispose() {
    recognizer.close();
  }

  @override
  Future<String> processImage(String imgPath) async {
    final image = InputImage.fromFile(File(imgPath));
    final recognized = await recognizer.processImage(image);
    return recognized.text;
  }
}
