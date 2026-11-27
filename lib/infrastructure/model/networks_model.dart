class NetworksModel {
  String? NetworkId;
  String? NetworkName;
  String? NetworkCode;
  String? NetworkReferenceId;
  String? Description;
  String? Active;

  NetworksModel({
    this.NetworkId,
    this.NetworkName,
    this.NetworkCode,
    this.NetworkReferenceId,
    this.Description,
    this.Active,
  });

  factory NetworksModel.fromJson(Map<String, dynamic> json) => NetworksModel(
    NetworkId: json["NetworkId"].toString(),
    NetworkName: json["NetworkName"].toString(),
    NetworkCode: json["NetworkCode"].toString(),
    NetworkReferenceId: json["NetworkReferenceId"].toString(),
    Description: json["Description"].toString(),
    Active: json["Active"].toString(),
  );

  Map<String, dynamic> toJson()=> {
    "NetworkId": NetworkId,
    "NetworkName": NetworkName,
    "NetworkCode": NetworkCode,
    "NetworkReferenceId": NetworkReferenceId,
    "Description": Description,
    "Active": Active,
  };
}