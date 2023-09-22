import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'OtpScreen.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var color = const Color(0xffe17055);

  List<String> emails = [];
  TextEditingController emailController = TextEditingController();
  final String _url = 'http://192.168.146.152:8080';

  late String emailToBePassed;

  Future<void> getAllEmails() async {
    var url = Uri.parse('$_url/showDetails');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      data.forEach((element) {
        String email = element['email'];
        emails.add(email);
      });
    }
  }

  void checkEmailExistence(String emailTyped) {
    if (!emails.contains(emailTyped)) {
      Fluttertoast.showToast(
          msg: "Email does not exists",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
          backgroundColor: Colors.redAccent);
    } else {
      // display a toast message as sending mail might take time
      emailToBePassed = emailTyped;
      Fluttertoast.showToast(
          msg: "Please wait...",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.grey);
      sendOtp(emailTyped);
    }
  }

  Future<void> sendOtp(String emailTyped) async {
    var url = Uri.parse('$_url/sendMail/$emailTyped');
    var response = await http.post(url, body: jsonEncode({"to": emailTyped}));

    if (response.statusCode == 200) {
      bool emailExists = json.decode(response.body);

      if (emailExists) {
        var u = Uri.parse('$_url/otp');
        var res = await http.get(u);

        if (res.statusCode == 200) {
          int otp = json.decode(res.body);

          // ignore: use_build_context_synchronously
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OtpScreen(
                        otp: otp,
                        emailPassed: emailToBePassed,
                      )));
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllEmails();
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
                  'Forgot password?',
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                ),
                const Text(
                  '\nEnter the email address associated with your account',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(
                  height: 30,
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
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //   children: [
                        //     const Text(
                        //       'Send',
                        //       style: TextStyle(
                        //           fontSize: 23, fontWeight: FontWeight.bold),
                        //     ),
                        //     ElevatedButton(
                        //       onPressed: () {
                        //         checkEmailExistence(emailController.text);
                        //       },
                        //       style: ElevatedButton.styleFrom(
                        //           shape: RoundedRectangleBorder(
                        //               borderRadius: BorderRadius.circular(50)),
                        //           backgroundColor: Color(0xff00b894),
                        //           padding: EdgeInsets.all(10)),
                        //       child:
                        //           const Icon(CupertinoIcons.arrow_right_circle),
                        //     )
                        //   ],
                        // ),
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () {
                              checkEmailExistence(emailController.text);
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                                backgroundColor: Color(0xff00b894),
                                padding: EdgeInsets.all(10)),
                            child:
                                const Icon(CupertinoIcons.arrow_right_circle),
                          ),
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
