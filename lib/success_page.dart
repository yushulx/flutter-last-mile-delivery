import 'package:flutter/material.dart';

class SuccessPage extends StatefulWidget {
  const SuccessPage({super.key});

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
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
                  'images/icon-successful.png',
                  fit: BoxFit.contain,
                )),
            const SizedBox(
              width: 200,
              height: 85,
              child: Text(
                'Successful Identification',
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
                'You have successfully verified your identity. Please log in to continue.',
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
                  'Start to Deliver',
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
