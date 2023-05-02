import 'package:flutter/material.dart';
import 'package:nextgen/virtual_ar_view_screen.dart';

import 'items.dart';

class ItemDetailsScreen extends StatefulWidget {
  Items? clickedItemInfo;

  ItemDetailsScreen({this.clickedItemInfo});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.clickedItemInfo!.itemName.toString(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.pinkAccent,
        onPressed: () {
          //try items virtualy using the AR view
          Navigator.push(context, MaterialPageRoute(builder:(c)=> VirtualARViewScreen(
            clickedItemImageLink:widget.clickedItemInfo!.itemImage.toString()
          )));


        },
        
        label: const Text("Try Virtually (AR View)"),
        icon: Icon(
          Icons.mobile_screen_share_rounded,
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(widget.clickedItemInfo!.itemImage.toString()),

              //item name
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 8),
                child: Text(
                  widget.clickedItemInfo!.itemName.toString(),
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              //item description
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 6),
                child: Text(
                  widget.clickedItemInfo!.itemDescription.toString(),
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),

              //item price
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "₹" + widget.clickedItemInfo!.itemPrice.toString(),
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(left: 8, right: 280),
                child: Divider(
                  height: 1,
                  thickness: 2,
                  color: Colors.white70,
                ),
              ),

              //seller name 
               Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Seller Name : " + widget.clickedItemInfo!.sellerName.toString(),
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),


              //seller phone number 
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Seller Phone No. : " + widget.clickedItemInfo!.sellerPhone.toString(),
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),

            



            ],
          ),
        ),
      ),
    );
  }
}
