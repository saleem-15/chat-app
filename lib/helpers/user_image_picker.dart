import 'package:flutter/material.dart';
import 'dart:io'; // at beginning of file

import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({required this.imagePickFn, super.key});

  final void Function(File pickedImage) imagePickFn;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 200 ,
    );

    setState(() {
      _pickedImage = File(pickedImage!.path);
    });
    widget.imagePickFn(_pickedImage!);
  }

/*
final picker = ImagePicker();
final pickedImage = await picker.getImage(...);
final pickedImageFile = File(pickedImage.path); // requires import 
*/
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage:
              _pickedImage == null ? null : FileImage(_pickedImage!),
          radius: 45,
        ),
        TextButton.icon(
          icon: const Icon(Icons.image),
          onPressed: _pickImage,
          label: const Text('Add Image'),
        ),
      ],
    );
  }
}
