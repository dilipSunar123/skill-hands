// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:skill_hands_login/Pages/skill_hand_profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class AllSkills extends StatefulWidget {
  String emailPassed;

  AllSkills({Key? key, required this.emailPassed}) : super(key: key);

  @override
  State<AllSkills> createState() => _AllSkillsState(emailPassed);
}

class _AllSkillsState extends State<AllSkills> {
  String emailPassed;
  _AllSkillsState(this.emailPassed);

  var color = const Color(0xffe17055);

  List<dynamic> names = [];
  List<dynamic> experiences = [];
  List<dynamic> ratings = [];
  List<dynamic> contacts = [];
  List<dynamic> skills = [];

  late int citizenId = 0;
  late int skillHandId = 0;
  late int rating = 0;

  final String _url = 'http://192.168.146.152:8080';

  Future<List<dynamic>> getSkillHands() async {
    names.clear();
    experiences.clear();
    ratings.clear();
    contacts.clear();
    skills.clear();

    var url = Uri.parse('$_url/showSkills');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      data.forEach((element) {
        names.add(element['name']);
        experiences.add(element['experience']);
        ratings.add(element['rating']);
        contacts.add(element['contact']);

        var jobsEntity = element['jobsEntity'];
        var skill = jobsEntity['skill'];

        skills.add(skill);
      });

      return names;
    } else {
      throw Exception('Could not load skill hands data');
    }
  }

  // for fetching the rating
  Future<void> findByJobId(int skillHandId) async {
    var url = Uri.parse('$_url/findById/$skillHandId');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      rating = data['rating'];
    } else {
      throw Exception('Could not load details of the skill hand.');
    }
  }

  Future<void> findIdByEmail() async {
    var url = Uri.parse('$_url/findIdByEmail/$emailPassed');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      citizenId = json.decode(response.body);
    } else {
      throw Exception('Could not find citizen');
    }
  }

  //api to find the id of skill hand using his/her name
  Future<int> findIdByName(String skillHandName) async {
    var url = Uri.parse('$_url/findIdByName/$skillHandName');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      skillHandId = json.decode(response.body);

      return skillHandId;
    } else {
      throw Exception('Could not fetch id');
    }
  }

  Future<void> activityTrack(int skillHandId, int serviceId) async {
    var response = await http.post(Uri.parse('$_url/addnewServiceAvailed'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, int>{
          "citizenId": citizenId,
          "serviceId": serviceId,
          "skillHandId": skillHandId
        }));

    if (response.statusCode == 200) {
      print('Activity recorded.');
    } else {
      print('Failed.');
    }
  }

  List<Icon> displayStar(int rating) {
    List<Icon> stars = [];
    for (int i = 0; i < 5; i++) {
      if (i < rating) {
        stars.add(const Icon(
          Icons.star,
          color: Colors.yellow,
          size: 17,
        ));
      } else {
        stars.add(const Icon(
          Icons.star,
          color: Colors.grey,
          size: 17,
        ));
      }
    }
    return stars;
  }

  @override
  void initState() {
    super.initState();
    findIdByEmail();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: getSkillHands(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(color: Color(0xffe17055)),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error : ${snapshot.error}');
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text("All Skills"),
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                  color: Color(0xffb2bec3),
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      int id = await findIdByName(names[index]);

                      activityTrack(id, 1);

                      // ignore: use_build_context_synchronously
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SingleSkillDetail(skillHandId: id),
                          ));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                title: Text(
                                  names[index],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      children: displayStar(ratings[index]),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(skills[index]),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                var phone_no = contacts[index].toString();

                                UrlLauncher.launch('tel://$phone_no');
                              },
                              child: ElevatedButton(
                                onPressed: () async {
                                  int id = await findIdByName(names[index]);
                                  activityTrack(id, 2);

                                  var phone_no = contacts[index].toString();

                                  UrlLauncher.launch('tel://$phone_no');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff00b894),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                ),
                                child: const Icon(Icons.call),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  );
                },
                itemCount: names.length,
              ),
            ),
          );
        }
      },
    );
  }
}
