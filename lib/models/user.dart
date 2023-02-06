class UserModel {
  String? name;
  String? phoneNumber;
  String? gmailId;
  String? appleId;
  List<String>? preferredSalon;

  UserModel({
    this.name,
    this.phoneNumber,
    this.gmailId,
    this.appleId,
    this.preferredSalon,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phoneNumber'] = this.phoneNumber;
    data['gmailId'] = this.gmailId;
    data['appleId'] = this.appleId;
    data['preferredSalon'] = this.preferredSalon;
    return data;
  }
}
