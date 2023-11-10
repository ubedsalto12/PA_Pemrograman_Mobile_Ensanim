import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _displayNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _tanggalLahirController = TextEditingController();
  String _displayName = '';
  String _email = '';
  String _password = '';
  String _city = '';
  String _tanggalLahir = '';

  void _handleSignUp() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _password);

      // Menambahkan displayName, city, dan tanggal_lahir ke informasi pengguna
      await userCredential.user!.updateProfile(displayName: _displayName);

      // Menyimpan data pengguna ke Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'email': _email,
        'displayName': _displayName,
        'city': _city,
        'tanggal_lahir': _tanggalLahir,
      });

      print("User Registered: ${userCredential.user!.email}");

      // Menampilkan notifikasi saat berhasil membuat akun
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Pendaftaran Berhasil"),
            content: Text("Akun Anda telah berhasil dibuat."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                  // Kembali ke halaman login
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Menampilkan pesan kesalahan saat gagal mendaftar
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Gagal Mendaftar"),
            content: Text("Terjadi kesalahan saat membuat akun. Silakan coba lagi."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      print("Error During Registration: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _displayNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Display Name",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your display name";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _displayName = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "City",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your city";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _city = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _tanggalLahirController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Tanggal Lahir (YYYY-MM-DD)",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your birthdate";
                    }
                    // Validasi format tanggal lahir (contoh: YYYY-MM-DD)
                    RegExp datePattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                    if (!datePattern.hasMatch(value)) {
                      return "Invalid date format (YYYY-MM-DD)";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _tanggalLahir = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your password";
                    }
                    if (value.length < 6) {
                      return "Use 6 characters or more for your password";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _handleSignUp();
                    }
                  },
                  child: Text('Sign Up'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
