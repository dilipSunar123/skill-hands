import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skill_hands_login/Pages/login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';

import '../Pages/dashboard.dart';

class UserInput extends StatelessWidget {
  final Function insertFn;
  UserInput({required this.insertFn, Key? key});

  // var color = const Color(0xff6C62FE);
  var color = const Color(0xffe17055);
  final String _url = 'http://192.168.146.152:8080';

  String? gender;
  var allSet = false;
  late bool emailExists;

  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController c_passwordController = TextEditingController();

  late List<String> emailListFromDB = [];

  var name, cNumber, email, pass, cPass;

  final _formKey = GlobalKey<FormState>();

  Future<void> postData(
      String name, String contact, String email, String password) async {
    final url = Uri.parse('$_url/showDetails');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      for (var element in data) {
        String emailFetchedFromDB = element['email'];

        emailListFromDB.add(emailFetchedFromDB);
      }
    }

    if (emailListFromDB.contains(email)) {
      emailExists = true;

      // vibrate
      HapticFeedback.heavyImpact();

      Fluttertoast.showToast(
          msg: "Email already exists!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
          backgroundColor: Colors.redAccent);
    } else {
      emailExists = false;

      await http.post(
        Uri.parse('$_url/addDetails'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'contact': contact,
          'email': email,
          'password': password
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        title: const Text(
          'Signup',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset("assets/images/signup.jpg"),
                const SizedBox(
                  height: 30.0,
                ),
                TextFormField(
                  controller: nameController, // controller
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    label: const Text(
                      'Name',
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      allSet = false;

                      // vibrate
                      HapticFeedback.heavyImpact();
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    name = value;
                  },
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  controller: contactController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    label: const Text(
                      'Contact Number',
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || value.toString().length != 10) {
                      // vibrate
                      HapticFeedback.heavyImpact();

                      allSet = false;
                      return 'Please enter your contact number';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    cNumber = value;
                  },
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    label: const Text(
                      'Email',
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      allSet = false;

                      // vibrate
                      HapticFeedback.heavyImpact();
                      return 'Please enter your email address';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    email = value;
                  },
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    label: const Text(
                      'Create Password',
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      // vibrate
                      HapticFeedback.heavyImpact();

                      allSet = false;
                      return 'Please enter a password';
                    } else if (value.toString().length < 6) {
                      // vibrate
                      HapticFeedback.heavyImpact();

                      allSet = false;
                      return 'Password should be more than 6 characters';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    pass = value;
                  },
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  controller: c_passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    label: const Text(
                      'Confirm Password',
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      // vibrate
                      HapticFeedback.heavyImpact();

                      allSet = false;
                      return 'Please re-enter the password';
                    } else if (pass.toString().length < 6) {
                      // vibrate
                      HapticFeedback.heavyImpact();

                      allSet = false;
                      return 'Confirm password should be more than 6 characters';
                    } else if (pass.toString() != cPass.toString()) {
                      // vibrate
                      HapticFeedback.heavyImpact();

                      allSet = false;
                      return 'Password and Confirm password not matching';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    cPass = value;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyLoginScreen(),
                          ));
                    },
                    child: const Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 42.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          allSet = true;
                        }
                        if (allSet) {
                          postData(nameController.text, contactController.text,
                              emailController.text, passwordController.text);

                          if (emailExists == false) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DashBoard(
                                        emailPassed: emailController.text)));
                          }
                        }
                      },
                      child:
                          // Column(
                          //   children: [
                          //     SizedBox(
                          //       height: 50,
                          //       width: 320,
                          //       child: ElevatedButton(
                          //         onPressed: () {},
                          //         child: Text('SIGNUP'),
                          //         style: ElevatedButton.styleFrom(),
                          //       ),
                          //     ),
                          //     SizedBox(
                          //       height: 12,
                          //     ),
                          //   ],
                          // )
                          Column(
                        children: [
                          Container(
                              width: 320,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: color,
                              ),
                              child: const Center(
                                  child: Text(
                                'SIGNUP',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ))),
                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
