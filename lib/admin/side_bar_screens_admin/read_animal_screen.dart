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

  // Fungsi untuk menghapus data hewan dari Firestore
  Future<void> _deleteAnimal(String documentId) async {
    await _firestore.collection('animals').doc(documentId).delete();
  }

  @override
  Widget build(BuildContext contxext) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Daftar Hewan'),
      ),
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
                      title: Text(data['name']),
                      subtitle: Text('like: ${data['like']}'),
                      onTap: () {
                        // Navigasi ke halaman detail
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
                              // Navigasi ke halaman pembaruan data
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
                              // Menampilkan dialog konfirmasi penghapusan
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Konfirmasi Penghapusan'),
                                    content: Text(
                                        'Apakah Anda yakin ingin menghapus ${data['name']}?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Batal'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          // Hapus data dari Firestore dan tutup dialog
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
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
