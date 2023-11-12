import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AddAnimal extends StatefulWidget {
  const AddAnimal({Key? key}) : super(key: key);

  static const String routeName = '\AddAnimal';

  @override
  _AddAnimalState createState() => _AddAnimalState();
}

class _AddAnimalState extends State<AddAnimal> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _orderController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  File? _image;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> _uploadData() async {
    if (_nameController.text.isEmpty ||
        _orderController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      // Tampilkan peringatan jika ada teks yang kosong
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Peringatan'),
            content: Text('Harap isi semua kolom teks!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    if (_image != null) {
      // Upload gambar ke Firebase Storage
      final Reference storageReference =
          _storage.ref().child('animal_images/${DateTime.now()}.png');
      await storageReference.putFile(_image!);

      // Dapatkan URL gambar setelah di-upload
      final String imageUrl = await storageReference.getDownloadURL();

      // Upload data hewan ke Firestore dengan nilai default 'Like' = 0
      await _firestore.collection('animals').doc().set({
        'name': _nameController.text,
        'order': _orderController.text,
        'description': _descriptionController.text,
        'image_url': imageUrl,
        'like': 0,
      });

      // Reset controller setelah upload berhasil
      _nameController.clear();
      _orderController.clear();
      _descriptionController.clear();

      // Bersihkan gambar yang diunggah sebelumnya
      setState(() {
        _image = null;
      });

      // Tampilkan pesan upload berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Upload berhasil!'),
        ),
      );
    } else {
      // Tampilkan pesan jika gambar tidak dipilih
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pilih gambar terlebih dahulu!'),
        ),
      );
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image != null ? File(image.path) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              'Add Animal',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 36,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nama Hewan'),
            ),
            TextFormField(
              controller: _orderController,
              decoration: InputDecoration(labelText: 'Ordo Hewan'),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Deskripsi Hewan'),
            ),
            SizedBox(height: 20),
            _image != null
                ? Image.file(
                    _image!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  )
                : Container(),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pilih Gambar'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadData,
              child: Text('Upload Data'),
            ),
          ],
        ),
      ),
    );
  }
}
