class User {
  final String id;
  final String name;
  final String cpf;
  final String phone;
  final String email;

  User({required this.id, required this.name, required this.cpf, required this.phone, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      cpf: json['cpf'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'cpf': cpf, 'phone': phone, 'email': email};
  }
}
