import 'package:delivery/confirm_page.dart';
import 'package:flutter/material.dart';

class IdScanPage extends StatefulWidget {
  const IdScanPage({super.key});

  @override
  State<IdScanPage> createState() => _IdScanPageState();
}

class _IdScanPageState extends State<IdScanPage> {
  bool _isDriverLicense = true;

  Widget getButtons() {
    if (_isDriverLicense) {
      return Row(children: [
        GestureDetector(
            onTap: () {
              setState(() {
                _isDriverLicense = true;
              });
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: 50,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xff323234),
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFFfe8e14),
                      width: 2,
                    ),
                  ),
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    width: 20.0,
                    height: 20.0,
                    decoration: const BoxDecoration(
                      color: Color(0xFFfe8e14),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  const Text(
                    'Driver License',
                    style: TextStyle(color: Color(0xFFfe8e14)),
                  )
                ]),
              ),
            )),
        GestureDetector(
            onTap: () {
              setState(() {
                _isDriverLicense = false;
              });
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: 50,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xff0C0C0C),
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    width: 20.0,
                    height: 20.0,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  const Text(
                    'Passport',
                    style: TextStyle(color: Colors.white),
                  )
                ]),
              ),
            ))
      ]);
    } else {
      return Row(children: [
        GestureDetector(
            onTap: () {
              setState(() {
                _isDriverLicense = true;
              });
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: 50,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xff0C0C0C),
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    width: 20.0,
                    height: 20.0,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  const Text(
                    'Driver License',
                    style: TextStyle(color: Colors.white),
                  )
                ]),
              ),
            )),
        GestureDetector(
            onTap: () {
              setState(() {
                _isDriverLicense = false;
              });
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: 50,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xff323234),
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFFfe8e14),
                      width: 2,
                    ),
                  ),
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    width: 20.0,
                    height: 20.0,
                    decoration: const BoxDecoration(
                      color: Color(0xFFfe8e14),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  const Text(
                    'Passport',
                    style: TextStyle(color: Color(0xFFfe8e14)),
                  )
                ]),
              ),
            ))
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Scan Identity Documents',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Positioned(bottom: 0, child: getButtons()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.done),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ConfirmPage(),
            ),
          );
        },
      ),
    );
  }
}
