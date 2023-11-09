import 'package:ensanim/user_edit_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User _user;
  String _displayName = '';
  String _email = '';
  String _city = '';
  String _tanggalLahir = '';

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
        _displayName = userDoc.get('displayName');
        _email = userDoc.get('email');
        _city = userDoc.get('city');
        _tanggalLahir = userDoc.get('tanggal_lahir');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Name: $_displayName'),
            Text('Email: $_email'),
            Text('City: $_city'),
            Text('Birthdate: $_tanggalLahir'),
            ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman edit profil
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfilePage()),
                );
              },
              child: Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
