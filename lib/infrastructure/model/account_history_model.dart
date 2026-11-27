class AccountHistoryModel {
  int? customerAccountHistoryId;
  String? customerAccount;
  double? debitAmount;
  double? creditAmount;
  String? transactionDate;

  AccountHistoryModel({
    this.customerAccountHistoryId,
    this.customerAccount,
    this.debitAmount,
    this.creditAmount,
    this.transactionDate
  });

  factory AccountHistoryModel.fromJson(Map<String, dynamic> json) => AccountHistoryModel(
    customerAccountHistoryId: json["CustomerAccountHistoryId"],
    customerAccount: json["CustomerAccount"],
    debitAmount: double.parse(json["DebitAmount"].toString()),
    creditAmount: double.parse(json["CreditAmount"].toString()),
    transactionDate: json["TransactionDate"].toString()
  );

  Map<String, dynamic> toJson()=> {
    "CustomerAccountHistoryId": customerAccountHistoryId,
    "CustomerAccount": customerAccount,
    "DebitAmount": debitAmount,
    "CreditAmount": creditAmount,
    "TransactionDate": transactionDate
  };

}