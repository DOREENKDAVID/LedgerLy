class BusinessModel {
  final int id;
  final String fullName;
  final String phoneNumber;
  final String businessName;
  final String businessType;
  final int userId;

  BusinessModel({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.businessName,
    required this.businessType,
    required this.userId,
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) => BusinessModel(
        id: json['id'] as int,
        fullName: json['fullName'] as String,
        phoneNumber: json['phoneNumber'] as String,
        businessName: json['businessName'] as String,
        businessType: json['businessType'] as String,
        userId: json['userId'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'businessName': businessName,
        'businessType': businessType,
        'userId': userId,
      };
}
