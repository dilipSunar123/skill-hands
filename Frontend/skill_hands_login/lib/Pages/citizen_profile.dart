import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:skill_hands_login/Pages/update_profile.dart';

class ProfileScreen extends StatefulWidget {
  String emailPassed;
  ProfileScreen({required this.emailPassed, super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState(emailPassed);
}

class _ProfileScreenState extends State<ProfileScreen> {
  String emailPassed;
  _ProfileScreenState(this.emailPassed);

  final String _url = 'http://192.168.146.152:8080';

  List<String> details = [];

  Future<List<String>> detailsFromEmail_Api() async {
    var url = Uri.parse('$_url/findInfoByEmail/$emailPassed');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      data.forEach((key, value) {
        if (key != 'id' && key != 'password' && key != 'fName') {
          details.add(value);
        }
      });

      return details;
    }
    throw Exception('Could not fetch the details');
  }

  @override
  void initState() {
    super.initState();
    detailsFromEmail_Api();
  }

  @override
  Widget build(BuildContext context) {
    var color = const Color(0xffe17055);

    return FutureBuilder<List<String>>(
      future: detailsFromEmail_Api(),
      builder: (BuildContext cxt, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('$snapshot.hasError');
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    const CircleAvatar(
                      radius: 75,
                      backgroundImage: AssetImage('assets/images/user.png'),
                      backgroundColor: Colors.transparent,
                    ),
                    // TextButton(
                    //     onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => ImagePickerWidget()));
                    // },
                    // child: const Text('Browse')),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      details[0],
                      style: const TextStyle(
                          fontSize: 26.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // email
                    Text(
                      details[1],
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    // contact number
                    Text(
                      details[2],
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(
                      height: 300,
                    ),
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdateProfile(
                                      emailAddressPassed: emailPassed)));
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: color),
                        child: const Text('UPDATE'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
