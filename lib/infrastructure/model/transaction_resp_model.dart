class TransactionRespModel {
  String? transactionId;
  String? amount;
  String? currency;

  TransactionRespModel({
    this.currency,
    this.amount,
    this.transactionId
  });

  factory TransactionRespModel.fromJson(Map<String, dynamic> json) => TransactionRespModel(
    currency: json["Currency"].toString(),
    amount: json["Amount"].toString(),
    transactionId: json["TransactionReference"].toString(),
  );

  Map<String, dynamic> toJson()=> {
    "Currency": currency,
    "amount": amount,
    "transactionId": transactionId,
  };
}