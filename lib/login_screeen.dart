import 'package:ensanim/home_page_admin.dart';
import 'package:ensanim/signup_screen.dart';
import 'package:ensanim/home_page_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _email = '';
  String _password = '';

  Future<void> _handleGoogleLogin() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      // Pengguna membatalkan login
      return;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print("User Logged In with Google: ${userCredential.user!.displayName}");

      // Lanjutkan ke halaman sesuai dengan email (seperti yang Anda lakukan sebelumnya)
      String userEmail = userCredential.user!.email!;
      Widget destinationPage;
      if (userEmail == "admin@gmail.com") {
        destinationPage = HomePageAdmin();
      } else {
        destinationPage = HomePageUser();
      }

      // Menampilkan notifikasi saat berhasil login
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Welcome, ${userCredential.user!.displayName}!"),
        ),
      );

      // Pindah ke halaman yang sesuai
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => destinationPage,
        ),
      );
    } catch (e) {
      // Tangani kesalahan saat login dengan Google
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Google Login Error"),
            content: Text(
                "Terjadi kesalahan saat login dengan Google. Silakan coba lagi."),
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
      print("Error During Google Login: $e");
    }
  }

  void _handleLogin() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      print("User Logged In: ${userCredential.user!.email}");

      // Menentukan halaman tujuan berdasarkan email
      String userEmail = userCredential.user!.email!;
      Widget destinationPage;
      if (userEmail == "admin@gmail.com") {
        destinationPage = HomePageAdmin();
      } else {
        destinationPage = HomePageUser();
      }

      // Menampilkan notifikasi saat berhasil login
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Welcome, $userEmail!"),
        ),
      );

      // Pindah ke halaman yang sesuai
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => destinationPage,
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Gagal Login"),
            content: Text("Periksa Email Atau Password Anda"),
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
      print("Error During Logged In: $e");
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
          child: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Email",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please Enter Your Email";
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
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
                  return "Please Enter Your password";
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _password = value;
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _handleLogin();
                }
              },
              child: Text('Login'),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: _handleGoogleLogin,
              child: Text('Login with Google'),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUpScreen(),
                  ),
                );
              },
              child: Text(
                "Don't have an Account? Sign Up",
                style: TextStyle(
                  color: Colors.blue, // Ubah warna teks sesuai kebutuhan
                ),
              ),
            )
          ]),
        ),
      )),
    );
  }
}
