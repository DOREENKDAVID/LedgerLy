class UserModel {
  final int id;
  final String email;

  UserModel({required this.id, required this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as int,
        email: json['email'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
      };
}
