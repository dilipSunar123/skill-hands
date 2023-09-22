import 'package:flutter/material.dart';
import 'package:skill_hands_login/widgets/user_input.dart';

import '../models/db_model.dart';
import '../models/skill_hands_model.dart';

class MySignupScreen extends StatefulWidget {
  const MySignupScreen({Key? key}) : super(key: key);

  @override
  State<MySignupScreen> createState() => _MySignupState();
}

class _MySignupState extends State<MySignupScreen> {

  // var db = DatabaseConnect();

  void addAccount(SkillHandsModel skillHandsModel) async {
    // await db.addAccount(skillHandsModel);
    setState(() {
      
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return UserInput(insertFn: addAccount);
  }  
}
