import 'package:ensanim/admin/side_bar_screens_admin/animal_details.dart';
import 'package:ensanim/admin/side_bar_screens_admin/update_animal.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReadAnimal extends StatefulWidget {
  const ReadAnimal({Key? key}) : super(key: key);

  static const String routeName = '/ReadAnimal';

  @override
  _ReadAnimalState createState() => _ReadAnimalState();
}

class _ReadAnimalState extends State<ReadAnimal> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _searchController = TextEditingController();

  Future<void> _deleteAnimal(String documentId) async {
    await _firestore.collection('animals').doc(documentId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Daftar Hewan'),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.yellow, const Color.fromARGB(255, 255, 132, 0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search by Name',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                      },
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
            ),
            Expanded(
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

                  var filteredData = snapshot.data!.docs.where((document) {
                    var data = document.data() as Map<String, dynamic>;
                    return data['name']
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase());
                  }).toList();

                  filteredData.sort((a, b) => (a.data()
                          as Map<String, dynamic>)['name']
                      .compareTo((b.data() as Map<String, dynamic>)['name']));

                  return ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      var data =
                          filteredData[index].data() as Map<String, dynamic>;
                      var documentId = filteredData[index].id;

                      return Card(
                        color: Colors.white,
                        elevation: 3,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
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
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UpdateAnimal(
                                        documentId: documentId,
                                        currentName: data['name'],
                                        currentOrder: data['order'],
                                        currentDescription: data['description'],
                                        currentImageUrl: data['image_url'],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Konfirmasi Penghapusan'),
                                        content: Text(
                                          'Apakah Anda yakin ingin menghapus ${data['name']}?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Batal'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              await _deleteAnimal(documentId);
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Hapus'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
