import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileAvatar extends StatefulWidget {
  final String? imageUrl;
  const ProfileAvatar({super.key, this.imageUrl});

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  File? _imageFile;
  bool _uploading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
      await _uploadToFirebase(File(picked.path));
    }
  }

  Future<void> _uploadToFirebase(File image) async {
    setState(() => _uploading = true);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final ref = FirebaseStorage.instance.ref().child('profile_images').child('${user.uid}.jpg');
    await ref.putFile(image);
    final downloadUrl = await ref.getDownloadURL();

    // Save to Firestore
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'imageUrl': downloadUrl,
    });

    setState(() => _uploading = false);
  }

  @override
  Widget build(BuildContext context) {
    final image = _imageFile != null
        ? FileImage(_imageFile!)
        : (widget.imageUrl != null ? NetworkImage(widget.imageUrl!) : null);

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: image as ImageProvider<Object>?,
          child: image == null
              ? const Icon(Icons.person, size: 50)
              : null,
        ),
        Positioned(
          child: IconButton(
            icon: const Icon(Icons.edit, color: Colors.green),
            onPressed: _uploading ? null : _pickImage,
          ),
        )
      ],
    );
  }
}
