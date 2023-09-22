import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class FeedbackScreen extends StatefulWidget {
  String serviceAvailed, job, skillHandName;
  int citizenId;

  FeedbackScreen(
      {required this.serviceAvailed,
      required this.job,
      required this.skillHandName,
      required this.citizenId,
      super.key});

  @override
  State<FeedbackScreen> createState() =>
      // ignore: no_logic_in_create_state
      _FeedbackScreenState(serviceAvailed, job, skillHandName, citizenId);
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  String serviceAvailed, job, skillHandName;
  int citizenId;
  _FeedbackScreenState(
      this.serviceAvailed, this.job, this.skillHandName, this.citizenId);

  final String _url = 'http://192.168.146.152:8080';
  var color = const Color(0xffe17055);

  TextEditingController feedbackFormController = TextEditingController();
  TextEditingController ratingController = TextEditingController();

  int skillHandId = 0;

  Future<void> findIdByName() async {
    var url = Uri.parse('$_url/findIdByName/$skillHandName');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      skillHandId = json.decode(response.body);
    } else {
      throw Exception('Cannot find citizen id using name');
    }
  }

  Future<void> postFeedback() async {
    var url = Uri.parse('$_url/addFeedback');

    if (feedbackFormController.text.isNotEmpty &&
        ratingController.text.isNotEmpty) {
      if (int.parse(ratingController.text) > 5) {
        // vibrate
        HapticFeedback.heavyImpact();
        Fluttertoast.showToast(
            msg: "Rating must be less than or equal to 5",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0,
            backgroundColor: Colors.red);
      } else {
        var response = await http.post(url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              "skillHandId": skillHandId,
              "citizenId": citizenId,
              "feedback": feedbackFormController.text,
              "rating": int.parse(ratingController.text)
            }));
        if (response.statusCode == 200) {
          feedbackFormController.clear();
          ratingController.clear();

          Fluttertoast.showToast(
              msg: "Feedback added",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0,
              backgroundColor: Colors.green);
        } else {
          throw Exception('Feedback could not be added');
        }
      }
    } else if (feedbackFormController.text.isNotEmpty &&
        ratingController.text.isEmpty) {
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            "skillHandId": skillHandId,
            "citizenId": citizenId,
            "feedback": feedbackFormController.text,
            "rating": 0
          }));

      if (response.statusCode == 200) {
        print('Feedback added');
        feedbackFormController.clear();
        Fluttertoast.showToast(
            msg: "Feedback added",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0,
            backgroundColor: Colors.green);
      } else {
        throw Exception('Could not add feedback');
      }
    } else {
      // vibrate
      HapticFeedback.heavyImpact();

      Fluttertoast.showToast(
          msg: "Invalid feedback!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
          backgroundColor: Colors.redAccent);
    }
  }

  @override
  void initState() {
    super.initState();
    findIdByName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
        backgroundColor: const Color(0xffe17055),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Text(
                skillHandName,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2),
              ),
              Text('($job)'),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Service availed - $serviceAvailed',
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              TextFormField(
                controller: feedbackFormController,
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  prefixIcon: const Icon(CupertinoIcons.pencil),
                  label: const Text(
                    'Feedback',
                    style: TextStyle(color: Colors.black87, letterSpacing: 2),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: ratingController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    prefixIcon: const Icon(Icons.star),
                    label: const Text(
                      'Rating',
                      style: TextStyle(color: Colors.black87, letterSpacing: 2),
                    )),
              ),
              const SizedBox(
                height: 200,
              ),
              SizedBox(
                height: 50,
                width: 260,
                child: ElevatedButton(
                  onPressed: () {
                    postFeedback();
                  },
                  child: Text(
                    'Send'.toUpperCase(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
