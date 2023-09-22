import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skill_hands_login/Pages/all_skills.dart';
import 'package:skill_hands_login/Pages/citizen_profile.dart';
import 'package:http/http.dart' as http;
import 'package:skill_hands_login/Pages/services.dart';
import 'dart:convert';

class MyDrawer extends StatefulWidget {
  String emailPassed;
  MyDrawer({required this.emailPassed, super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState(emailPassed);
}

class _MyDrawerState extends State<MyDrawer> {
  String emailPassed;
  _MyDrawerState(this.emailPassed);

  final String _url = 'http://192.168.146.152:8080';

  final List<int> idList = [];
  final List<String> skillList = [];
  late int citizenId = 0;

  Future<List<String>> getSkills() async {
    final response = await http.get(Uri.parse('$_url/showJobs'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

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

  Future<void> findIdByEmail() async {
    var url = Uri.parse('$_url/findIdByEmail/$emailPassed');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      citizenId = json.decode(response.body);
    } else {
      throw Exception('Could not find citizen');
    }
  }

  @override
  void initState() {
    super.initState();
    findIdByEmail();
  }

  Widget setupAlertDialoadContainer() {
    return ListView.builder(
        itemCount: skillList.length,
        itemBuilder: (context, index) {
          return SizedBox(
            height: 60.0,
            child: Card(
              elevation: 0,
              child: ListTile(
                title: Text(
                  skillList[index],
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => SingleSkill(
                  //             skillId: idList[index],
                  //             skillName: skillList[index],
                  //             emailPassed: emailPassed)));
                },
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: getSkills(),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return const Text('Error');
          } else {
            return Drawer(
              child: ListView(
                padding: const EdgeInsets.all(0),
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Color(0xffe17055),
                    ),
                    child: UserAccountsDrawerHeader(
                      decoration: BoxDecoration(color: Color(0xffe17055)),
                      accountName: Text(
                        'Welcome',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      accountEmail: Text("contactnicskillhands@gmail.com"),
                      currentAccountPictureSize: Size.square(75),
                      currentAccountPicture: Image(
                          image: AssetImage('assets/images/nic-logo.jpeg')),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.person,
                      color: Color(0xff00b894),
                    ),
                    title: const Text('My Profile'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProfileScreen(emailPassed: emailPassed)));
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      Icons.handyman,
                      color: Color(0xffd63031),
                    ),
                    title: const Text('All Skills'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AllSkills(
                                    emailPassed: emailPassed,
                                  )));
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      CupertinoIcons.clock,
                      color: Colors.blueGrey,
                    ),
                    title: Text('History'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Services(
                                    citizenId: citizenId,
                                  )));
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: Color(0xffffa801),
                    ),
                    title: const Text('Logout'),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      Icons.exit_to_app,
                      color: Color(0xff3c40c6),
                    ),
                    title: const Text('Exit'),
                    onTap: () {
                      SystemNavigator.pop();
                    },
                  ),
                  const SizedBox(
                    height: 150,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: const [
                        Image(
                          image: AssetImage('assets/images/digital-india.png'),
                          height: 70,
                          width: 70,
                        ),
                        Text(
                          'Designed and maintained by NIC, Meghalaya',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 13.0,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }
        });
  }
}
