class CachedTransactionModel {
  String? id;
  String? type;
  String? amount;
  String? phoneNumber;
  String? accountNumber;
  String? paymentNetwork;
  String? network;
  String? destination;
  String? clientcode;
  String? source;
  String? customerName;
  String? customerNumber;
  String? loanId;
  String? sourceAccount;
  String? createdAt;

  CachedTransactionModel({
    this.id,
    this.type,
    this.amount,
    this.phoneNumber,
    this.accountNumber,
    this.paymentNetwork,
    this.network,
    this.destination,
    this.clientcode,
    this.source,
    this.customerName,
    this.customerNumber,
    this.loanId,
    this.sourceAccount,
    this.createdAt,
  });

  factory CachedTransactionModel.fromJson(Map<String, dynamic> json) => CachedTransactionModel(
      id: json["id"].toString(),
      type: json["type"].toString(),
      amount: json["amount"].toString(),
      phoneNumber: json["phoneNumber"].toString(),
      accountNumber: json["accountNumber"].toString(),
      paymentNetwork: json["paymentNetwork"].toString(),
      network: json["network"].toString(),
      destination: json["destination"].toString(),
      clientcode: json["clientcode"].toString(),
      source: json["source"].toString(),
      customerName: json["customerName"].toString(),
      customerNumber: json["customerNumber"].toString(),
      loanId: json["loanId"].toString(),
      sourceAccount: json["sourceAccount"].toString(),
      createdAt: json["createdAt"].toString()
  );

  Map<String, dynamic> toJson()=> {
    "id": id,
    "type": type,
    "amount": amount,
    "phoneNumber": phoneNumber,
    "accountNumber": accountNumber,
    "paymentNetwork": paymentNetwork,
    "network": network,
    "destination": destination,
    "clientcode": clientcode,
    "source": source,
    "customerName": customerName,
    "customerNumber": customerNumber,
    "loanId": loanId,
    "sourceAccount": sourceAccount,
    "createdAt": createdAt
  };
}
