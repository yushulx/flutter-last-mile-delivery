import 'package:delivery/doc_scan_page.dart';
import 'package:delivery/final_page.dart';
import 'package:flutter/material.dart';

import 'data/order_data.dart';
import 'global.dart';

class DeliveryPage extends StatefulWidget {
  const DeliveryPage({super.key, required this.order});

  final OrderData order;

  @override
  State<DeliveryPage> createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
        onWillPop: () async {
          routes.removeLast();
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text(
              'Proof of Delivery',
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
          body: Column(
            children: [
              Container(
                width: screenWidth,
                height: 149,
                decoration: const BoxDecoration(
                  color: Color(0xffF5F5F5),
                ),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 22,
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        Text(
                          'Order ID:${widget.order.id}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: screenWidth - 278,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 16),
                        Image.asset(
                          "images/icon-address.png",
                          width: 25,
                          height: 25,
                        ),
                        Text(
                          '${widget.order.address}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 16),
                        Image.asset(
                          "images/icon-time.png",
                          width: 25,
                          height: 25,
                        ),
                        Text(
                          'Delivery ${widget.order.time}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                width: screenWidth,
                height: 38,
                decoration: const BoxDecoration(
                  color: Color(0xff888888),
                ),
                child: const Row(
                  children: [
                    SizedBox(width: 22),
                    Text(
                      'Status: The courier is delivering.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: screenWidth,
                  decoration: const BoxDecoration(
                    color: Color(0xffF8F0E8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 216,
                      ),
                      SizedBox(
                        width: 240,
                        height: 52,
                        child: MaterialButton(
                          color: Colors.black,
                          onPressed: () {
                            MaterialPageRoute route = MaterialPageRoute(
                              builder: (context) => const DocScanPage(),
                            );
                            routes.add(route);
                            Navigator.push(
                              context,
                              route,
                            );
                          },
                          child: const Text(
                            'Scan Delivery Document',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                  onTap: () {
                    MaterialPageRoute route = MaterialPageRoute(
                      builder: (context) => const FinalPage(),
                    );
                    routes.add(route);
                    Navigator.push(
                      context,
                      route,
                    );
                  },
                  child: SizedBox(
                    width: screenWidth,
                    height: 52,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xffFE8E14),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(width: 10.0),
                            const Text(
                              'Confirm Delivery',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: screenWidth - 190,
                            ),
                            Image.asset("images/icon-arrow.png")
                          ]),
                    ),
                  )),
            ],
          ),
        ));
  }
}
