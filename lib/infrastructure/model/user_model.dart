import 'package:mobilization_app/index.dart';
import 'package:mobilization_app/infrastructure/model/branch_model.dart';

class UserModel {
  String? userId;
  String? fullName;
  String? username;
  String? ImagePath;
  String? email;
  String? phoneNumber;
  String? location;
  String? idNumber;
  String? idType;
  String? status;
  String? dateRegistered;
  BranchModel? agentCode;
  List<UserCorporativeModel>? userCorporatives;

  UserModel({
    this.userId,
    this.fullName,
    this.username,
    this.ImagePath,
    this.email,
    this.phoneNumber,
    this.location,
    this.idNumber,
    this.idType,
    this.status,
    this.dateRegistered,
    this.agentCode,
    this.userCorporatives
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      userId: json["UserId"] == null ? "" : json["UserId"].toString(),
    fullName: json["FullName"] == null ? "" : json["FullName"].toString(),
    username: json["Username"] == null ? "" : json["Username"].toString(),
    ImagePath: json["ImagePath"] == null ? "" : json["ImagePath"].toString(),
      email: json["Email"] == null ? "" : json["Email"].toString(),
      phoneNumber: json["PhoneNumber"] == null ? "" : json["PhoneNumber"].toString(),
      location: json["Location"] == null ? "" : json["Location"].toString(),
      idNumber: json["IdNumber"] == null ? "" : json["IdNumber"].toString(),
      idType: json["IdType"] == null ? "" : json["IdType"].toString(),
      status: json["Status"] == null ? "" : json["Status"].toString(),
      dateRegistered: json["DateRegistered"].toString(),
      agentCode: BranchModel.fromJson(json["Customer"]["Branch"]),
      userCorporatives: userBloc.updateUserCorporatives(json["Corporatives"])
  );

  Map<String, dynamic> toJson()=> {
    "UserId": userId,
    "FullName": fullName,
    "ImagePath": ImagePath,
    "Email": email,
    "PhoneNumber": phoneNumber,
    "Location": location,
    "IdNumber": idNumber,
    "IdType": idType,
    "Status": status,
    "DateCreated": dateRegistered,
    "Branch": agentCode?.toJson()
  };

}