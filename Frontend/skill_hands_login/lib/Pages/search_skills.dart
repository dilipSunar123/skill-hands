import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skill_hands_login/Pages/single_skill.dart';

class SearchBySkills extends StatefulWidget {
  List<int> skillIds;
  List<String> skillNames;
  String emailPassed;

  SearchBySkills(
      {required this.skillIds,
      required this.skillNames,
      required this.emailPassed,
      super.key});

  @override
  State<SearchBySkills> createState() =>
      _SearchBySkillsState(skillIds, skillNames, emailPassed);
}

class _SearchBySkillsState extends State<SearchBySkills> {
  TextEditingController skillNameController = TextEditingController();

  var color = const Color(0xffe17055);

  final String _url = 'http://192.168.146.152:8080';

  List<int> skillIds = [];
  List<String> skillList = [];
  String emailPassed;

  _SearchBySkillsState(this.skillIds, this.skillList, this.emailPassed);

  List<String> items = [];

  Future<int> findIdBySkillName(String skillName) async {
    final response = await http.get(Uri.parse('$_url/findBySkill/$skillName'));

    if (response.statusCode == 200) {
      final int idFetched = json.decode(response.body);

      return idFetched;
    }
    return 0;
  }

  void filterSearch(String query) {
    if (query.isNotEmpty) {
      List<String> dummyListData = [];

      items.forEach((element) {
        if (element.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(element);
        }
      });

      setState(() {
        items.clear();
        items.addAll(dummyListData);

        print('items: $items');
      });
    } else {
      setState(() {
        items.clear();
        items.addAll(skillList);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    items.addAll(skillList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: skillNameController,
                decoration: const InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                onChanged: (value) {
                  setState(() {
                    filterSearch(value);
                  });
                },
              ),
              Center(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () async {
                        int id = await findIdBySkillName(items[index]);
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SingleSkill(
                                      skillId: id,
                                      skillName: items[index],
                                      emailPassed: emailPassed,
                                    )));
                      },
                      child: ListTile(
                        title: Text(items[index]),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
