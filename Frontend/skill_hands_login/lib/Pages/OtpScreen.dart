import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'UpdatePassword.dart';

class OtpScreen extends StatefulWidget {
  int otp;
  String emailPassed;
  OtpScreen({required this.otp, required this.emailPassed, super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState(otp, emailPassed);
}

class _OtpScreenState extends State<OtpScreen> {
  int otp;
  String emailPassed;
  _OtpScreenState(this.otp, this.emailPassed);

  var color = const Color(0xffe17055);
  final String _url = 'http://192.168.146.152:8080';

  TextEditingController otpController = TextEditingController();

  Future<void> fetchOtp() async {
    var url = Uri.parse('$_url/otp');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var otp = json.decode(response.body);

      if (otp.toString() == otpController.text.toString()) {
        // navigate to the update password screen
        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UpdatePassword(
                      emailPassed: emailPassed,
                    )));
      } else {
        Fluttertoast.showToast(
            msg: "Incorrect OTP!",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    } else {
      throw Exception('Something went wrong!');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchOtp();
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
                  'Enter One Time Password',
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                ),
                const Text(
                  '\nEnter the One Time Password sent to your email address',
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
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          controller: otpController,
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            onPressed: () {
                              // checkEmailExistence(emailController.text);
                              fetchOtp();
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
