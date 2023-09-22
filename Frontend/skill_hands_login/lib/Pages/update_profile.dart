import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:skill_hands_login/Pages/citizen_profile.dart';
import 'dart:convert';

import 'package:skill_hands_login/Pages/login_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UpdateProfile extends StatefulWidget {
  String emailAddressPassed;

  UpdateProfile({required this.emailAddressPassed, super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState(emailAddressPassed);
}

class _UpdateProfileState extends State<UpdateProfile> {
  String emailAddressPassed;
  _UpdateProfileState(this.emailAddressPassed);

  final _formKey = GlobalKey<FormState>();

  final String _url = 'http://192.168.146.152:8080';

  @override
  void initState() {
    super.initState();
    getInfo(emailAddressPassed);
  }

  late String name;
  late String contact;
  late String password;

  late List<dynamic> details = [];

  Future<List<dynamic>> getInfo(String email) async {
    final response = await http.get(Uri.parse('$_url/findInfoByEmail/$email'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      name = data['name'];
      contact = data['contact'];
      password = data['password'];

      details.add(name);
      details.add(contact);

      return details;
    }
    throw Exception('Could not load data');
  }

  Future<void> getIdByEmail(String email) async {
    var response = await http.get(Uri.parse('$_url/findIdByEmail/$email'));

    if (response.statusCode == 200) {
      int idFetched = json.decode(response.body);

      if (passwordController.text.isEmpty) {
        // vibrate
        HapticFeedback.heavyImpact();

        Fluttertoast.showToast(
            msg: "Password field cannot be empty!",
            backgroundColor: Colors.red,
            gravity: ToastGravity.BOTTOM);
      } else if (passwordController.text == password) {
        await http.put(Uri.parse('$_url/updateDetail/$idFetched'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              "name": nameController.text,
              "contact": contactController.text,
              "email": emailController.text,
              "password": passwordController.text
            }));

        // once details are updated. Clear the password field
        passwordController.clear();

        Fluttertoast.showToast(
            msg: "Profile Updated",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0,
            backgroundColor: Colors.green);

        // redirect to the profile screen
        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ProfileScreen(emailPassed: emailAddressPassed)));
      } else {
        // vibrate
        HapticFeedback.heavyImpact();

        Fluttertoast.showToast(
            msg: "Incorrect Password!",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0,
            backgroundColor: Colors.red);
      }
    }
  }

  late TextEditingController nameController = TextEditingController(text: name);
  late TextEditingController contactController =
      TextEditingController(text: contact);
  late TextEditingController emailController =
      TextEditingController(text: emailAddressPassed);
  late TextEditingController passwordController = TextEditingController();

  bool allSet = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: getInfo(emailAddressPassed),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Update'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(12),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50.0,
                      ),
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                            labelText: "Name",
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)))),
                        validator: (name) {
                          if (name!.isEmpty) {
                            allSet = false;
                            return 'Name field cannot be empty';
                          }
                          // no error
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: contactController,
                        decoration: const InputDecoration(
                            labelText: "Contact Number",
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)))),
                        validator: (contact_no) {
                          if (contact_no!.isEmpty) {
                            allSet = false;
                            return 'Contact cannot be null';
                          }
                          // no error
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                            labelText: "Email Address",
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)))),
                        validator: (contact_no) {
                          if (contact_no!.isEmpty) {
                            allSet = false;
                            return 'Email address cannot be null';
                          }
                          // no error
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)))),
                        validator: (password) {
                          if (password!.isEmpty) {
                            allSet = false;
                            return 'Password field cannot be empty';
                          } else if (password.toString().length < 6) {
                            allSet = false;
                            return 'Password length cannot be less than 6 characters';
                          }
                          // no error
                          return null;
                        },
                      ),
                      const SizedBox(height: 100),
                      InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              allSet = true;
                            });
                          }

                          if (allSet) {
                            print("All set true");
                          } else {
                            print("All set false");
                          }
                        },
                        child: SizedBox(
                          width: 250,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              getIdByEmail(emailAddressPassed);
                            },
                            child: const Text('UPDATE'),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Text('Error');
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
