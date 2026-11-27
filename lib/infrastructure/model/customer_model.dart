import 'package:mobilization_app/index.dart';

class CustomerModel {
  String? customerId;
  String? fullName;
  String? ImagePath;
  String? email;
  String? phoneNumber;
  String? location;
  String? idNumber;
  String? idType;
  int? status;
  String? dateCreated;
  List<CustomerCorporativeModel>? customerCorporative;

  CustomerModel({
    this.customerId,
    this.fullName,
    this.ImagePath,
    this.email,
    this.phoneNumber,
    this.location,
    this.idNumber,
    this.idType,
    this.status,
    this.dateCreated,
    this.customerCorporative
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
    customerId: json["CustomerId"].toString(),
    fullName: json["FullName"].toString(),
    ImagePath: json["ImagePath"].toString(),
      email: json["Email"].toString(),
      phoneNumber: json["PhoneNumber"].toString(),
      location: json["Location"].toString(),
      idNumber: json["IdNumber"].toString(),
      idType: json["IdType"].toString(),
      status: int.parse(json["Status"].toString()),
      dateCreated: json["DateCreated"].toString(),
      customerCorporative: userBloc.updateCustomerCorporatives(json["CustomerCorporatives"])
  );

  Map<String, dynamic> toJson()=> {
    "CustomerId": customerId,
    "FullName": fullName,
    "ImagePath": ImagePath,
    "Email": email,
    "PhoneNumber": phoneNumber,
    "Location": location,
    "IdNumber": idNumber,
    "IdType": idType,
    "Status": status,
    "DateCreated": dateCreated
  };

}