import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _nameController = TextEditingController();

  final _professionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _renderAppBar(),
      body: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection("users")
              .orderBy('name')
              .get(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView(
                    physics: const BouncingScrollPhysics(),
                    children:
                        List.generate(snapshot.data!.docs.length, (index) {
                      return ListTile(
                        title: Text(snapshot.data!.docs[index].get('name')),
                        subtitle:
                            Text(snapshot.data!.docs[index].get('profession')),
                        trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                alertDialog(context, snapshot, index)),
                      );
                    }),
                  )
                : const Center(child: CircularProgressIndicator());
          }),
      floatingActionButton: _renderFloatingButton(context),
    );
  }

  AppBar _renderAppBar() {
    return AppBar(
      title: const Text("Firebase User List"),
      backgroundColor: Colors.black,
    );
  }

  Widget _renderFloatingButton(BuildContext context) {
    return FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return _renderAddDialog();
            },
          );
        },
        child: const Center(
          child: Icon(Icons.add),
        ));
  }

  Widget _renderAddDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)), //this right here
      child: Container(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _professionController,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Profession'),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 320.0,
                child: ElevatedButton(
                  onPressed: () {
                    FirebaseFirestore.instance.collection("users").add({
                      "name": _nameController.text,
                      "profession": _professionController.text
                    }).then((value) {
                      Navigator.pop(context);
                      setState(() {});
                    });
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(primary: Colors.black),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderDeleteDialog(AsyncSnapshot<QuerySnapshot> snapshot, int index) {
    return Dialog(
      shape: const RoundedRectangleBorder(),
      child: Column(
        children: [
          Container(
            height: 250,
            child: const Text("Are you sure you want to delete this user?"),
          ),
          Row(
            children: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection("users")
                        .doc(snapshot.data!.docs[index].id)
                        .delete();
                    setState(() {});
                  },
                  child: const Text('Cancel'))
            ],
          )
        ],
      ),
    );
  }

  void alertDialog(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot, int index) {
    var alert = AlertDialog(
      title: const Text("Delete!!"),
      content: const Text("Are you sure you want to delete this user?"),
      actions: [
        TextButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection("users")
                  .doc(snapshot.data!.docs[index].id)
                  .delete()
                  .then((value) {
                Navigator.pop(context);
                setState(() {});
              });
            },
            child: const Text("Delete")),
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"))
      ],
    );
    showDialog(context: context, builder: (BuildContext context) => alert);
  }
}
