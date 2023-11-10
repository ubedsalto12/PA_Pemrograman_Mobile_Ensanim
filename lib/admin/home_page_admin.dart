import 'package:ensanim/admin/side_bar_screens/CRUD_screen.dart';
import 'package:ensanim/admin/side_bar_screens/dashboard_screen.dart';
import 'package:ensanim/admin/side_bar_screens/logout_screens.dart';
import 'package:ensanim/login_screeen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter/material.dart';

class HomePageAdmin extends StatefulWidget {
  const HomePageAdmin({super.key});

  @override
  State<HomePageAdmin> createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Widget _selectedItem = DashBoardScreen();

  void _handleLogout() async {
    bool confirmLogout = false;

    // Menampilkan dialog konfirmasi
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Konfirmasi Logout'),
          content: Text('Apakah Anda yakin ingin keluar?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                confirmLogout = false;
                Navigator.of(context).pop();
              },
              child: Text('Tidak'),
            ),
            TextButton(
              onPressed: () {
                confirmLogout = true;
                Navigator.of(context).pop();
              },
              child: Text('Ya'),
            ),
          ],
        );
      },
    );

    // Jika pengguna yakin untuk logout, lakukan logout dan kembali ke halaman login
    if (confirmLogout) {
      _auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  screenSelector(item) {
    switch (item.route) {
      case DashBoardScreen.routeName:
        setState(() {
          _selectedItem = DashBoardScreen();
        });
        break;
      case CrudScreens.routeName:
        setState(() {
          _selectedItem = CrudScreens();
        });
        break;
      case LogoutScreen.routeName:
        setState(() {
          _handleLogout();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Admin'),
      ),
      sideBar: SideBar(
        items: const [
          AdminMenuItem(
            title: 'Dashboard',
            route: DashBoardScreen.routeName,
            icon: Icons.dashboard,
          ),
          AdminMenuItem(
            title: 'CRUD',
            route: CrudScreens.routeName,
            icon: Icons.dashboard,
          ),
          AdminMenuItem(
            title: 'Logout',
            route: LogoutScreen.routeName,
            icon: Icons.logout,
          ),
        ],
        selectedRoute: '',
        onSelected: (item) {
          screenSelector(item);
        },
        header: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child: const Center(
            child: Text(
              'Menu Admin',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        footer: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child: const Center(
            child: Text(
              'footer',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: _selectedItem,
    );
  }
}
