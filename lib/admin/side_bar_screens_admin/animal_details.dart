import 'package:flutter/material.dart';

class AnimalDetail extends StatelessWidget {
  final String name;
  final String order;
  final String description;
  final String imageUrl;
  final String like;

  AnimalDetail({
    required this.name,
    required this.order,
    required this.description,
    required this.like,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    var lebar = MediaQuery.of(context).size.width;
    var tinggi = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Detail Hewan'),

        backgroundColor: Colors.orange, // Set the app bar background color
      ),

      backgroundColor: Colors.yellow[100], // Set the scaffold background color
      body: Center(
        widthFactor: lebar,
        heightFactor: tinggi,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              imageUrl,
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              'Nama: $name',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Ordo: $order',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Jumlah $like',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Deskripsi: $description',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
