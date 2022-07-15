import 'package:flutter/material.dart';
import 'dart:io'; // at beginning of file

import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({this.icon, required this.radius, required this.imagePickFn, required this.isImagefromGallery, required this.isGroupImage, super.key});

  final void Function(File pickedImage) imagePickFn;
  final bool isImagefromGallery;
  final bool isGroupImage;
  final double radius;
  final Widget? icon;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: widget.isImagefromGallery ? ImageSource.gallery : ImageSource.camera,
      imageQuality: 100,
      maxWidth: 720,
      maxHeight: 1280,
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
        widget.isGroupImage
            ? InkWell(
                onTap: _pickImage,
                child: CircleAvatar(
                  backgroundImage: _pickedImage == null ? null : FileImage(_pickedImage!),
                  radius: widget.radius,
                  child: _pickedImage == null ? widget.icon : null,
                ),
              )
            : CircleAvatar(
                backgroundImage: _pickedImage == null ? null : FileImage(_pickedImage!),
                radius: widget.radius,
                child: widget.icon,
              ),
        if (!widget.isGroupImage)
          TextButton.icon(
            icon: const Icon(Icons.image),
            onPressed: _pickImage,
            label: const Text('Add Image'),
          ),
      ],
    );
  }
}
