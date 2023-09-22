import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:skill_hands_login/Pages/feedback_list.dart';
import 'package:skill_hands_login/Pages/imagePicker.dart';
import 'constants.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class SingleSkillDetail extends StatefulWidget {
  int skillHandId;

  SingleSkillDetail({required this.skillHandId, super.key});

  @override
  State<SingleSkillDetail> createState() =>
      _SingleSkillDetailState(skillHandId);
}

class _SingleSkillDetailState extends State<SingleSkillDetail> {
  var color = const Color(0xffe17055);

  int skillHandId;
  _SingleSkillDetailState(this.skillHandId);

  final String _url = 'http://192.168.146.152:8080';

  late String name = '',
      address = '',
      experience = '',
      contact = '',
      skill = '',
      districtName = '',
      gender = '';
  late int rating = 0, districtCode = 0;

  Future<void> findByJobId(int skillHandId) async {
    var url = Uri.parse('$_url/findById/$skillHandId');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      name = data['name'];
      address = data['address'];
      gender = data['gender'];
      experience = data['experience'];
      rating = data['rating'];
      contact = data['contact'];
      Map<String, dynamic> jobsEntity = data['jobsEntity'];
      skill = jobsEntity['skill'];
      Map<String, dynamic> districtEntity = data['districtEntity'];
      districtCode = districtEntity['districtCode'];
      districtName = districtEntity['districtName'];
    } else {
      throw Exception('Could not load details of the skill hand.');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findByJobId(skillHandId);
  }

  List<Icon> displayStar() {
    List<Icon> stars = [];
    for (int i = 0; i < 5; i++) {
      if (i < rating) {
        stars.add(const Icon(
          Icons.star,
          color: Colors.yellow,
          size: 23,
        ));
      } else {
        stars.add(const Icon(
          Icons.star,
          color: Colors.grey,
          size: 23,
        ));
      }
    }
    return stars;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: findByJobId(skillHandId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: SingleChildScrollView(),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Text('${snapshot.hasError}'),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text('Profile'),
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage('assets/images/user.png'),
                        backgroundColor: Colors.transparent,
                      ),
                      Text(
                        name,
                        style: const TextStyle(
                            fontSize: 27, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 30,
                        child: ListView.builder(
                          itemCount: 1,
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: displayStar(),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Card(
                        elevation: 2,
                        color: Colors.grey[300],
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              gender == 'M'
                                  ? const Text(
                                      'Gender - Male',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    )
                                  : const Text(
                                      'Gender - Female',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                              Text(
                                'Address - $address',
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Experience - $experience',
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Contact - $contact',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      await Clipboard.setData(
                                          ClipboardData(text: contact));

                                      Fluttertoast.showToast(
                                          msg:
                                              "Contact number copied to clipboard!",
                                          gravity: ToastGravity.CENTER,
                                          backgroundColor: Colors.green);
                                      HapticFeedback.heavyImpact();
                                    },
                                    child: const Text(
                                      'Copy',
                                      style: TextStyle(
                                          decoration: TextDecoration.underline),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Job Profile - $skill',
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'District - $districtName',
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                'State - Meghalaya',
                                style: TextStyle(fontSize: 18),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FeedbackList(
                                                skillHandId: skillHandId,
                                              )));
                                },
                                child: Row(
                                  children: const [
                                    Text(
                                      'Feedbacks',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      CupertinoIcons.arrow_right_circle,
                                      color: Colors.blue,
                                      size: 17,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      SizedBox(
                        height: 46,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            UrlLauncher.launch('tel://$contact');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Call'.toUpperCase()),
                              const Icon(Icons.call),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
