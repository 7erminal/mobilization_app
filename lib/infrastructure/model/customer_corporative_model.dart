import 'package:mobilization_app/index.dart';

class CustomerCorporativeModel {
  String? id;
  String? customerNumber;
  CorporativeModel? corpId;
  String? isDefault;
  String? dateCreated;
  String? dateModified;
  String? active;

  CustomerCorporativeModel({
    this.id,
    this.customerNumber,
    this.corpId,
    this.isDefault,
    this.dateCreated,
    this.dateModified,
    this.active,
    // this.active
  });

  factory CustomerCorporativeModel.fromJson(Map<String, dynamic> json) => CustomerCorporativeModel(
      id: json["Id"].toString(),
      customerNumber: json["CustomerNumber"].toString(),
      corpId: CorporativeModel.fromJson(json["CorpId"]),
      isDefault: json["IsDefault"].toString(),
    active: json["IsActive"].toString(),
      dateCreated: json["DateCreated"].toString(),
      dateModified: json["DateModified"].toString(),
      // active: json["Active"]
  );

  Map<String, dynamic> toJson()=> {
    "Id": id,
    "CustomerNumber": customerNumber,
    "CorpId": corpId?.id.toString(),
    "IsDefault": isDefault,
    "DateCreated": dateCreated,
    "DateModified": dateModified,
    "IsActive": active,
  };
}