import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:intl/date_symbol_data_local.dart';

import 'package:skill_hands_login/Pages/feedback.dart';
import 'package:skill_hands_login/Pages/skill_hand_profile.dart';
import 'package:skill_hands_login/widgets/skill_hand_card.dart';

class Services extends StatefulWidget {
  final int citizenId;

  Services({required this.citizenId, super.key});

  @override
  State<Services> createState() => _ServicesState(citizenId);
}

class _ServicesState extends State<Services> {
  int citizenId;
  _ServicesState(this.citizenId);

  var color = const Color(0xffe17055);

  final String _url = 'http://192.168.146.152:8080';

  List<String> skillHandNames = [];
  List<String> jobs = [];
  List<String> servicesAvailed = [];
  List<int> skillHandIdList = [];
  List<String> serviceAvailedDates = [];

  // by default the screen will load on view details service
  int serviceId = 1;

  // Future<void> findByServiceId(int serviceId) async {
  //   var url = Uri.parse('$_url/findByService/$serviceId');

  //   var response = await http.get(url);

  //   if (response.statusCode == 200) {
  //     skillHandNames.clear();
  //     jobs.clear();
  //     servicesAvailed.clear();
  //     skillHandIdList.clear();

  //     List<dynamic> data = jsonDecode(response.body);

  //     data.forEach((element) {
  //       Map<String, dynamic> servicesMasterEntity =
  //           element['servicesMasterEntity'];
  //       String serviceName = servicesMasterEntity['serviceName'];
  //       servicesAvailed.add(serviceName);

  //       Map<String, dynamic> skillsEntity = element['skillsEntity'];
  //       String name = skillsEntity['name'];
  //       int skillHandId = skillsEntity['id'];

  //       skillHandNames.add(name);
  //       skillHandIdList.add(skillHandId);

  //       Map<String, dynamic> jobsEntity = skillsEntity['jobsEntity'];
  //       String job = jobsEntity['skill'];
  //       jobs.add(job);

  //       String date = element['serviceAvailedDate'];
  //       DateTime dateTime = DateTime.parse(date);
  //       // String formattedDate = DateFormat.yMEd().add_jm().format(dateTime);

  //       // print(formattedDate);

  //       serviceAvailedDates.add(DateFormat.yMMMMd().add_jm().format(dateTime));
  //     });
  //   }
  // }

  // function to find services according to the citizen id

  Future<void> findByCitizenIdAndServiceId(int citizenId, int serviceId) async {
    var url =
        Uri.parse('$_url/findByCitizenIdAndServiceId/$citizenId/$serviceId');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      skillHandNames.clear();
      jobs.clear();
      servicesAvailed.clear();
      skillHandIdList.clear();
      serviceAvailedDates.clear();

      List<dynamic> data = jsonDecode(response.body);

      data.forEach((element) {
        Map<String, dynamic> servicesMasterEntity =
            element['servicesMasterEntity'];
        String serviceName = servicesMasterEntity['serviceName'];
        servicesAvailed.add(serviceName);

        Map<String, dynamic> skillsEntity = element['skillsEntity'];
        String name = skillsEntity['name'];
        int skillHandId = skillsEntity['id'];

        skillHandNames.add(name);
        skillHandIdList.add(skillHandId);

        Map<String, dynamic> jobsEntity = skillsEntity['jobsEntity'];
        String job = jobsEntity['skill'];
        jobs.add(job);

        String dateFetched = element['serviceAvailedDate'];
        DateTime dateTime = DateTime.parse(dateFetched);
        DateTime isDateTime = dateTime.toLocal();

        String formattedDateTime =
            DateFormat('yyyy-MM-dd hh:mm:ss a').format(isDateTime);

        // print(formattedDateTime);
        serviceAvailedDates.add(formattedDateTime);
      });

      print(serviceAvailedDates);
    } else {
      throw Exception('could not load services');
    }
  }

// void formatDateWithTimezone() {
//   DateTime now = DateTime.now();

//   // Replace "Your_Timezone" with the desired timezone identifier
//   String targetTimezone = "Your_Timezone";

//   initializeDateFormatting(targetTimezone, null).then((_) {
//     // Initialize the DateFormat with the desired pattern and locale
//     DateFormat formatter = DateFormat.yMMMMd('IST').add_Hms();

//     // Format the date
//     String formattedDate = formatter.format(now);

//     print(formattedDate); // Output: May 16, 2023 4:32:18 PM
//   });
// }

  @override
  void initState() {
    super.initState();
    // initially data with service - viewed details is loaded
    // findByServiceId(1);
    findByCitizenIdAndServiceId(citizenId, 1);
  }

  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;

      if (_currentIndex == 0) {
        serviceId = 1;
      } else {
        serviceId = 2;
      }
      findByCitizenIdAndServiceId(citizenId, serviceId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: findByCitizenIdAndServiceId(citizenId, serviceId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: SingleChildScrollView(),
              ),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('${snapshot.hasError}, hi'),
              ),
            );
          } else {
            return Scaffold(
                appBar: AppBar(
                  title: const Text('History'),
                ),
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: jobs.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    // leading: const Icon(
                                    //   Icons.handshake_rounded,
                                    //   color: Colors.amber,
                                    // ),
                                    title: InkWell(
                                      child: _currentIndex == 1
                                          ? Row(
                                              children: [
                                                Text(
                                                  skillHandNames[index],
                                                  textAlign: TextAlign.left,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                const Icon(
                                                  Icons.call_made,
                                                  color: Colors.green,
                                                  size: 17,
                                                )
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                Text(
                                                  skillHandNames[index],
                                                  textAlign: TextAlign.left,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                const Icon(
                                                  Icons.remove_red_eye_sharp,
                                                  color: Colors.blueGrey,
                                                )
                                              ],
                                            ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SingleSkillDetail(
                                                      skillHandId:
                                                          skillHandIdList[
                                                              index],
                                                    )));
                                      },
                                    ),
                                    subtitle: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Text(
                                        //     '\n${jobs[index]}\nService - ${servicesAvailed[index]}\n\nDate - ${serviceAvailedDate[index]}'),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Text(jobs[index]),
                                        Text(servicesAvailed[index]),
                                        const SizedBox(
                                          height: 16.0,
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              CupertinoIcons.clock,
                                              size: 14,
                                              color: Colors.green,
                                            ),
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            Text(
                                              serviceAvailedDates[index],
                                              style:
                                                  const TextStyle(fontSize: 11),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    trailing: _currentIndex == 1
                                        ? TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          FeedbackScreen(
                                                              serviceAvailed:
                                                                  servicesAvailed[
                                                                      index],
                                                              job: jobs[index],
                                                              skillHandName:
                                                                  skillHandNames[
                                                                      index],
                                                              citizenId:
                                                                  citizenId)));
                                            },
                                            child: const Text(
                                              'Feedback',
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline),
                                            ))
                                        : const SizedBox(),
                                    onTap: () {},
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: _currentIndex,
                  onTap: onTabTapped,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.view_agenda),
                      label: 'Viewed Details',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.phone),
                      label: 'Called',
                    ),
                  ],
                ));
          }
        });
  }
}
