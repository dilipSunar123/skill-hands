import 'package:flutter/material.dart';
import 'package:skill_hands_login/models/skill_hands_model.dart';

class SkillHandsCard extends StatefulWidget {
  
  final int id;
  final String name;
  final String contact_number;
  final String email;
  final String password;

  final Function insertFn;

  const SkillHandsCard({
    required this.id, 
    required this.name, 
    required this.contact_number, 
    required this.email,  
    required this.password,
    required this.insertFn,
    Key? key, 
    // required Function insertFn
  }) : super(key: key);

  @override
  State<SkillHandsCard> createState() => _SkillHandsCardState();
}

class _SkillHandsCardState extends State<SkillHandsCard> {
  @override
  Widget build(BuildContext context) {

    var newSkillHand = SkillHandsModel(
      id: widget.id,
      name: widget.name, 
      contact_number: widget.contact_number, 
      email: widget.email, 
      password: widget.password
    );

    return Card(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                ),
                Text(
                  widget.contact_number 
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}