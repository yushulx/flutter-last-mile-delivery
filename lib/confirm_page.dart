import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'global.dart';
import 'success_page.dart';

class ConfirmPage extends StatefulWidget {
  const ConfirmPage({super.key});

  @override
  State<ConfirmPage> createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
  final _formKey = GlobalKey<FormState>();
  final _inputDecoration = const InputDecoration(
    filled: true,
    border: OutlineInputBorder(),
  );

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('verified', true);
    data.verified = true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          routes.removeLast();
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text(
              'Confirm Identification Info',
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
          body: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SingleChildScrollView(
                    child: Form(
                        key: _formKey,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(
                              height: 40,
                            ),
                            SizedBox(
                                width: 300,
                                height: 81,
                                child: Row(children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('First Name *'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          width: 140,
                                          height: 48,
                                          child: TextFormField(
                                            initialValue: data.firstName,
                                            decoration: _inputDecoration,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Last Name *'),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                            width: 140,
                                            height: 48,
                                            child: TextFormField(
                                              initialValue: data.lastName,
                                              decoration: _inputDecoration,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
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
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Nationality *'),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                      width: 300,
                                      height: 48,
                                      child: TextFormField(
                                        initialValue: 'USA',
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
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Driver License Number *'),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                      width: 300,
                                      height: 48,
                                      child: TextFormField(
                                        initialValue: 'A1234567',
                                        decoration: _inputDecoration,
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
                              height: 67,
                            ),
                            SizedBox(
                              width: 220,
                              height: 52,
                              child: MaterialButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    saveData();
                                    MaterialPageRoute route = MaterialPageRoute(
                                      builder: (context) => const SuccessPage(),
                                    );
                                    routes.add(route);
                                    Navigator.push(
                                      context,
                                      route,
                                    );
                                  } else {
                                    print('Form is not valid');
                                  }
                                },
                                color: Colors.black,
                                child: const Text(
                                  'Confirm',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ))),
              ]),
        ));
  }
}
