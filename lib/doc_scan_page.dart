import 'package:flutter/material.dart';

class DocScanPage extends StatefulWidget {
  const DocScanPage({super.key});

  @override
  State<DocScanPage> createState() => _DocScanPageState();
}

class _DocScanPageState extends State<DocScanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Scan Delivery Document',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Stack(
        children: <Widget>[
          Positioned(bottom: 0, child: Text('Scan Delivery Document')),
        ],
      ),
    );
  }
}
