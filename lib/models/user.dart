class UserModel {
  String? name;
  String? phoneNumber;
  String? gmailId;
  String? appleId;

  UserModel({this.name, this.phoneNumber, this.gmailId, this.appleId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phoneNumber'] = this.phoneNumber;
    data['gmailId'] = this.gmailId;
    data['appleId'] = this.appleId;
    return data;
  }
}
