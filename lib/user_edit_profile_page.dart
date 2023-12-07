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
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _userDataStream;

  TextEditingController _displayNameController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _tanggalLahirController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
    _userDataStream = _firestore.collection('users').doc(_user.uid).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Colors.orange,
      ),
      backgroundColor: Colors.yellow[200],
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: _userDataStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Tampilkan loading indicator jika data masih dimuat
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Text(
                  'User data not found!'); // Tampilkan pesan jika data pengguna tidak ditemukan
            }

            var userData = snapshot.data!;

            _displayNameController.text = userData.get('displayName');
            _cityController.text = userData.get('city');
            _tanggalLahirController.text = userData.get('tanggal_lahir');

            return Column(
              children: <Widget>[
                TextField(
                  controller: _displayNameController,
                  decoration: InputDecoration(labelText: 'Display Name'),
                ),
                TextField(
                  controller: _cityController,
                  decoration: InputDecoration(labelText: 'City'),
                ),
                TextField(
                  controller: _tanggalLahirController,
                  decoration: InputDecoration(labelText: 'Birthdate'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Panggil fungsi untuk update data pengguna di Firestore
                    await _updateUserData();

                    // Kembali ke halaman profil setelah perubahan disimpan
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _updateUserData() async {
    // Update data pengguna di Firestore
    if (_displayNameController.text.isEmpty ||
        _cityController.text.isEmpty ||
        _tanggalLahirController.text.isEmpty) {
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
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Updated'),
            content: Text('Data Berhasil Di Update'),
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
      await _firestore.collection('users').doc(_user.uid).update({
        'displayName': _displayNameController.text,
        'city': _cityController.text,
        'tanggal_lahir': _tanggalLahirController.text,
      });
    }
  }
}
