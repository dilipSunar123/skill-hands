import 'dart:core';

import 'package:flutter/material.dart';
import 'package:skill_hands_login/Pages/district_filter_result.dart';
import 'package:skill_hands_login/Pages/skill_hand_profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import 'filterByGender.dart';

class SingleSkill extends StatefulWidget {
  int skillId;
  String skillName;
  String emailPassed;

  SingleSkill(
      {Key? key,
      required this.skillId,
      required this.skillName,
      required this.emailPassed})
      : super(key: key);

  @override
  State<SingleSkill> createState() =>
      _SingleSkillState(skillId, skillName, emailPassed);
}

class _SingleSkillState extends State<SingleSkill> {
  int skillId;
  String skillName;
  String emailPassed;

  _SingleSkillState(this.skillId, this.skillName, this.emailPassed);

  final String _url = 'http://192.168.146.152:8080';

  var color = const Color(0xffe17055);

  List<dynamic> nameList = [];
  List<dynamic> experienceList = [];
  List<dynamic> ratingList = [];
  List<dynamic> contactList = [];
  List<dynamic> genderList = [];

  String selectedDistrict = "-";
  String selectedBlock = "-";

  bool filterByRatingisChecked = false;

  Future<List<dynamic>> getIndividualSkill() async {
    nameList.clear();
    experienceList.clear();
    ratingList.clear();
    contactList.clear();
    genderList.clear();

    var url = Uri.parse('$_url/findByJobId/$skillId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      data.forEach((element) {
        nameList.add(element['name']);
        experienceList.add(element['experience']);
        ratingList.add(element['rating']);
        contactList.add(element['contact']);
        genderList.add(element['gender']);
      });

      return nameList;
    } else {
      throw Exception('Something went wrong!');
    }
  }

  List<String> districts = [];
  List<int> districtCodes = [];
  List<String> blocks = [];
  List<String> filteredBlocks = [];

  late int selectedDistrictCode;
  late int selectedBlockCode;
  late int citizenId = 0;

  Future<void> getAllDistricts() async {
    var url = Uri.parse('$_url/findAllDistrict');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      // print(data);
      districts.add('-');

      data.forEach((element) {
        districtCodes.add(element['districtCode']);
        districts.add(element['districtName']);
      });
    } else {
      throw Exception('Could not load districts');
    }
  }

  Future<void> getAllBlocks() async {
    filteredBlocks.clear();
    filteredBlocks.add('-');
    var url = Uri.parse('$_url/findAllBlock');

    final response = await http.get(url);

    blocks.add('-');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      data.forEach((element) {
        blocks.add(element['blockName']);
      });
    } else {
      throw Exception('Could not load blocks');
    }
  }

  Future<List<String>> getIdByDistrictName(String districtName) async {
    var url = Uri.parse('$_url/getIdByName/$districtName');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final code = json.decode(response.body);

      selectedDistrictCode = code;

      var urlToFindAllBlocks = Uri.parse('$_url/filterBlock/$code');

      final res = await http.get(urlToFindAllBlocks);

      if (res.statusCode == 200) {
        List<dynamic> blockData = jsonDecode(res.body);

        filteredBlocks.clear();
        filteredBlocks.add('-');

        blockData.forEach((element) {
          filteredBlocks.add(element['blockName']);
        });

        return filteredBlocks;
      } else {
        print("There are no blocks under this district");
        throw Exception('Could not find district code');
      }
    } else {
      throw Exception('Could not find district code');
    }
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

  Future<void> findIdByEmail() async {
    var url = Uri.parse('$_url/findIdByEmail/$emailPassed');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      citizenId = json.decode(response.body);
    } else {
      throw Exception('Could not find citizen');
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

  Future<List<dynamic>> filterByRatings(int skillId) async {
    filterByRatingisChecked = true;

    var url = Uri.parse('$_url/findByJobIdFilterByRating/$skillId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      nameList.clear();
      experienceList.clear();
      ratingList.clear();
      contactList.clear();
      genderList.clear();

      final List<dynamic> data = jsonDecode(response.body);

      data.forEach((element) {
        nameList.add(element['name']);
        experienceList.add(element['experience']);
        ratingList.add(element['rating']);
        contactList.add(element['contact']);
        genderList.add(element['gender']);
      });

      return nameList;
    } else {
      throw Exception('Something went wrong!');
    }
  }

  Future<void> findIdByBlockName(String blockName) async {
    var url = Uri.parse('$_url/findIdByBlockName/$blockName');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      data.forEach((element) {
        selectedBlockCode = element['blockCode'];
      });
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

  String? genderValue;

  void dialogForGenderFilter() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: const Text('Select gender'),
              content: SizedBox(
                height: 300,
                child: Column(
                  children: [
                    RadioListTile(
                      title: const Text('Male'),
                      value: 'Male',
                      groupValue: genderValue,
                      onChanged: (value) {
                        setState(() {
                          genderValue = value.toString();
                        });
                        // genderValue = value.toString();
                      },
                    ),
                    RadioListTile(
                      title: const Text('Female'),
                      value: 'Female',
                      groupValue: genderValue,
                      onChanged: (value) {
                        setState(() {
                          genderValue = value.toString();
                        });
                      },
                    ),
                    RadioListTile(
                      title: const Text('Others'),
                      value: 'Others',
                      groupValue: genderValue,
                      onChanged: (value) {
                        setState(() {
                          genderValue = value.toString();
                        });
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FilterByGender(
                                        jobId: skillId,
                                        gender: genderValue,
                                        citizenId: citizenId,
                                        skillName: skillName)));
                          },
                          child: const Text('Search')),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  Future<void> filterByGender(int skillId, String gender) async {
    nameList.clear();
    experienceList.clear();
    ratingList.clear();
    contactList.clear();
    genderList.clear();

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
        nameList.add(name);

        String experience = element['experience'];
        experienceList.add(experience);

        int rating = element['rating'];
        ratingList.add(rating);

        String contact = element['contact'];
        contactList.add(contact);

        if (element['gender'] == 'M') {
          genderList.add('Male');
        } else {
          genderList.add('Female');
        }
      });
    } else {
      throw Exception('Could not filter by gender');
    }
  }

  @override
  void initState() {
    super.initState();
    getAllDistricts();
    getAllBlocks();

    // this loads.. as, citizenId is to be fetched first
    findIdByEmail();
  }

  void showFilterDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Filter'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        height: 40.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: const Color(0xffdfe6e9),
                        ),
                        child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                          value: selectedDistrict,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedDistrict = newValue!;

                              getIdByDistrictName(selectedDistrict);
                            });
                          },
                          items: districts
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem(
                                value: value, child: Text(value));
                          }).toList(),
                        )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        height: 40.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: const Color(0xffdfe6e9),
                        ),
                        child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                          value: selectedBlock,
                          onChanged: (String? newValue) {
                            setState(() {
                              print('$newValue selected');

                              findIdByBlockName(selectedBlock);

                              selectedBlock = newValue!;
                            });
                          },
                          items: filteredBlocks
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem(
                                value: value, child: Text(value));
                          }).toList(),
                        )),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            // filterByDistrictCode();
                            selectedBlockCode = 1;

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SingleDistrictFilter(
                                          districtCode: selectedDistrictCode,
                                          blockCode: selectedBlockCode,
                                          jobId: skillId,
                                          citizenId: citizenId,
                                          skillName: skillName,
                                        )));
                          },
                          child: const Text(
                            'Search',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: filterByRatingisChecked == true
          ? filterByRatings(skillId)
          : getIndividualSkill(),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
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
          return Text('Error : ${snapshot.error}');
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(skillName),
              actions: [
                // TextButton(
                //     onPressed: () {
                //       showFilterDialog();
                //     },
                //     child: const Padding(
                //       padding: EdgeInsets.all(6),
                //       child: SizedBox(
                //         child: InkWell(
                //           child: Image(
                //               color: Colors.white,
                //               image: AssetImage(
                //                 'assets/images/filter.png',
                //               )),
                //         ),
                //       ),
                //     ))
                PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        value: 0,
                        child: Text('Filter by district and block'),
                      ),
                      const PopupMenuItem(
                          value: 1, child: Text('Filter by ratings')),
                      const PopupMenuItem(
                          value: 2, child: Text('Filter by gender'))
                    ];
                  },
                  onSelected: (value) {
                    if (value == 0) {
                      showFilterDialog();
                    } else if (value == 1) {
                      setState(() {
                        setState(() {
                          filterByRatingisChecked = true;
                        });
                        filterByRatings(skillId);
                      });
                    } else if (value == 2) {
                      dialogForGenderFilter();
                    }
                  },
                )
              ],
            ),
            body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: nameList.length >= 1
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
                                    int id =
                                        await findIdByName(nameList[index]);

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
                                                '${nameList[index]} (${genderList[index]})',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
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
                                                        ratingList[index]),
                                                  ),
                                                  // Text(
                                                  //     '\nExperience - ${experienceList[index]}'),
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
                                              // UrlLauncher.launch("tel:+91//9485435063");
                                              var phoneNo =
                                                  contactList[index].toString();

                                              UrlLauncher.launch(
                                                  'tel://$phoneNo');
                                            },
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                int id = await findIdByName(
                                                    nameList[index]);
                                                activityTrack(id, 2);

                                                var phone_no =
                                                    contactList[index]
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
                              itemCount: nameList.length,
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Image(
                                image: AssetImage(
                                    'assets/images/not-found(2).jpg')),
                            Text(
                              'No $skillName found!',
                              style:
                                  TextStyle(fontSize: 23, color: Colors.grey),
                            ),
                          ],
                        ),
                      ))),
          );
        }
      },
    );
  }
}
