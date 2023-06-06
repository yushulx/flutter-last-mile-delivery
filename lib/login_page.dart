import 'package:delivery/router_manager.dart';
import 'package:flutter/material.dart';

import 'order_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _inputDecoration = const InputDecoration(
    filled: true,
    border: OutlineInputBorder(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SingleChildScrollView(
              child: Column(
            children: <Widget>[
              const SizedBox(
                height: 79,
              ),
              const SizedBox(
                width: 252,
                height: 90,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Last Mile Delivery',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Login to continue!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
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
              const SizedBox(
                width: 300,
                height: 48,
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.grey),
                  )
                ]),
              ),
              const SizedBox(
                height: 47,
              ),
              SizedBox(
                width: 220,
                height: 52,
                child: MaterialButton(
                  onPressed: () {
                    MaterialPageRoute route = MaterialPageRoute(
                        builder: (context) => const OrderPage());
                    routes.add(route);
                    Navigator.push(
                      context,
                      route,
                    );
                  },
                  color: Colors.black,
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
