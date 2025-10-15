class PixKey {
  final String keyValue;
  final String keyType;

  PixKey({required this.keyValue, required this.keyType,});

  factory PixKey.fromJson(Map<String, dynamic> json) {
    return PixKey(
      keyValue: json['keyValue'] ?? '',
      keyType: json['keyType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'keyValue': keyValue, 'keyType': keyType,};
  }
}
