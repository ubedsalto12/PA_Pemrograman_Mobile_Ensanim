import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LikedAnimalsPage extends StatefulWidget {
  const LikedAnimalsPage({Key? key}) : super(key: key);

  static const String routeName = '/LikedAnimalsPage';

  @override
  _LikedAnimalsPageState createState() => _LikedAnimalsPageState();
}

class _LikedAnimalsPageState extends State<LikedAnimalsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Hewan yang Disukai'),
      ),
      body: _user != null
          ? LikedAnimalsList(firestore: _firestore, userId: _user!.uid)
          : Center(
              child: Text('User not authenticated.'),
            ),
    );
  }
}

class LikedAnimalsList extends StatelessWidget {
  final FirebaseFirestore firestore;
  final String userId;

  const LikedAnimalsList({required this.firestore, required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: firestore
          .collection('likes')
          .where('userId', isEqualTo: userId)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('Tidak ada data hewan yang disukai.'),
          );
        }
        for (var likedDoc in snapshot.data!.docs) {
          var likedData = likedDoc.data() as Map<String, dynamic>;
          var likedDocumentId = likedDoc.id;

          firestore
              .collection('animals')
              .doc(likedData['animalId'])
              .get()
              .then((animalSnapshot) {
            if (!animalSnapshot.exists) {
              // Jika animalId tidak ditemukan di koleksi 'animals', hapus dokumen di koleksi 'likes'
              firestore.collection('likes').doc(likedDocumentId).delete();
            }
          });
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var data =
                snapshot.data!.docs[index].data() as Map<String, dynamic>;
            return ListTile(
              leading: FutureBuilder(
                future:
                    firestore.collection('animals').doc(data['animalId']).get(),
                builder:
                    (context, AsyncSnapshot<DocumentSnapshot> animalSnapshot) {
                  if (animalSnapshot.hasError || !animalSnapshot.hasData) {
                    return Text('Loading');
                  }

                  var animalData =
                      animalSnapshot.data!.data() as Map<String, dynamic>;

                  // Check if 'image_url' exists in animalData
                  if (animalData.containsKey('image_url')) {
                    String imageUrl = animalData['image_url'];

                    // Use Image.network to display the image
                    return Image.network(
                      imageUrl,
                      width: 50, // You can adjust the width as needed
                      height: 50, // You can adjust the height as needed
                      fit: BoxFit.cover,
                    );
                  } else {
                    return Text('No Image');
                  }
                },
              ),
              title: FutureBuilder(
                future:
                    firestore.collection('animals').doc(data['animalId']).get(),
                builder:
                    (context, AsyncSnapshot<DocumentSnapshot> animalSnapshot) {
                  if (animalSnapshot.hasError || !animalSnapshot.hasData) {
                    return Text('Loading');
                  }

                  var animalData =
                      animalSnapshot.data!.data() as Map<String, dynamic>;

                  return Text(animalData['name']);
                },
              ),
            );
          },
        );
      },
    );
  }
}
