class AccountStatementModel {
  int? customerAccountStatementId;
  String? customerAccount;
  double? debitAmount;
  double? creditAmount;
  String? transactionDate;
  String? transactionType;
  String? transactionDescription;

  AccountStatementModel({
    this.customerAccountStatementId,
    this.customerAccount,
    this.debitAmount,
    this.creditAmount,
    this.transactionDate,
    this.transactionDescription,
    this.transactionType
  });

  factory AccountStatementModel.fromJson(Map<String, dynamic> json) => AccountStatementModel(
      customerAccountStatementId: json["CustomerAccountStatementId"],
      customerAccount: json["CustomerAccount"],
      debitAmount: double.parse(json["Debit"].toString()),
      creditAmount: double.parse(json["Credit"].toString()),
      transactionDate: json["TransactionDate"].toString(),
      transactionDescription: json["TransactionDescription"].toString(),
      transactionType: json["TransactionType"].toString()
  );

  Map<String, dynamic> toJson()=> {
    "customerAccountStatementId": customerAccountStatementId,
    "CustomerAccount": customerAccount,
    "Debit": debitAmount,
    "Credit": creditAmount,
    "TransactionDate": transactionDate,
    "TransactionType": transactionType
  };

}