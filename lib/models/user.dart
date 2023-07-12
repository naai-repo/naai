class UserModel {
  String? name;
  String? phoneNumber;
  String? gmailId;
  String? appleId;
  String? gender;
  List<String>? preferredSalon;

  UserModel({
    this.name,
    this.phoneNumber,
    this.gmailId,
    this.appleId,
    this.preferredSalon,
    this.gender,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phoneNumber'] = this.phoneNumber;
    data['gmailId'] = this.gmailId;
    data['appleId'] = this.appleId;
    data['preferredSalon'] = this.preferredSalon;
    data['gender'] = this.gender;
    return data;
  }
}
