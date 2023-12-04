import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class UpdateAnimal extends StatefulWidget {
  static const String routeName = '/update_animal';

  final String documentId;
  final String currentName;
  final String currentOrder;
  final String currentDescription;
  final String currentImageUrl;

  UpdateAnimal({
    required this.documentId,
    required this.currentName,
    required this.currentOrder,
    required this.currentDescription,
    required this.currentImageUrl,
  });

  @override
  _UpdateAnimalState createState() => _UpdateAnimalState();
}

class _UpdateAnimalState extends State<UpdateAnimal> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _orderController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _imagePicker = ImagePicker();
  File? _image;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.currentName;
    _orderController.text = widget.currentOrder;
    _descriptionController.text = widget.currentDescription;
    _imageUrlController.text = widget.currentImageUrl;
  }

  Future<void> _updateAnimal() async {
    if (_image != null) {
      // Upload gambar ke Firebase Storage
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('animal_images/${DateTime.now()}.png');
      await storageReference.putFile(_image!);

      // Dapatkan URL gambar setelah di-upload
      final String imageUrl = await storageReference.getDownloadURL();

      // Perbarui data hewan di Firestore
      await _firestore.collection('animals').doc(widget.documentId).update({
        'name': _nameController.text,
        'order': _orderController.text,
        'description': _descriptionController.text,
        'image_url': imageUrl,
      });
    } else {
      // Jika tidak ada gambar baru yang dipilih, perbarui data tanpa mengubah URL gambar
      await _firestore.collection('animals').doc(widget.documentId).update({
        'name': _nameController.text,
        'order': _orderController.text,
        'description': _descriptionController.text,
      });
    }

    // Kembali ke halaman sebelumnya setelah pembaruan
    Navigator.pop(context);
  }

  Future<void> _pickImage() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image != null ? File(image.path) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Hewan'),
        backgroundColor: Colors.orange,
      ),
      backgroundColor: Colors.yellow[100],
      body: SingleChildScrollView(
        child: Padding(
          
          padding: const EdgeInsets.all(16.0),
          child: Column(
          
        
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nama Hewan'),
              ),
              TextField(
                controller: _orderController,
                decoration: InputDecoration(labelText: 'Ordo Hewan'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Deskripsi Hewan'),
              ),
              SizedBox(height: 20),
              _image != null
                  ? Image.file(
                      _image!,
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      _imageUrlController.text,
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pilih Gambar dari Galeri'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateAnimal,
                child: Text('Perbarui Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
