class AgentTransactionModel {
  String? transactionRefNumber;
  String? service;
  String? customerName;
  String? customerNumber;
  String? amount;
  String? currency;
  String? sourceChannel;
  String? sourceAccount;
  String? destinationAccount;
  String? charge;
  String? package;
  String? network;
  String? commission;
  String? externalReferenceNumber;
  String? status;
  String? date;
  String? officerName;
  String? officerNumber;
  String? paymentMethod;
  String? transactionDate;
  String? corpId;


  AgentTransactionModel({
    this.transactionRefNumber,
    this.service,
    this.customerName,
    this.customerNumber,
    this.amount,
    this.currency,
    this.sourceChannel,
    this.sourceAccount,
    this.destinationAccount,
    this.charge,
    this.package,
    this.network,
    this.commission,
    this.externalReferenceNumber,
    this.status,
    this.date,
    this.officerName,
    this.officerNumber,
    this.paymentMethod,
    this.transactionDate,
      this.corpId
  });

  factory AgentTransactionModel.fromJson(Map<String, dynamic> json) => AgentTransactionModel(
      transactionRefNumber: json["TransactionRefNumber"].toString(),
      service: json["Service"].toString(),
      customerName: json["CustomerName"].toString(),
      customerNumber: json["CustomerNumber"].toString(),
      amount: json["Amount"].toString(),
      currency: json["TransactingCurrency"].toString(),
      sourceChannel: json["SourceChannel"].toString(),
      sourceAccount: json["SourceAccount"].toString(),
      destinationAccount: json["DestinationAccount"].toString(),
      charge: json["Charge"].toString(),
      package: json["Package"].toString(),
      network: json["Network"].toString(),
      commission: json["Commission"].toString(),
      externalReferenceNumber: json["ExternalReferenceNumber"].toString(),
      status: json["Status"].toString(),
      date: json["TransactionDate"].toString(),
      officerName: json["OfficerName"].toString(),
      officerNumber: json["OfficerNumber"].toString(),
      paymentMethod: json["ExtraDetails3"].toString(),
      transactionDate: json["TransactionDate"].toString(),
      corpId: json["CorpId"].toString()
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
    "Network": network,
    "Commission": commission,
    "ExternalReferenceNumber": externalReferenceNumber,
    "Status": status,
    "TransactionDate": date,
    "OfficerName": officerName,
    "OfficerNumber": officerNumber,
    "PaymentMethod": paymentMethod,
    "CorpId": corpId
  };
}