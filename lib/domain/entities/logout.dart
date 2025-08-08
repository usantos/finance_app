class Logout {
  final bool status;
  final String mensagem;

  Logout({required this.status, required this.mensagem,});

  factory Logout.fromJson(Map<String, dynamic> json) {
    return Logout(
      status: json['status'] ?? false,
      mensagem: json['mensagem'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'mensagem': mensagem,};
  }
}
