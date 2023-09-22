import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:skill_hands_login/Pages/skill_hand_profile.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import 'filterByGender.dart';

// ignore: must_be_immutable
class SingleDistrictFilter extends StatefulWidget {
  int districtCode;
  int blockCode;
  int jobId;
  int citizenId;
  String skillName;

  SingleDistrictFilter(
      {required this.districtCode,
      required this.blockCode,
      required this.jobId,
      required this.citizenId,
      required this.skillName,
      super.key});

  @override
  State<SingleDistrictFilter> createState() =>
      // ignore: no_logic_in_create_state
      _SingleDistrictFilterState(
          districtCode, blockCode, jobId, citizenId, skillName);
}

class _SingleDistrictFilterState extends State<SingleDistrictFilter> {
  int districtCode, blockCode, jobId, citizenId;
  String skillName;
  _SingleDistrictFilterState(this.districtCode, this.blockCode, this.jobId,
      this.citizenId, this.skillName);

  List<int> ids = [];
  List<dynamic> names = [];
  List<dynamic> experiences = [];
  List<dynamic> ratings = [];
  List<dynamic> contacts = [];
  List<dynamic> genders = [];
  bool filterByRatingisChecked = false;

  var color = const Color(0xffe17055);

  final String _url = 'http://192.168.146.152:8080';

  Future<void> filterByDistrictCode() async {
    var url =
        Uri.parse('$_url/findByDistrictCodeAndJobId/$districtCode/$jobId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      ids.clear();
      names.clear();
      experiences.clear();
      ratings.clear();
      contacts.clear();
      genders.clear();

      List<dynamic> data = jsonDecode(response.body);

      data.forEach((element) {
        ids.add(element['id']);
        names.add(element['name']);
        genders.add(element['gender']);
        experiences.add(element['experience']);
        ratings.add(element['rating']);
        contacts.add(element['contact']);
      });
    } else {
      throw Exception('Could not load data');
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

  int skillHandId = 0;
  //api to find the id of skill hand using his/her name
  Future<int> findIdByName(String skillHandName) async {
    var url = Uri.parse('$_url/findIdByName/$skillHandName');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      skillHandId = json.decode(response.body);

      print('Skill Hand ID : $skillHandId');

      return skillHandId;
    } else {
      throw Exception('Could not fetch id');
    }
  }

  Future<List<dynamic>> filterByRatings(int districtCode, int jobId) async {
    filterByRatingisChecked = true;

    var url = Uri.parse(
        '$_url/findByDistrictCodeAndJobIdFilterByRating/$districtCode/$jobId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      names.clear();
      genders.clear();
      experiences.clear();
      ratings.clear();
      contacts.clear();

      final List<dynamic> data = jsonDecode(response.body);

      data.forEach((element) {
        names.add(element['name']);
        genders.add(element['gender']);
        experiences.add(element['experience']);
        ratings.add(element['rating']);
        contacts.add(element['contact']);
      });

      return names;
    } else {
      throw Exception('Something went wrong!');
    }
  }

  Future<void> filterByGender(int skillId, String gender) async {
    names.clear();
    experiences.clear();
    ratings.clear();
    contacts.clear();
    genders.clear();

    var url;
    if (gender == 'Male') {
      url = Uri.parse('$_url/filterByGender/$skillId/M');
    } else {
      url = Uri.parse('$_url/filterByGender/$skillId/F');
    }

    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      data.forEach((element) {
        String name = element['name'];
        names.add(name);

        String experience = element['experience'];
        experiences.add(experience);

        int rating = element['rating'];
        ratings.add(rating);

        String contact = element['contact'];
        contacts.add(contact);

        if (element['gender'] == 'M') {
          genders.add('Male');
        } else {
          genders.add('Female');
        }

        // print(nameList);
        // print(experienceList);
        // print(ratingList);
        // print(contactList);
        // print(genderList);
      });
    } else {
      throw Exception('Could not filter by gender');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: filterByRatingisChecked == true
            ? filterByRatings(districtCode, jobId)
            : filterByDistrictCode(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('$snapshot.hasError'),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Filter results'),
                backgroundColor: color,
                actions: [
                  PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        const PopupMenuItem(
                            value: 0, child: Text('Filter by ratings')),
                      ];
                    },
                    onSelected: (value) {
                      if (value == 0) {
                        setState(() {
                          filterByRatingisChecked = true;
                        });
                        filterByRatings(districtCode, jobId);
                      }
                    },
                  )
                ],
              ),
              body: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: names.isNotEmpty
                      ? Column(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                  height: 1,
                                  color: Colors.grey,
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
                                                SingleSkillDetail(
                                                    skillHandId: id),
                                          ));
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        const SizedBox(
                                          height: 20.0,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ListTile(
                                                title: Text(
                                                  '${names[index]} (${genders[index]})',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18.0),
                                                ),
                                                subtitle: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      height: 7,
                                                    ),
                                                    Row(
                                                      children: displayStar(
                                                          ratings[index]),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                // UrlLauncher.launch("tel:+91//9485435063");
                                                var phoneNo =
                                                    contacts[index].toString();

                                                UrlLauncher.launch(
                                                    'tel://$phoneNo');
                                              },
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  int id = await findIdByName(
                                                      names[index]);
                                                  activityTrack(id, 2);

                                                  var phone_no = contacts[index]
                                                      .toString();

                                                  UrlLauncher.launch(
                                                      'tel://$phone_no');
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Color(0xff00b894),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0)),
                                                ),
                                                child: const Icon(Icons.call),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20.0,
                                        )
                                      ],
                                    ),
                                  );
                                },
                                itemCount: names.length,
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: const [
                              Image(
                                  image: AssetImage(
                                      'assets/images/not-found.jpg')),
                              Text(
                                'Not found!',
                                style:
                                    TextStyle(fontSize: 23, color: Colors.grey),
                              ),
                            ],
                          ),
                        ))),
            );
          }
        });
  }
}
