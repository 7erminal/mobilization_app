class BranchModel {
  String? agentCode;
  String? branchName;
  String? country;
  String? location;
  String? phoneNumber;
  String? status;
  String? dateRegistered;

  BranchModel({
    this.agentCode,
    this.branchName,
    this.country,
    this.location,
    this.phoneNumber,
    this.status,
    this.dateRegistered,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) => BranchModel(
    agentCode: json["BranchId"] != null ? json["BranchId"].toString() : "",
    branchName: json["Branch"] != null ? json["Branch"].toString() : "",
    country: json["Country"] != null ? json["Country"]["Country"].toString() : "",
    location: json["Location"] != null ? json["Location"].toString() : "",
    phoneNumber: json["PhoneNumber"] != null ? json["PhoneNumber"].toString() : "",
    status: json["Active"] != null ? json["Active"].toString() : "",
    dateRegistered: json["DateCreated"] != null ? json["DateCreated"].toString() : "",
  );

  Map<String, dynamic> toJson()=> {
    "BranchId": agentCode,
    "Branch": branchName,
    "Country": country,
    "PhoneNumber": phoneNumber,
    "Location": location,
    "Status": status,
    "DateCreated": dateRegistered
  };

}