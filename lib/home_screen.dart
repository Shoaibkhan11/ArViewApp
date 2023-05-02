import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nextgen/item_ui_design_widget.dart';

import 'items_upload_screen.dart';

import 'items.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(children: [
          //const Text("                         "),
          Text(
            "ne",
            style: TextStyle(color: Colors.blue[100], fontSize: 22),
          ),
          Text(
            "X",
            style: TextStyle(
                color: Colors.blue[400],
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "t ",
            style: TextStyle(color: Colors.blue[100], fontSize: 22),
          ),
          Text(
            "G",
            style: TextStyle(
                color: Colors.blue[400],
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "en",
            style: TextStyle(color: Colors.blue[100], fontSize: 22),
          )
        ]),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => ItemsUploadScreen()));
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ))
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("items")
            .orderBy("publishedDate", descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot dataSnapshot) {
          if (dataSnapshot.hasData) {
            return ListView.builder(
              itemCount: dataSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Items eachItemInfo = Items.fromJson(
                    dataSnapshot.data!.docs[index].data()
                        as Map<String, dynamic>);

                return ItemUIDesignWidget(
                  itemsInfo: eachItemInfo,
                  context: context,
                );
              },
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                const Center(
                  child: const Text(
                    "Data is not available.",
                    style: TextStyle(fontSize: 30, color: Colors.grey),
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
