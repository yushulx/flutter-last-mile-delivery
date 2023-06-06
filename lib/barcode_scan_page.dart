import 'package:delivery/delivery_page.dart';
import 'package:flutter/material.dart';

import 'router_manager.dart';

class BarcodeScanPage extends StatefulWidget {
  const BarcodeScanPage({super.key});

  @override
  State<BarcodeScanPage> createState() => _BarcodeScanPageState();
}

class _BarcodeScanPageState extends State<BarcodeScanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Scan Package Barcode',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            routes.removeLast();
            Navigator.of(context).pop();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.done),
        onPressed: () {
          MaterialPageRoute route = MaterialPageRoute(
            builder: (context) => const DeliveryPage(),
          );

          routes.add(route);
          Navigator.push(
            context,
            route,
          );
        },
      ),
    );
  }
}
