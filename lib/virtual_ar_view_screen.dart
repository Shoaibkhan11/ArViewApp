import 'package:flutter/material.dart';

import 'package:augmented_reality_plugin/augmented_reality_plugin.dart';

class VirtualARViewScreen extends StatefulWidget {
  String? clickedItemImageLink;

  VirtualARViewScreen({this.clickedItemImageLink});

  @override
  State<VirtualARViewScreen> createState() => _VirtualARViewScreenState();
}

class _VirtualARViewScreenState extends State<VirtualARViewScreen> {
  @override
  Widget build(BuildContext context) {
    return AugmentedRealityPlugin(widget.clickedItemImageLink!.toString());
  }
}
