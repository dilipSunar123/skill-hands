import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skill_hands_login/Pages/skill_hand_details.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class FilterByGender extends StatefulWidget {
  int jobId;
  String? gender;
  String skillName;
  int citizenId;

  FilterByGender(
      {required this.jobId,
      required this.gender,
      required this.citizenId,
      required this.skillName,
      super.key});

  @override
  State<FilterByGender> createState() =>
      _FilterByGenderState(jobId, gender!, citizenId, skillName);
}

class _FilterByGenderState extends State<FilterByGender> {
  int jobId;
  String gender;
  String skillName;
  int citizenId;
  _FilterByGenderState(this.jobId, this.gender, this.citizenId, this.skillName);

  List<int> ids = [];
  List<dynamic> names = [];
  List<dynamic> experiences = [];
  List<dynamic> ratings = [];
  List<dynamic> contacts = [];

  bool filterByRatingisChecked = false;

  var color = const Color(0xffe17055);

  final String _url = 'http://192.168.146.152:8080';

  Future<void> filterByGender(int jobId, String gender) async {
    ids.clear();
    names.clear();
    experiences.clear();
    ratings.clear();
    contacts.clear();

    var url;
    if (gender == 'Male') {
      url = Uri.parse('$_url/filterByGender/$jobId/M');
    } else if (gender == 'Female') {
      url = Uri.parse('$_url/filterByGender/$jobId/F');
    } else {
      url = Uri.parse('$_url/filterByGender/$jobId/O');
    }
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      data.forEach((element) {
        int id = element['id'];
        ids.add(id);

        String name = element['name'];
        names.add(name);

        String experience = element['experience'];
        experiences.add(experience);

        int rating = element['rating'];
        ratings.add(rating);

        String contact = element['contact'];
        contacts.add(contact);
      });
    } else {
      throw Exception('Could not fetch data');
    }
  }

  int skillHandId = 0;
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

  Future<void> filterByRatings(int skillId) async {
    filterByRatingisChecked = true;
    var url;

    if (gender == 'Male') {
      url = Uri.parse('$_url/filterByGenderAndRatingSort/M/$skillId');
    } else if (gender == 'Female') {
      url = Uri.parse('$_url/filterByGenderAndRatingSort/F/$skillId');
    } else {
      url = Uri.parse('$_url/filterByGenderAndRatingSort/O/$skillId');
    }
    final response = await http.get(url);

    if (response.statusCode == 200) {
      ids.clear();
      names.clear();
      experiences.clear();
      ratings.clear();
      contacts.clear();

      final List<dynamic> data = jsonDecode(response.body);

      data.forEach((element) {
        ids.add(element['id']);
        names.add(element['name']);
        experiences.add(element['experience']);
        ratings.add(element['rating']);
        contacts.add(element['contact']);
      });
    } else {
      throw Exception('Something went wrong!');
    }
  }

  // @override
  // initState() {
  //   super.initState();

  //   filterByGender(jobId, gender);
  // }

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
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: filterByRatingisChecked
          ? filterByRatings(jobId)
          : filterByGender(jobId, gender),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('${snapshot.hasError}'),
            ),
          );
        } else {
          return Scaffold(
              appBar: AppBar(
                title: Text('$skillName ($gender)'),
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
                          // filterByRatingisChecked = true;
                          filterByRatings(jobId);
                        });
                      }
                    },
                  )
                ],
              ),
              body: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: names.length >= 1
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
                                                  names[index],
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
                                                    // Text(
                                                    //     '\nExperience - ${experiences[index]}'),
                                                    // const SizedBox(
                                                    //   height: 2,
                                                    // ),
                                                    // const Text(
                                                    //   'View details',
                                                    //   style: TextStyle(
                                                    //       color: Colors.blue,
                                                    //       decoration:
                                                    //           TextDecoration
                                                    //               .underline),
                                                    // )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
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
                        ))));
        }
      },
    );
  }
}
