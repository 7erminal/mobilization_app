class BillerTransactionModel {
  String? transactionRefNumber;
  String? service;
  String? customerName;
  String? customerNumber;
  String? amount;
  String? currency;
  String? sourceAccount;
  String? destinationAccount;
  String? charge;
  String? billerName;
  String? network;
  String? commission;
  String? externalReferenceNumber;
  String? status;
  String? date;
  String? officerName;
  String? officerNumber;


  BillerTransactionModel({
    this.transactionRefNumber,
    this.service,
    this.customerName,
    this.customerNumber,
    this.amount,
    this.currency,
    this.sourceAccount,
    this.destinationAccount,
    this.charge,
    this.billerName,
    this.network,
    this.commission,
    this.externalReferenceNumber,
    this.status,
    this.date,
      this.officerName,
      this.officerNumber
  });

  factory BillerTransactionModel.fromJson(Map<String, dynamic> json) => BillerTransactionModel(
      transactionRefNumber: json["TransactionRefNumber"].toString(),
      service: json["Service"].toString(),
      customerName: json["CustomerName"].toString(),
      customerNumber: json["CustomerNumber"].toString(),
      amount: json["Amount"].toString(),
      currency: json["TransactingCurrency"].toString(),
      sourceAccount: json["SourceAccount"].toString(),
      destinationAccount: json["DestinationAccount"].toString(),
      charge: json["Charge"].toString(),
      billerName: json["BillerName"].toString(),
      network: json["Network"].toString(),
      commission: json["Commission"].toString(),
      externalReferenceNumber: json["ExternalReferenceNumber"].toString(),
      status: json["Status"].toString(),
      date: json["TransactionDate"].toString(),
      officerName: json["OfficerName"].toString(),
      officerNumber: json["OfficerNumber"].toString()
  );

  Map<String, dynamic> toJson()=> {
    "TransactionRefNumber": transactionRefNumber,
    "Service": service,
    "CustomerName": customerName,
    "CustomerNumber": customerNumber,
    "Amount": amount,
    "Currency": currency,
    "SourceAccount": sourceAccount,
    "DestinationAccount": destinationAccount,
    "Charge": charge,
    "BillerName": billerName,
    "Network": network,
    "Commission": commission,
    "ExternalReferenceNumber": externalReferenceNumber,
    "Status": status,
    "TransactionDate": date,
    "OfficerName": officerName,
    "OfficerNumber": officerNumber
  };
}