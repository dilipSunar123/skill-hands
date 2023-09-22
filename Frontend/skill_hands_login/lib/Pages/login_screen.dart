import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skill_hands_login/Pages/dashboard.dart';
import 'package:skill_hands_login/Pages/forgotPassword.dart';
import 'package:skill_hands_login/Pages/signup_screen.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constants.dart' as myUrl;
import 'package:fluttertoast/fluttertoast.dart';

class MyLoginScreen extends StatefulWidget {
  const MyLoginScreen({Key? key}) : super(key: key);

  @override
  State<MyLoginScreen> createState() => _MyLoginScreenState();
}

class _MyLoginScreenState extends State<MyLoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final String _url = 'http://192.168.146.152:8080';

  final _formKey = GlobalKey<FormState>();

  var username;
  var password;

  var emailToBePassed;

  Future<bool> userVerification(String email, String password) async {
    final url = Uri.parse('$_url/login?email=$email&password=$password');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      bool result = json.decode(response.body);

      if (result) {
        emailToBePassed = email;
        return true;
      }
      return false;
    } else {
      throw Exception('Something went wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    var color = const Color(0xffe17055);
    bool? isChecked = false;
    bool nav = false;

    return WillPopScope(
      onWillPop: () async {
        // vibrate
        HapticFeedback.heavyImpact();

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'You cannot go back to the previous screen.',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
        ));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: color,
          title: const Text(
            'Login',
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/login.jpg",
                  ),
                  // const SizedBox(
                  //   height: 50.0,
                  // ),
                  TextFormField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(20),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      hintText: 'emailaddress@example.com',
                      label: const Text(
                        'Username',
                      ),
                    ),
                    controller: usernameController,
                    validator: (validUsername) {
                      if (validUsername!.isEmpty) {
                        // vibrate
                        HapticFeedback.heavyImpact();

                        return 'Please enter a valid username';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      username = value;
                    },
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),
                  TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(20),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          hintText: 'Enter password',
                          label: const Text('Password')),
                      controller: passwordController,
                      validator: (validPassword) {
                        if (validPassword!.isEmpty) {
                          // vibrate
                          HapticFeedback.heavyImpact();
                          return 'Please enter a valid password';
                        }
                        // no error
                        return null;
                      },
                      onChanged: (value) {
                        password = value;
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPassword()));
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        )
                      ]),
                  Container(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MySignupScreen()));
                      },
                      child: const Text(
                        'Create new account',
                        style: TextStyle(
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          bool nav = _formKey.currentState!.validate();
                          // if (_formKey.currentState!.validate()) {
                          //   setState(() {
                          //     nav = true;
                          //   });
                          // }

                          if (nav) {
                            if (await userVerification(usernameController.text,
                                passwordController.text)) {
                              usernameController.clear();
                              passwordController.clear();

                              // ignore: use_build_context_synchronously
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DashBoard(emailPassed: emailToBePassed),
                                  ));
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Username or password incorrect!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                  backgroundColor: Colors.red);
                            }
                          }
                        },
                        // child: SizedBox(
                        //   height: 50,
                        //   width: 320,
                        //   child: ElevatedButton(
                        //     onPressed: () {},
                        //     child: Text('LOGIN'),
                        //     style: ElevatedButton.styleFrom(),
                        //   ),
                        // ),
                        child: Container(
                            width: 320,
                            height: 50,
                            // margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: color,
                            ),
                            child: const Center(
                                child: Text(
                              'LOGIN',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



// Container(
//   height: 40, 
//   width: 70,
//   alignment: Alignment.center,
//   decoration: BoxDecoration (
//     color: Colors.blue,
//     borderRadius: BorderRadius.circular(10),
//   ),
//   child: const Text(
//     'Login',
//     style: TextStyle(
//       color: Colors.white,
//     )
//   ),
// ),