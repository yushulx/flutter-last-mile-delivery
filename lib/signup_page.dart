import 'package:delivery/login_page.dart';
import 'package:flutter/material.dart';

import 'id_scan_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _inputDecoration = const InputDecoration(
    filled: true,
    border: OutlineInputBorder(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        SingleChildScrollView(
            child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 79,
            ),
            const SizedBox(
              width: 252,
              height: 90,
              child: Text(
                'Start Your Delivery Journey',
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
            SizedBox(
                width: 300,
                height: 81,
                child: Row(children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('First Name *'),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 140,
                          height: 48,
                          child: TextFormField(
                            decoration: _inputDecoration,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your first name';
                              }
                              return null;
                            },
                          ),
                        ),
                      ]),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Last Name *'),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            width: 140,
                            height: 48,
                            child: TextFormField(
                              decoration: _inputDecoration,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your last name';
                                }
                                return null;
                              },
                            )),
                      ]),
                ])),
            const SizedBox(
              height: 10,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Email *'),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                  width: 300,
                  height: 48,
                  child: TextFormField(
                    decoration: _inputDecoration,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      // Add more complex validation here if needed
                      return null;
                    },
                  )),
            ]),
            const SizedBox(
              height: 10,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Password *'),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                  width: 300,
                  height: 48,
                  child: TextFormField(
                    decoration: _inputDecoration,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      // Add more complex validation here if needed
                      return null;
                    },
                  )),
            ]),
            const SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Confirm Password *'),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                    width: 300,
                    height: 48,
                    child: TextFormField(
                      decoration: _inputDecoration,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        // Add more complex validation here if needed
                        return null;
                      },
                    )),
              ],
            ),
            const SizedBox(
              height: 47,
            ),
            SizedBox(
              width: 220,
              height: 52,
              child: MaterialButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const IdScanPage(),
                    ),
                  );
                },
                color: Colors.black,
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 47,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account?'),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Sign in',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              ],
            ),
          ],
        )),
      ]),
    );
  }
}
