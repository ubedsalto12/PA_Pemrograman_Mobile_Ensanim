import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({Key? key}) : super(key: key);
  static const String routeName = '/DashboardScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Dashboard'),
        backgroundColor: Colors.orange,
      ),
      backgroundColor: Colors.orange,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.yellow,
              Colors.orange,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to the Dashboard!',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                DashboardData(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('animals').snapshots(),
      builder: (context, animalSnapshot) {
        if (animalSnapshot.hasError) {
          return Text('Error: ${animalSnapshot.error}');
        }

        if (animalSnapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        final animalCount = animalSnapshot.data!.size;

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, userSnapshot) {
            if (userSnapshot.hasError) {
              return Text('Error: ${userSnapshot.error}');
            }

            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            final userCount = userSnapshot.data!.size;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _buildCountBox(
                    'Total Animals',
                    animalCount.toString(),
                    Colors.orange,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: _buildCountBox(
                    'Total Users',
                    userCount.toString(),
                    Colors.yellow,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildCountBox(String title, String count, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 10),
          Text(
            count,
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }
}
