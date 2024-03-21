import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';
import 'package:text_recognition_mlkit/utils/text_recognizer_helper.dart';


class ImageToTextScreen extends StatefulWidget {
  const ImageToTextScreen({super.key, required this.title});

  final String title;

  @override
  State<ImageToTextScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ImageToTextScreen> {
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
        actions: [
          IconButton(
              onPressed: resetPreviousRequest,
              icon: const Icon(Icons.cleaning_services))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
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