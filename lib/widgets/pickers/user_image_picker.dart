import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File selectedImage) imagePickerFn;
  const UserImagePicker({Key? key, required this.imagePickerFn})
      : super(key: key);

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _selectedImage;

  Future<void> selectPicture() async {
    final picker = ImagePicker();
    final selectedImage =
        await picker.pickImage(source: ImageSource.gallery, maxWidth: 200);

    setState(
      () {
        _selectedImage = File(selectedImage!.path);
      },
    );

    widget.imagePickerFn(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage:
              _selectedImage == null ? null : FileImage(_selectedImage!),
          radius: 40,
          // child: _selectedImage == null
          //     ? const Center(
          //         child: Text(
          //         "?",
          //         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          //         textAlign: TextAlign.center,
          //       ))
          //     : null,
        ),
        TextButton.icon(
          onPressed: selectPicture,
          icon: const Icon(Icons.camera),
          label: const Text("Select Profile Photo"),
        )
      ],
    );
  }
}
