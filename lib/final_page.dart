import 'package:flutter/material.dart';

class FinalPage extends StatefulWidget {
  const FinalPage({super.key});

  @override
  State<FinalPage> createState() => _FinalPageState();
}

class _FinalPageState extends State<FinalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
                width: 200,
                height: 280,
                child: Image.asset(
                  'images/icon-confirmed.png',
                  fit: BoxFit.contain,
                )),
            const SizedBox(
              width: 298,
              height: 45,
              child: Text(
                'Delivery Confirmed!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              width: 284,
              height: 48,
              child: Text(
                'You have successfully confirmed the delivery. Thank you!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 47,
            ),
            SizedBox(
              width: 220,
              height: 52,
              child: MaterialButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const SignUpPage(),
                  //   ),
                  // );
                },
                color: Colors.black,
                child: const Text(
                  'Back to Orders',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
