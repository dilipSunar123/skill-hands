import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:skill_hands_login/Pages/login_screen.dart';

class UpdatePassword extends StatefulWidget {
  String emailPassed;
  UpdatePassword({required this.emailPassed, super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState(emailPassed);
}

class _UpdatePasswordState extends State<UpdatePassword> {
  String emailPassed;
  _UpdatePasswordState(this.emailPassed);

  final String _url = 'http://192.168.146.152:8080';

  TextEditingController passwordController = TextEditingController();
  TextEditingController c_passwordController = TextEditingController();

  late int id;
  late String name;
  late String contact = "";

  // fetch id from the email passed
  Future<void> findIdByEmail() async {
    var url = Uri.parse('$_url/findIdByEmail/$emailPassed');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      id = data;

      findById();
    }
  }

  // after id is found from the above code
  // now all other details are fetched using the below Fn.
  Future<void> findById() async {
    var url = Uri.parse('$_url/get/$id');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      data.forEach((key, value) {
        name = data['name'];
        contact = data['contact'];
      });
    }
  }

  // update the details (password)
  Future<void> resetPassword() async {
    var url = Uri.parse('$_url/updatePassword/$id');
    var response = await http.put(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "id": id,
          "name": name,
          "email": emailPassed,
          "contact": contact,
          "password": passwordController.text.toString()
        }));

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Password updated successfully!",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.green);

      Navigator.push(
          context, MaterialPageRoute(builder: ((context) => MyLoginScreen())));
    } else {
      throw Exception("Could not reset password");
    }
  }

  void validateFields() {
    if (passwordController.text.isEmpty && c_passwordController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Fields cannot be empty!",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
    } else if (passwordController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Password cannot be empty!",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
    } else if (c_passwordController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Confirm Password cannot be empty!",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
    } else if (passwordController.text.toString() !=
        c_passwordController.text.toString()) {
      Fluttertoast.showToast(
          msg: "Passwords do not match!",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
    } else if (passwordController.text.length < 6) {
      Fluttertoast.showToast(
          msg: "Password length should be greater than or equal to 6",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
    } else {
      // everything's fine
      resetPassword();
    }
  }

  @override
  initState() {
    super.initState();
    findIdByEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Image(
                  image: NetworkImage(
                      'https://img.freepik.com/free-vector/forgot-password-concept-illustration_114360-1095.jpg?w=740&t=st=1683869483~exp=1683870083~hmac=a6000e62e0299288369614d539e454dd8770104c760ed3508e9c1961cdd2d831'),
                  height: 300,
                  width: 300,
                ),
                const Text(
                  'Reset Password',
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              label: const Text('Password')),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Password field cannot be empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: c_passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              label: const Text('Confirm Password')),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Confirm Password field cannot be empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () {
                                // checkEmailExistence(emailController.text);
                                validateFields();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff00b894),
                                  padding: const EdgeInsets.all(10)),
                              child: const Text('Reset Password')),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
