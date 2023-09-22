import 'package:flutter/material.dart';
import 'package:skill_hands_login/Pages/all_skills.dart';
import 'package:http/http.dart' as http;
import 'package:skill_hands_login/Pages/search_skills.dart';

import 'dart:convert';

import 'package:skill_hands_login/Pages/single_skill.dart';

import '../widgets/drawer.dart';

// ignore: must_be_immutable
class DashBoard extends StatefulWidget {
  String emailPassed = '';
  // int corresponding_id;

  DashBoard({required this.emailPassed, Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<DashBoard> createState() => _DashBoardState(emailPassed);
}

class _DashBoardState extends State<DashBoard> {
  String emailPassed;

  _DashBoardState(this.emailPassed);

  var color = const Color(0xffe17055);
  final String _url = 'http://192.168.146.152:8080';

  final List<int> idList = [];
  final List<String> skillList = [];

  Future<List<String>> getSkills() async {
    idList.clear();
    skillList.clear();

    final response = await http.get(Uri.parse('$_url/showJobs'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      data.forEach((element) {
        final String skillName = element['skill'];
        final int jobId = element['jobId'];

        idList.add(jobId);
        skillList.add(skillName);
      });

      return skillList;
    } else {
      throw Exception('Failed to get skills');
    }
  }

  List<AssetImage> images = const [
    AssetImage('assets/images/baby-sitter.PNG'),
    AssetImage('assets/images/barber.jfif'),
    AssetImage('assets/images/cook.jfif'),
    AssetImage('assets/images/mason.jfif'),
    AssetImage('assets/images/fitter.png'),
    AssetImage('assets/images/mason.jfif'),
  ];

  // late final PageController _pageController = PageController();

  List<String> corouselImages = const [
    'https://blog.ipleaders.in/wp-content/uploads/2021/09/Contract-labour.png',
    'https://media.istockphoto.com/id/1147555040/photo/young-asian-engineer-woman.jpg?s=612x612&w=0&k=20&c=n6te2d9izBtSxxG8HteqyW9vuxdRAr3aDGt_H4h_K8w=',
    'https://mumbaimirror.indiatimes.com/photo/74720281.cms',
    'https://www.financialexpress.com/wp-content/uploads/2022/11/Infra-focus-Is-India-doing-enough-for-its-construction-workers.jpg',
    'https://assets.telegraphindia.com/telegraph/2021/May/1620064399_shutterstock_1893583828.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: getSkills(),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
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
            return Scaffold(
              appBar: AppBar(
                title: const Text('Error'),
              ),
              body: Text('$snapshot.hasError'),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Dashboard'),
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AllSkills(
                                      emailPassed: emailPassed,
                                    )));
                      },
                      child: SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: SizedBox(
                          width: double.infinity,
                          height: 200,
                          child: PageView.builder(
                              itemCount: corouselImages.length,
                              pageSnapping: true,
                              // controller: _pageController,
                              itemBuilder: (context, pagePosition) {
                                return Container(
                                  height: 200,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  margin: const EdgeInsets.all(10),
                                  child: Image.network(
                                    corouselImages[pagePosition],
                                    fit: BoxFit.cover,
                                  ),
                                );
                              }),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 500,
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      childAspectRatio: 1.2,
                      children: List.generate(
                        skillList.length,
                        (index) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 20.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SingleSkill(
                                                skillId: idList[index],
                                                skillName: skillList[index],
                                                emailPassed: emailPassed)));
                                  },
                                  child: Column(
                                    children: [
                                      Card(
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: SizedBox(
                                          height: 110.0,
                                          width: 120,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage:
                                                      images[index],
                                                  backgroundColor:
                                                      Colors.transparent,
                                                ),
                                                Text(
                                                  skillList[index],
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              drawer: MyDrawer(emailPassed: emailPassed),
              floatingActionButton: FloatingActionButton(
                tooltip: 'View all jobs',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchBySkills(
                                skillIds: idList,
                                skillNames: skillList,
                                emailPassed: emailPassed,
                              )));
                },
                backgroundColor: Color(0xffe17055),
                child: const Icon(Icons.search),
              ),
            );
          }
        });
  }
}
