import 'package:ensanim/login_screeen.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double lebar = MediaQuery.of(context).size.height;

    return IntroductionScreen(
      next: Text("Selanjutnya"),
      done: Text("Selesai"),
      onDone: () {
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return LoginScreen();
            },
          ),
        );
      },
      pages: [
        PageViewModel(
          title: "Halo, Selamat datang di Ensiklopedia Hewan",
          body: "Aplikasi untuk meningkatkan pengetahuanmu tentang Hewan!",
          image: Image.asset("assets/images/intro1.jpg"),
        ),
        PageViewModel(
          title: "Carilah hewan yang ingin anda pelajari",
          body:
              "Mulai Dari Mamalia, Reptil, Amfhibi, Dan masi banyak Hewan Lainnya!",
          image: Image.asset("assets/images/intro1.jpg"),
        ),
        PageViewModel(
          title: "Nikmati kemudahan Aplikasi Kami!",
          body:
              "Dengan layanan pelanggan yang sangat responsif, tim kami selalu siap membantu Anda dalam setiap langkah perjalanan Anda",
          image: Image.asset("assets/images/intro1.jpg"),
        ),
      ],
      // Tambahkan parameter `globalBackgroundColor` dengan nilai 600 atao yang seusai
      globalBackgroundColor: lebar > 600
          ? Colors.white
          : Colors
              .yellow, //warna akan berubah kalo kita ke atasin halaman/ menarik halaman
    );
  }
}
