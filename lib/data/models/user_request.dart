class UserRequest {
  final String name;
  final String cpf;
  final String phone;
  final String email;
  final String password;

  UserRequest({
    required this.name,
    required this.cpf,
    required this.phone,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {'name': name, 'cpf': cpf, 'phone': phone, 'email': email, 'password': password};
  }

  factory UserRequest.fromMap(Map<String, dynamic> map) {
    return UserRequest(
      name: map['name'] ?? '',
      cpf: map['cpf'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }
}
