import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isVerified = false;
  double _screenWidth = 0, _screenHeight = 0;

  Widget verifyStatus() {
    if (_isVerified) {
      return Column(
        children: [
          Container(
            width: _screenWidth,
            height: 50,
            decoration: const BoxDecoration(
              color: Color(0xff2BCB9A),
            ),
            child: Row(
              children: <Widget>[
                SizedBox(width: (_screenWidth - 373) / 2),
                Image.asset(
                  "images/icon-group.png",
                  width: 25,
                  height: 25,
                ),
                const SizedBox(width: 10),
                const Text(
                  'Successful Identification !',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return Expanded(
        child: Container(
          width: _screenWidth,
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
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
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
        body:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
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
                          width: 200,
                          height: 32,
                          child: Text(
                            'Jane Doe',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          height: 32,
                          child: Text(
                            'abc@gmail.com',
                            style: TextStyle(
                              fontSize: 22,
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
                width: _screenWidth,
                height: 50,
                decoration: const BoxDecoration(
                  color: Color(0xffF5F5F5),
                ),
                child: Row(
                  children: <Widget>[
                    SizedBox(width: (_screenWidth - 373) / 2),
                    const Text(
                      'Jane Doe',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 262),
                    Image.asset(
                      "images/icon-edit.png",
                      width: 25,
                      height: 25,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                width: _screenWidth,
                height: 50,
                decoration: const BoxDecoration(
                  color: Color(0xffF5F5F5),
                ),
                child: Row(
                  children: <Widget>[
                    SizedBox(width: (_screenWidth - 373) / 2),
                    const Text(
                      'abc@gmail.com',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 208),
                    Image.asset(
                      "images/icon-edit.png",
                      width: 25,
                      height: 25,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              verifyStatus(),
              if (_isVerified) Expanded(child: Container()),
              SizedBox(
                width: _screenWidth,
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _isVerified = !_isVerified;
            });
          },
          backgroundColor: Colors.black,
          child: const Icon(Icons.verified),
        ));
  }
}
