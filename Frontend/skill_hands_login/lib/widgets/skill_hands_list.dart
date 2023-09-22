// import 'package:flutter/material.dart';
// import 'package:skill_hands_login/models/db_model.dart';
// import 'package:skill_hands_login/widgets/skill_hand_card.dart';

// class SkillHandsList extends StatelessWidget {

//   final Function insertFn;
//   final db = DatabaseConnect();

//   SkillHandsList({
//     required this.insertFn, 
//     Key? key
//   }): super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: FutureBuilder(
//         future: db.getSkillHands(), 
//         initialData: const[],
//         builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
//           var data = snapshot.data;
//           var datalength = data!.length;

//           return datalength == 0
//             ? 
//             const Center(
//               child: Text('no data found'),
//             )
//             :
//             ListView.builder(
//               itemCount: datalength,
//               itemBuilder: (context, i) => SkillHandsCard(
//                 id: data[i].id,
//                 name: data[i].name,
//                 contact_number: data[i].contact_number, 
//                 email: data[i].email,
//                 password: data[i].password,
//                 insertFn: insertFn
//               ),
//             );
//         },
//       ),
//     );
//   }
// }