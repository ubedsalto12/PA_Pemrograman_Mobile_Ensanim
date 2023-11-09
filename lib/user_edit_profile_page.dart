import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User _user;
  TextEditingController _displayNameController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _tanggalLahirController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await _firestore.collection('users').doc(_user.uid).get();
    if (userDoc.exists) {
      setState(() {
        _displayNameController.text = userDoc.get('displayName');
        _cityController.text = userDoc.get('city');
        _tanggalLahirController.text = userDoc.get('tanggal_lahir');
      });
    }
  }

  Future<void> _updateProfile() async {
    await _firestore.collection('users').doc(_user.uid).update({
      'displayName': _displayNameController.text,
      'city': _cityController.text,
      'tanggal_lahir': _tanggalLahirController.text,
    });
    // Kembali ke halaman profil
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _displayNameController,
              decoration: InputDecoration(labelText: 'Display Name'),
            ),
            TextFormField(
              controller: _cityController,
              decoration: InputDecoration(labelText: 'City'),
            ),
            TextFormField(
              controller: _tanggalLahirController,
              decoration: InputDecoration(labelText: 'Tanggal Lahir (YYYY-MM-DD)'),
            ),
            ElevatedButton(
              onPressed: _updateProfile,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
