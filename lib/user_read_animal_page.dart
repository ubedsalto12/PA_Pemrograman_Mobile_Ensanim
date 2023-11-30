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
  TextEditingController _searchController = TextEditingController();

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
        automaticallyImplyLeading: false,
        title: Text('Daftar Hewan'),
        backgroundColor: Colors.orange,
      ),
      backgroundColor: Colors.orange,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
  
              decoration: InputDecoration(
                
                labelText: 'Search by Name',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                  },
                ),
              ),
              onChanged: (value) {
                setState(() {}); // Trigger rebuild when text changes
              },
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.yellow, Colors.orange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: StreamBuilder(
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

                  // Filter and sort the data based on the search text and alphabetically
                  var filteredData = snapshot.data!.docs.where((document) {
                    var data = document.data() as Map<String, dynamic>;
                    return data['name'].toLowerCase().contains(
                          _searchController.text.toLowerCase(),
                        );
                  }).toList();

                  // Sort the filtered data alphabetically
                  filteredData.sort((a, b) =>
                      (a.data() as Map<String, dynamic>)['name']
                          .compareTo((b.data() as Map<String, dynamic>)['name']));

                  return ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      var data =
                          filteredData[index].data() as Map<String, dynamic>;
                      var documentId = filteredData[index].id;

                      return ListTile(
                        leading: Image.network(
                          data['image_url'],
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          data['name'],
                          style: TextStyle(
                            color: Colors.black, // Text color
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'like: ${data['like']}',
                          style: TextStyle(
                            color: Colors.black, // Text color
                          ),
                        ),
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
                              color: Colors.black, // Icon color
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
