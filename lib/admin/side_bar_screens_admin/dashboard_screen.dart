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
      ),
      body: SingleChildScrollView(
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
                ),
              ),
              SizedBox(height: 20),
              DashboardData(),
            ],
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
                  child: _buildCountBox('Total Animals', animalCount.toString(), Colors.purple),
                ),
                Expanded(
                  child: _buildCountBox('Total Users', userCount.toString(), Colors.purple),
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
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
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
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 10),
          Text(
            count,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          
        ],
      ),
    );
  }
}
