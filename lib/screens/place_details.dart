import 'dart:io';
import 'package:accelerite_plugin/modal/newplace.dart';
import 'package:accelerite_plugin/provider/user_place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class placeDetailsScreen extends ConsumerStatefulWidget {
  const placeDetailsScreen({Key? key, required this.place}) : super(key: key);
  final Place place;

  @override
  ConsumerState<placeDetailsScreen> createState() {
    return _placeDetails();
  }
}

class _placeDetails extends ConsumerState<placeDetailsScreen> {
  final TextEditingController _titleController = TextEditingController();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.place.title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('placess')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _showImageOptions();
                },
                child: Stack(
                  children: [
                    Image.file(
                      widget.place.image,
                      height: 400,
                      width: 800,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                onChanged: (value) {
                  // You can add any logic here when the text changes
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(230, 12, 11, 11),
                    Color.fromARGB(234, 0, 0, 0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                  _updatePlace();
                },
                child: Text('Update'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageOptions() async {
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
                  ),
                );
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
                  ),
                );
              },
            ),
          ],
        );
      },
    );

    if (pickImage != null) {
      setState(() {
        _selectedImage = File(pickImage.path);
      });
    }
  }

  Future<void> _updatePlace() async {
    final updatedTitle = _titleController.text;
    if (updatedTitle.isEmpty || _selectedImage == null) {
      return;
    }

    ref
        .read(userplaceprovider.notifier)
        .updatePlace(widget.place.id, updatedTitle, _selectedImage!);
    Navigator.pop(context);
  }
}
