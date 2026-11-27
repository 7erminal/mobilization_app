import 'package:mobilization_app/index.dart';

class UserCorporativeModel {
  String? id;
  String? userid;
  CorporativeModel? corpId;
  String? isDefault;
  String? dateCreated;
  String? dateModified;
  String? active;

  UserCorporativeModel({
    this.id,
    this.userid,
    this.corpId,
    this.isDefault,
    this.dateCreated,
    this.dateModified,
    this.active,
    // this.active
  });

  factory UserCorporativeModel.fromJson(Map<String, dynamic> json) => UserCorporativeModel(
      id: json["Id"].toString(),
    userid: json["UserId"].toString(),
      corpId: CorporativeModel.fromJson(json["CorpId"]),
      isDefault: json["Default"].toString(),
    active: json["Active"].toString(),
      dateCreated: json["DateCreated"].toString(),
      dateModified: json["DateModified"].toString(),
      // active: json["Active"]
  );

  Map<String, dynamic> toJson()=> {
    "Id": id,
    "Userid": userid,
    "CorpId": corpId?.id.toString(),
    "IsDefault": isDefault,
    "DateCreated": dateCreated,
    "DateModified": dateModified,
    "IsActive": active,
  };
}