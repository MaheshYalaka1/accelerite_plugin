import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({Key? key, required this.onPicked}) : super(key: key);

  final void Function(File image) onPicked;

  @override
  State<StatefulWidget> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;

  void _takePicture() async {
    final imagePicker = ImagePicker();

    final pickImage = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(
                    context,
                    await imagePicker.pickImage(
                      source: ImageSource.gallery,
                      maxWidth: 600,
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Take a Picture'),
              onTap: () async {
                Navigator.pop(
                    context,
                    await imagePicker.pickImage(
                      source: ImageSource.camera,
                      maxWidth: 600,
                    ));
              },
            ),
          ],
        );
      },
    );

    if (pickImage == null) {
      return;
    }

    setState(() {
      _selectedImage = File(pickImage.path);
    });

    widget.onPicked(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      icon: const Icon(Icons.camera),
      label: const Text('Take Picture'),
      onPressed: _takePicture,
    );

    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: _takePicture,
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      child: content,
    );
  }
}
