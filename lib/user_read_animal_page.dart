import 'package:ensanim/admin/side_bar_screens_admin/animal_details.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReadAnimalUser extends StatefulWidget {
  const ReadAnimalUser({Key? key}) : super(key: key);

  static const String routeName = '/ReadAnimalUser';

  @override
  _ReadAnimalUserState createState() => _ReadAnimalUserState();
}

class _ReadAnimalUserState extends State<ReadAnimalUser> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
  }

  Future<void> _likeAnimal(String documentId) async {
    if (_user != null) {
      String userId = _user!.uid;

      QuerySnapshot<Map<String, dynamic>> likeSnapshot = await _firestore
          .collection('likes')
          .where('userId', isEqualTo: userId)
          .where('animalId', isEqualTo: documentId)
          .get();

      if (likeSnapshot.docs.isEmpty) {
        DocumentSnapshot<Map<String, dynamic>> animalSnapshot =
            await _firestore.collection('animals').doc(documentId).get();

        if (animalSnapshot.exists) {
          int currentLikes = animalSnapshot.get('like') ?? 0;
          int newLikes = currentLikes + 1;

          await _firestore
              .collection('animals')
              .doc(documentId)
              .update({'like': newLikes});

          await _firestore.collection('likes').add({
            'userId': userId,
            'animalId': documentId,
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Hewan'),
      ),
      body: StreamBuilder(
        stream: _firestore.collection('animals').snapshots(),
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
              child: Text('Tidak ada data hewan.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var data =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              var documentId = snapshot.data!.docs[index].id;

              return ListTile(
                leading: Image.network(
                  data['image_url'],
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(data['name']),
                subtitle: Text('like: ${data['like']}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AnimalDetail(
                        name: data['name'],
                        order: data['order'],
                        imageUrl: data['image_url'],
                        description: data['description'],
                        like: 'like: ${data['like']}',
                      ),
                    ),
                  );
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.thumb_up),
                      onPressed: () {
                        _likeAnimal(documentId);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}