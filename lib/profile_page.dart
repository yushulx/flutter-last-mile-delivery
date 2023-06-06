import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'User Profile',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Column(
          children: <Widget>[
            const SizedBox(
              height: 14,
            ),
            Container(
              width: 373,
              height: 97,
              decoration: BoxDecoration(
                color: const Color(0xffF5F5F5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: <Widget>[
                  SizedBox(width: 22),
                  CircleAvatar(
                    backgroundImage: AssetImage('images/icon-user.png'),
                    radius: 20,
                  ),
                  SizedBox(width: 22),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 100,
                        height: 32,
                        child: Text(
                          'Jane Doe',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 173,
                        height: 32,
                        child: Text(
                          'abc@gmail.com',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              width: 373,
              height: 21,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Personal Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: screenWidth,
              height: 50,
              decoration: const BoxDecoration(
                color: Color(0xffF5F5F5),
              ),
              child: Row(
                children: <Widget>[
                  SizedBox(width: (screenWidth - 373) / 2),
                  const Text(
                    'Jane Doe',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 240),
                  Image.asset("images/icon-edit.png"),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              width: screenWidth,
              height: 50,
              decoration: const BoxDecoration(
                color: Color(0xffF5F5F5),
              ),
              child: Row(
                children: <Widget>[
                  SizedBox(width: (screenWidth - 373) / 2),
                  const Text(
                    'abc@gmail.com',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 188),
                  Image.asset("images/icon-edit.png"),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: Container(
                width: screenWidth,
                // height: 418,
                decoration: const BoxDecoration(
                  color: Color(0xffEF8888),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 67,
                    ),
                    const SizedBox(
                      width: 307,
                      height: 99,
                      child: Text(
                        '''You're just one step away from completing your sign-up. For identity verification, kindly upload a clear copy of either your passport or driver's license.''',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      width: 240,
                      height: 52,
                      child: MaterialButton(
                        color: Colors.black,
                        onPressed: () {},
                        child: const Text(
                          'Scan Identity Documents',
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
            SizedBox(
              width: screenWidth,
              height: 48,
              child: MaterialButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const SignUpPage(),
                  //   ),
                  // );
                },
                color: const Color(0xffECECEC),
                child: const Text(
                  'Log out',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }
}
