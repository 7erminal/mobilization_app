class ActivityModel {
  String? transactionID;
  String? referenceNumber;
  String? service;
  String? transactionBy;
  String? amount;
  String? currency;
  String? source;
  String? destination;
  String? charge;
  String? commission;
  String? status;
  String? date;


  ActivityModel({
    this.transactionID,
    this.referenceNumber,
    this.service,
    required this.transactionBy,
    this.amount,
    this.currency,
    this.source,
    this.destination,
    this.charge,
    this.commission,
    this.status,
    this.date
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) => ActivityModel(
      transactionID: json["Transactionid"].toString(),
      referenceNumber: json["TransactionRefNumber"].toString(),
      service: json["Service"].toString(),
      transactionBy: json["Transactionby"].toString(),
      amount: json["Amount"].toString(),
      currency: json["Currency"].toString(),
      source: json["Source"].toString(),
      destination: json["Destination"].toString(),
      charge: json["Charge"].toString(),
      commission: json["Commission"].toString(),
      status: json["Status"].toString(),
      date: json["TransactionDate"].toString()
  );

  Map<String, dynamic> toJson()=> {
    "Transactionid": transactionID,
    "TransactionRefNumber": referenceNumber,
    "Service": service,
    "Transactionby": transactionBy,
    "Amount": amount,
    "Currency": currency,
    "Source": source,
    "Destination": destination,
    "Charge": charge,
    "Commission": commission,
    "Status": status,
    "TransactionDate": date
  };
}