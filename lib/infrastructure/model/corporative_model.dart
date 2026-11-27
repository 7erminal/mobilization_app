class   CorporativeModel {
  String? id;
  String? clientName;
  String? clientCode;
  String? clientUrl;
  String? clientCorpId;
  String? dateCreated;
  String? dateModified;
  String? active;

  CorporativeModel({
    this.id,
    this.clientName,
    this.clientCode,
    this.clientUrl,
    this.clientCorpId,
    this.dateCreated,
    this.dateModified,
    this.active
  });

  factory CorporativeModel.fromJson(Map<String, dynamic> json) => CorporativeModel(
      id: json["Id"].toString(),
      clientName: json["ClientName"].toString(),
      clientCode: json["ClientCode"].toString(),
    clientUrl: json["ClientUrl"].toString(),
    clientCorpId: json["ClientCorpId"].toString(),
    dateCreated: json["DateCreated"].toString(),
    dateModified: json["DateModified"].toString(),
    active: json["Active"].toString()
  );

  Map<String, dynamic> toJson()=> {
    "Id": id,
    "ClientName": clientName,
    "ClientCode": clientCode,
    "ClientUrl": clientUrl,
    "ClientCorpId": clientCorpId,
    "DateCreated": dateCreated,
    "DateModified": dateModified,
  };
}