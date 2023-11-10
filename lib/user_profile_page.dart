import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ensanim/user_edit_profile_page.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: _firestore.collection('users').doc(_user.uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Text('User data not found!');
            }

            var userData = snapshot.data!;
            String _displayName = userData.get('displayName') ?? '';
            String _email = userData.get('email') ?? '';
            String _city = userData.get('city') ?? '';
            String _tanggalLahir = userData.get('tanggal_lahir') ?? '';

            return Column(
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
            );
          },
        ),
      ),
    );
  }
}
