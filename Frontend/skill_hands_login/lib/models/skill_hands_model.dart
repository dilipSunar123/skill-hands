class SkillHandsModel {
  int? id;
  final String name;
  final String contact_number;
  final String email;
  final String password;

  SkillHandsModel({
    this.id,
    required this.name, 
    required this.contact_number, 
    required this.email,  
    required this.password,
  });

  // convert the raw data to map
  Map<String, dynamic> toMap() {
    return {
      'id': id, 
      'name': name, 
      'contact_number': contact_number, 
      'email': email, 
      'password': password,
    };
  }

  @override
  String toString() {
    return 'SkillHands(id: $id, name: $name, contact number: $contact_number, email: $email)';
  }
}