import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'home_page_user.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({super.key});
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      next: Text("Selanjutnya"),
      done: Text("Selesai"),
      onDone: () {
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return HomePageUser();
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
    );
  }
}
