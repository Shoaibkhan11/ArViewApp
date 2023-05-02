import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'home_screen.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart' as fStorage;

import 'api_consumer.dart';

class ItemsUploadScreen extends StatefulWidget {
  @override
  State<ItemsUploadScreen> createState() => _ItemsUploadScreenState();
}

class _ItemsUploadScreenState extends State<ItemsUploadScreen> {
  Uint8List? imageUint8List;

  TextEditingController sellerNameTextEditingController =
      TextEditingController();
  TextEditingController sellerPhoneTextEditingController =
      TextEditingController();
  TextEditingController itemNameTextEditingController = TextEditingController();
  TextEditingController itemDescriptionTextEditingController =
      TextEditingController();
  TextEditingController itemPriceTextEditingController =
      TextEditingController();

  bool isUploading = false;

  String downloadUrlOfUploadedImage = "";

  validateUploadFormAndUploadItemInfo() async {
    if (imageUint8List != null) {
      if (sellerNameTextEditingController.text.isNotEmpty &&
          sellerPhoneTextEditingController.text.isNotEmpty &&
          itemNameTextEditingController.text.isNotEmpty &&
          itemDescriptionTextEditingController.text.isNotEmpty &&
          itemPriceTextEditingController.text.isNotEmpty) {
        if (isNumeric(itemPriceTextEditingController.text) == false) {
          Fluttertoast.showToast(msg: "The item price must be a number");
        }
        else {
          setState(() {
            isUploading = true;
          });

          //upload image to cloud storage

          String imageUniqueName =
          DateTime
              .now()
              .millisecondsSinceEpoch
              .toString();

          fStorage.Reference firebaseStorageRef = fStorage
              .FirebaseStorage.instance
              .ref()
              .child("images")
              .child(imageUniqueName);

          fStorage.UploadTask uploadTaskImageFile =
          firebaseStorageRef.putData(imageUint8List!);

          fStorage.TaskSnapshot taskSnapshot =
          await uploadTaskImageFile.whenComplete(() {});
          await taskSnapshot.ref.getDownloadURL().then((imageDownloadUrl) {
            downloadUrlOfUploadedImage = imageDownloadUrl;
          });

          // Fluttertoast.showToast(msg: "your new Item uploaded successfully.");

          // setState(() {
          //   isUploading = false;
          //   imageUint8List = null;
          // });

          // Navigator.push(
          //     context, MaterialPageRoute(builder: (c) => const HomeScreen()));

          // save item info to firestore database

          saveItemInfoToFirestore();
        }
      }


      else {
        Fluttertoast.showToast(
            msg: "Please complete upload form.Every field is mandatory");
      }
    } else {
      Fluttertoast.showToast(msg: "Please select image file.");
    }
  }

  saveItemInfoToFirestore() {
    String itemUniqueId = DateTime.now().millisecondsSinceEpoch.toString();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    _firestore.collection('items').doc(itemUniqueId).set({
      "itemID": itemUniqueId,
      "itemName": itemNameTextEditingController.text,
      "itemDescription": itemDescriptionTextEditingController.text,
      "itemImage": downloadUrlOfUploadedImage,
      "sellerName": sellerNameTextEditingController.text,
      "sellerPhone": sellerPhoneTextEditingController.text,
      "itemPrice": itemPriceTextEditingController.text,
      "publishedDate": DateTime.now(),
      "status": "available",
    });

    // FirebaseFirestore.instance
    //     .collection("items")
    //     .doc(itemUniqueId)
    //     .set(
    //     {
    //       "itemID": itemUniqueId,
    //       "itemName": itemNameTextEditingController.text,
    //       "itemDescription": itemDescriptionTextEditingController.text,
    //       "itemImage": downloadUrlOfUploadedImage,
    //       "sellerName": sellerNameTextEditingController.text,
    //       "sellerPhone": sellerPhoneTextEditingController.text,
    //       "itemPrice": itemPriceTextEditingController.text,
    //       "publishedDate": DateTime.now(),
    //       "status": "available",
    //     });

    Fluttertoast.showToast(msg: "your new Item uploaded successfully.");

    setState(() {
      isUploading = false;
      imageUint8List = null;
    });

    Navigator.push(
        context, MaterialPageRoute(builder: (c) => const HomeScreen()));
  }

  // Upload form screen

  Widget uploadFormScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Upload New Item",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: IconButton(
              onPressed: () {
                //validateupload from fields
                if (isUploading != true) {
                  validateUploadFormAndUploadItemInfo();
                }
              },
              icon: const Icon(
                Icons.cloud_upload,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          isUploading == true
              ? const LinearProgressIndicator(
                  color: Colors.purpleAccent,
                )
              : Container(),

          //image
          SizedBox(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
                child: imageUint8List != null
                    ? Image.memory(imageUint8List!)
                    : const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 70,
                      )),
          ),

          const Divider(
            color: Colors.white70,
            thickness: 2,
          ),

          //seller name
          ListTile(
            leading: const Icon(
              Icons.person_pin_rounded,
              color: Colors.white,
            ),
            title: SizedBox(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.grey),
                controller: sellerNameTextEditingController,
                decoration: const InputDecoration(
                  hintText: "seller name",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.white70,
            thickness: 1,
          ),

          //seller phone
          ListTile(
            leading: const Icon(
              Icons.phone_iphone_rounded,
              color: Colors.white,
            ),
            title: SizedBox(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.grey),
                controller: sellerPhoneTextEditingController,
                decoration: const InputDecoration(
                  hintText: "seller phone",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.white70,
            thickness: 1,
          ),

          //item name
          ListTile(
            leading: const Icon(
              Icons.title,
              color: Colors.white,
            ),
            title: SizedBox(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.grey),
                controller: itemNameTextEditingController,
                decoration: const InputDecoration(
                  hintText: "item name",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.white70,
            thickness: 1,
          ),

          //item description
          ListTile(
            leading: const Icon(
              Icons.description,
              color: Colors.white,
            ),
            title: SizedBox(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.grey),
                controller: itemDescriptionTextEditingController,
                decoration: const InputDecoration(
                  hintText: "item description",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.white70,
            thickness: 1,
          ),

          //item price
          ListTile(
            leading: const Icon(
              Icons.price_change,
              color: Colors.white,
            ),
            title: SizedBox(
              width: 250,
              child: TextFormField(
                style: const TextStyle(color: Colors.grey),
                controller: itemPriceTextEditingController,
                decoration: const InputDecoration(
                  hintText: "item price",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),

              ),
            ),
          ),
          const Divider(
            color: Colors.white70,
            thickness: 1,
          ),
        ],
      ),
    );
  }

//default screen
  Widget defaultScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Upload New Item",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.add_photo_alternate,
            color: Colors.white,
            size: 200.0,
          ),
          ElevatedButton(
              onPressed: () {
                showDialogBox();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black54),
              child: const Text(
                "Add New Item",
                style: TextStyle(
                  color: Colors.white70,
                ),
              ))
        ],
      )),
    );
  }

//Dialogue
  showDialogBox() {
    return showDialog(
        context: context,
        builder: (c) {
          return SimpleDialog(
            backgroundColor: Colors.black,
            title: const Text(
              "Item Image",
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              //Capture image with Camera

              SimpleDialogOption(
                onPressed: () {
                  captureImageWithPhoneCamera();
                },
                child: const Text(
                  "Capture image with Camera",
                  style: TextStyle(color: Colors.grey),
                ),
              ),

              //Chosse image from Gallery

              SimpleDialogOption(
                onPressed: () {
                  chosseImageFromPhoneGallery();
                },
                child: const Text(
                  "Chosse image from Gallery",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          );
        });
  }

  captureImageWithPhoneCamera() async {
    Navigator.pop(context);

    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.camera);

      if (pickedImage != null) {
        String imagePath = pickedImage.path;
        imageUint8List = await pickedImage.readAsBytes();

        //remove background from image
        //make image transparent
        imageUint8List =
            await ApiConsumer().removeImageBackgroundApi(imagePath);

        setState(() {
          imageUint8List;
        });
      }
    } catch (errorMsg) {
      print(errorMsg.toString());
      setState(() {
        imageUint8List = null;
      });
    }
  }

  chosseImageFromPhoneGallery() async {
    Navigator.pop(context);

    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        String imagePath = pickedImage.path;
        imageUint8List = await pickedImage.readAsBytes();

        //remove background from image
        //make image transparent

        imageUint8List =
            await ApiConsumer().removeImageBackgroundApi(imagePath);

        setState(() {
          imageUint8List;
        });
      }
    } catch (errorMsg) {
      print(errorMsg.toString());
      setState(() {
        imageUint8List = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return imageUint8List == null ? defaultScreen() : uploadFormScreen();
  }
}




bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}