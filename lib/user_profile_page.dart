
import 'package:ensanim/login_screeen.dart';
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

  Future<void> _signOut() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout Confirmation'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the alert
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _auth.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) =>
                      false, // This prevents the user from going back to the UserProfilePage
                );
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Navigate to the edit profile page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfilePage()),
              );
            },
          ),
        ],
      ),
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

            return ListView(
              padding: EdgeInsets.all(16),
              children: <Widget>[
                ListTile(
                  title: Text('Name'),
                  subtitle: Text(_displayName),
                  leading: Icon(Icons.person),
                ),
                ListTile(
                  title: Text('Email'),
                  subtitle: Text(_email),
                  leading: Icon(Icons.email),
                ),
                ListTile(
                  title: Text('City'),
                  subtitle: Text(_city),
                  leading: Icon(Icons.location_city),
                ),
                ListTile(
                  title: Text('Birthdate'),
                  subtitle: Text(_tanggalLahir),
                  leading: Icon(Icons.calendar_today),
                ),
                IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: _signOut,
                  tooltip: 'Logout', // Tooltip for the IconButton,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
