import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class FeedbackList extends StatefulWidget {
  int skillHandId;

  FeedbackList({required this.skillHandId, super.key});

  @override
  State<FeedbackList> createState() => _FeedbackListState(skillHandId);
}

class _FeedbackListState extends State<FeedbackList> {
  int skillHandId;
  _FeedbackListState(this.skillHandId);

  var color = const Color(0xffe17055);

  final String _url = 'http://192.168.146.152:8080';

  late List<String> citizenNames = [];
  late List<String> feedbacks = [];
  late List<int> ratings = [];
  late List<String> feedbackPostedDates = [];

  Future<void> getParticularFeedback() async {
    citizenNames.clear();
    feedbacks.clear();
    ratings.clear();
    feedbackPostedDates.clear();

    var url = Uri.parse('$_url/getParticularFeedback/$skillHandId');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      data.forEach((element) {
        Map<String, dynamic> registerEntity = element['registerEntity'];
        String citizenName = registerEntity['name'];
        citizenNames.add(citizenName);

        String feedback = element['feedback'];
        feedbacks.add(feedback);

        int rating = element['rating'];
        ratings.add(rating);

        // String feedbackPostedDate = element['feedbackPostedDate'];

        // DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
        // DateTime parsedDateTime = dateFormat.parse(feedbackPostedDate);

        String feedbackPostedDate = element['feedbackPostedDate'];
        DateTime dateTime = DateTime.parse(feedbackPostedDate);
        DateTime isDateTime = dateTime.toLocal();

        String feedbackDateFormat =
            DateFormat('yyyy-MM-dd hh:mm:ss a').format(isDateTime);

        feedbackPostedDates.add(feedbackDateFormat);
      });

      print(citizenNames);
    } else {
      throw Exception('Cannot get particular feedback');
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
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: getParticularFeedback(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Text('${snapshot.hasError}'),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Feedback'),
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: feedbacks.isNotEmpty
                      ? ListView.builder(
                          itemCount: feedbacks.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 0),
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        '"${feedbacks[index]}"',
                                        style: const TextStyle(fontSize: 22),
                                      ),
                                      subtitle: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children:
                                                displayStar(ratings[index]),
                                          ),
                                          Text(
                                            '\n- ${citizenNames[index]}',
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                CupertinoIcons.clock,
                                                size: 14,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(
                                                width: 3,
                                              ),
                                              Text(
                                                feedbackPostedDates[index],
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Expanded(
                                    //   child: ListView.builder(
                                    //     itemCount: 1,
                                    //     itemBuilder:
                                    //         (BuildContext context,
                                    //             int index) {
                                    //       return Row(
                                    //         mainAxisAlignment:
                                    //             MainAxisAlignment.center,
                                    //         crossAxisAlignment:
                                    //             CrossAxisAlignment.center,
                                    //         children: displayStar(
                                    //             ratings[index]),
                                    //       );
                                    //     },
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            );
                          })
                      : Center(
                          child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: const [
                              Image(
                                  image: AssetImage(
                                      'assets/images/not-found.jpg')),
                              Text(
                                'No feedback found!',
                                style:
                                    TextStyle(fontSize: 23, color: Colors.grey),
                              ),
                            ],
                          ),
                        )),
                ),
              ),
            );
          }
        });
  }
}
