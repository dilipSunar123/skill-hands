// import 'package:flutter/material.dart';
// import 'package:skill_hands_login/models/skill_hands_model.dart';

// import '../models/db_model.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';


// class TestLogin extends StatelessWidget {
//   // const TestLogin({Key? key}) : super(key: key);

//   TextEditingController nameController = TextEditingController();
//   TextEditingController contactController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();

//   // final Function insertFn;
//   final db = DatabaseConnect();

//   late String name;
//   late String contact;
//   late String email;
//   late String password;

//   TestLogin({
//     Key? key
//   }): super(key: key);


//   Future<List<dynamic>> fetchData() async {
//     final response = await http.get(Uri.parse('http://172.31.67.182:8080/showDetails'));

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }

//   Future<List<dynamic>> postData(String name, String contact, String email, String password) async {
//     final response = await http.post(
//       Uri.parse('http://172.31.67.182:8080/addDetails'), 
//       headers: <String, String> {
//         'COntent-Type': 'application/json; charset=UTF-8', 
//       }, 
//       body: jsonEncode(<String, String> {
//         'name': name,
//         'contact': contact, 
//         'email': email, 
//         'password': password
//       }),
//     );

//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to post data');
//     }
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Test Login'),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(10.0), 
//           child: Column(
//             children: [
//               Text('Data from DB - '), 

//               // FutureBuilder<List<dynamic>> (
//               //   future: fetchData(), 
//               //   builder: (context, snapshot) {
//               //     if (snapshot.hasData) {
//               //       final data = snapshot.data!;

//               //       return ListView.builder(
//               //         itemCount: data.length,
//               //         itemBuilder: (context, index) {
//               //           final name = data[index]['name'];
//               //           final phone = data[index]['contact'];

//               //           return ListTile(
//               //             title: Text(
//               //               name, 
//               //             ),
//               //             subtitle: Text(phone),
//               //           );
//               //         },
//               //       );
//               //     } else if (snapshot.hasError) {
//               //       return Text('${snapshot.error}');
//               //     }
//               //     return CircularProgressIndicator();
//               //   },
//               // ),

//               TextFormField(
//                 decoration: const InputDecoration(
//                   hintText: 'enter name',
//                 ),
//                 controller: nameController,
//               ),
//               const SizedBox(
//                 height: 30.0,
//               ),
//               TextFormField(
//                 decoration: const InputDecoration(
//                   hintText: 'enter your contact',
//                 ),
//                 controller: contactController,
//               ),
//               const SizedBox(
//                 height: 30.0,
//               ),
//               TextFormField(
//                 decoration: const InputDecoration(
//                   hintText: 'enter email address',
//                 ),
//                 controller: emailController,
//               ),
//               const SizedBox(
//                 height: 30.0,
//               ),
//               TextFormField(
//                 decoration: const InputDecoration(
//                   hintText: 'enter password',
//                 ),
//                 controller: passwordController,
//               ),
//               const SizedBox(
//                 height: 30.0,
//               ),



//               ElevatedButton(
//                 onPressed: () {
//                   postData(
//                     nameController.text, 
//                     contactController.text, 
//                     emailController.text, 
//                     passwordController.text
//                   );
//                 },
//                 // color: Colors.green, 
//                 child: const Text(
//                   'Pseudo Login', 
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

