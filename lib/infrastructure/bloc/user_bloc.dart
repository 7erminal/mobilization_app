import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mobilization_app/index.dart';
import 'package:flutter/material.dart';

class UserBloc with ChangeNotifier {
  CustomerModel customer = CustomerModel();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  UserModel user = UserModel();
  List<LoanModel> loans = [];
  String persie = "The big block";

  List<CustomerCorporativeModel> customerCorporatives = [];
  List<UserCorporativeModel> userCorporatives = [];

  String? token;
  String? refreshToken;

  List<CorporativeModel> corporatives = [];
  List<AccountModel> accounts = [];
  List<CustomerAccountModel> customerAccounts = [];
  CustomerAccountModel selectedAccount = CustomerAccountModel();
  List<BillerTransactionModel> customerBillerTransactions = [];
  List<AgentTransactionModel> agentTransactions = [];

  List<AccountHistoryModel> accountHistory = [];
  List<AccountStatementModel> accountStatement = [];

  List<PaymentMethodModel> paymentMethods = [];

  TransactionRespModel transactionResp = TransactionRespModel();
  AgentTransactionModel transactionDetails = AgentTransactionModel();

  String depositAmount = "0.00";
  String loanAmount = "0.00";
  String cachedDepositAmount = "0.00";
  String cachedLoanAmount = "0.00";
  String momoAmount = "0.00";
  String cashAmount = "0.00";

  String totalAmount = "0.00";
  String totalCachedAmount = "0.00";

  static const String cachedTransactionsKey = 'cached_transactions';
  List<CachedTransactionModel> cachedTransactions = [];

  bool userState = false;
  bool userLoggedIn = false;

  updatePersie(String n){
    persie = n;
    notifyListeners();
  }

  void updateLoans(List<dynamic> l) {
    try{
      loans.clear();
      for(dynamic r in l){
        loans.add(LoanModel.fromJson(r));
      }
    } catch(e){
      debugPrint("An error occurred updating bundles");
      debugPrint("$e");
    }
    notifyListeners();
  }

  void clearLoans(){
    loans.clear();
    notifyListeners();
  }

  updateCustomer(dynamic c) {
    try {
      customer = CustomerModel.fromJson(c);
    } catch (e){
      debugPrint("Error:::: $e");
    }
    notifyListeners();
  }

  updateUser(dynamic c) {
    try {
      user = UserModel.fromJson(c);
      debugPrint("User model updated");
    } catch (e){
      debugPrint("Error:::: $e");
    }
    debugPrint(user.phoneNumber);
    debugPrint("About to notify listeners");
    notifyListeners();
  }

  void updateSelectedAccount(dynamic a) {
    try {
      selectedAccount = CustomerAccountModel.fromJson(a);
    } catch (e){
      debugPrint("Error:::: $e");
      try {
        selectedAccount = a;
      } catch (e){
        debugPrint("Error:::: $e");
        selectedAccount = CustomerAccountModel();
      }
    }
    notifyListeners();
  }

  void clearTransactionResp() {
    transactionResp = TransactionRespModel();
    notifyListeners();
  }

  void updateTransactionResp(dynamic r) {
    try {
      transactionResp = TransactionRespModel.fromJson(r);
    } catch (e){
      debugPrint("Error:::: $e");
    }
    notifyListeners();
  }

  void clearTransactionDetails() {
    transactionDetails = AgentTransactionModel();
    notifyListeners();
  }

  void updateTransactionDetails(dynamic r) {
    try {
      transactionDetails = AgentTransactionModel.fromJson(r);
    } catch (e){
      debugPrint("Error:::: $e");
    }
    notifyListeners();
  }

  void updateAccounts(List<dynamic> a) {
    try{
      accounts.clear();
      for(dynamic r in a){
        accounts.add(AccountModel.fromJson(r));
      }
    } catch(e){
      debugPrint("An error occurred updating bundles");
      debugPrint("$e");
    }
    notifyListeners();
  }

  updateAccountBalance(dynamic r, String accountNumber){
    for(CustomerAccountModel account in customerAccounts){
      if(account.accountNumber == accountNumber){
        account.balance = r['Result']['AvailableBalance'];
        account.clearBalance = r['Result']['ClearBalance'];
        account.loanBalance = r['Result']['LoanBalance'];
        account.sharesBalance = r['Result']['SharesBalance'];
      }
    }

    notifyListeners();
  }

  updatePaymentMethods(List<dynamic> a) {
    try{
      paymentMethods.clear();
      for(dynamic r in a){
        paymentMethods.add(PaymentMethodModel.fromJson(r));
      }
    } catch(e){
      debugPrint("An error occurred updating bundles");
      debugPrint("$e");
    }
    notifyListeners();
  }

  clearCustomerBillerTransactions(){
    customerBillerTransactions.clear();
  }

  List<String> calculateTotalTxns(){
    double total = 0.00;
    double depositTotal = 0.00;
    double loanTotal = 0.00;
    double momoTotal = 0.00;
    double cashTotal = 0.00;
    for(AgentTransactionModel txn in agentTransactions){
      debugPrint("Calculating total for transaction with amount ${txn.amount} - ${txn.transactionRefNumber} - ${txn.service} - ${txn.paymentMethod?.trim().toLowerCase()}");
      total += double.tryParse(txn.amount ?? "0.00") ?? 0.00;
      if(txn.service?.toLowerCase() == "deposit"){
        depositTotal += double.tryParse(txn.amount ?? "0.00") ?? 0.00;
      } else if(txn.service?.trim().toLowerCase() == "loan"){
        loanTotal += double.tryParse(txn.amount ?? "0.00") ?? 0.00;
      }

      if(txn.paymentMethod?.trim().toLowerCase() == "momo"){
        debugPrint("Adding to momo total");
        momoTotal += double.tryParse(txn.amount ?? "0.00") ?? 0.00;
      }
      cashTotal = total - momoTotal;
    }

    debugPrint("Total amount is $total, deposit total is $depositTotal, loan total is $loanTotal, momo total is $momoTotal, cash total is $cashTotal");
    return [total.toStringAsFixed(2), depositTotal.toStringAsFixed(2), loanTotal.toStringAsFixed(2), momoTotal.toStringAsFixed(2), cashTotal.toStringAsFixed(2)];
  }

  void updateAgentTransactions(List<dynamic> a) {
    agentTransactions.clear();
    try{
      for(dynamic r in a){
        agentTransactions.add(AgentTransactionModel.fromJson(r));
      }
    } catch(e){
      debugPrint("An error occurred updating bundles");
      debugPrint("$e");
    }

    // There is a parameter in AgentTransactionModel called transactionDate which is a string. We need to sort the transactions by this date in descending order (most recent first)
    agentTransactions.sort((a, b) {
      DateTime aDate = DateTime.tryParse(a.transactionDate ?? "") ?? DateTime(1970);
      DateTime bDate = DateTime.tryParse(b.transactionDate ?? "") ?? DateTime(1970);
      return bDate.compareTo(aDate);
    });
    notifyListeners();

    List<String> amounts = calculateTotalTxns();

    totalAmount = amounts[0];
    depositAmount = amounts[1];
    loanAmount = amounts[2];
    momoAmount = amounts[3];
    cashAmount = amounts[4];

    notifyListeners();
  }

  Future<void> loadCachedTransactions() async {
    await initLocalStorage();
    cachedTransactions.clear();
    final raw = localStorage.getItem(cachedTransactionsKey);
    if (raw != null && raw.isNotEmpty) {
      try {
        final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
        for (dynamic item in list) {
          if (item is Map) {
            cachedTransactions.add(CachedTransactionModel.fromJson(Map<String, dynamic>.from(item)));
          }
        }
      } catch(e){
        debugPrint("An error occurred loading cached transactions: $e");
      }
    }
    _updateCachedAmounts();
  }

  Future<void> cacheTransaction(Map<String, dynamic> txn) async {
    txn['id'] = txn['id'] ?? DateTime.now().microsecondsSinceEpoch.toString();
    txn['createdAt'] = txn['createdAt'] ?? DateTime.now().toIso8601String();
    cachedTransactions.insert(0, CachedTransactionModel.fromJson(txn));
    await _persistCachedTransactions();
    _updateCachedAmounts();
  }

  Future<void> removeCachedTransaction(String id) async {
    cachedTransactions.removeWhere((txn) => txn.id == id);
    await _persistCachedTransactions();
    _updateCachedAmounts();
  }

  Future<void> _persistCachedTransactions() async {
    await initLocalStorage();
    localStorage.setItem(
      cachedTransactionsKey,
      jsonEncode(cachedTransactions.map((txn) => txn.toJson()).toList()),
    );
  }

  void _updateCachedAmounts() {
    double depositTotal = 0.00;
    double loanTotal = 0.00;
    for (CachedTransactionModel txn in cachedTransactions) {
      double amount = double.tryParse(txn.amount ?? "0.00") ?? 0.00;
      if (txn.type?.trim().toLowerCase() == "loan") {
        loanTotal += amount;
      } else {
        depositTotal += amount;
      }
    }
    cachedDepositAmount = depositTotal.toStringAsFixed(2);
    cachedLoanAmount = loanTotal.toStringAsFixed(2);
    totalCachedAmount = (depositTotal + loanTotal).toStringAsFixed(2);
    notifyListeners();
  }

  Future<bool> hasNetworkConnection() async {
    try {
      final List<ConnectivityResult> results = await Connectivity().checkConnectivity();
      return results.any((result) => result != ConnectivityResult.none);
    } catch(e){
      debugPrint("An error occurred checking connectivity: $e");
      return false;
    }
  }

  Future<void> resendCachedTransactions() async {
    if (cachedTransactions.isEmpty) return;
    if (!await hasNetworkConnection()) return;

    final List<CachedTransactionModel> pending = List.from(cachedTransactions);
    for (CachedTransactionModel txn in pending) {
      if (!await hasNetworkConnection()) break;

      debugPrint("Resending cached ${txn.type} transaction of ${txn.amount}");
      dynamic resp;
      if (txn.type?.trim().toLowerCase() == "loan") {
        resp = await ApiFetcher.instance.loanRepayment(
          amount: txn.amount ?? "0.00",
          phoneNumber: txn.phoneNumber ?? "",
          accountNumber: txn.accountNumber ?? "0000000",
          customerName: txn.customerName ?? "",
          customerNumber: txn.customerNumber ?? "",
          loanId: txn.loanId ?? "",
          network: txn.network ?? "",
          paymentNetwork: txn.paymentNetwork ?? "",
          clientcode: txn.clientcode ?? "",
          sourceAccount: txn.sourceAccount ?? "0000000",
          count: 1,
          cacheOnFailure: false,
        );
      } else {
        resp = await ApiFetcher.instance.deposit(
          accountNumber: txn.accountNumber ?? "0000000",
          amount: txn.amount ?? "0.00",
          paymentNetwork: txn.paymentNetwork ?? "",
          network: txn.network ?? "",
          destination: txn.destination ?? txn.accountNumber ?? "0000000",
          clientcode: txn.clientcode ?? "",
          source: txn.source ?? "0000000",
          phoneNumber: txn.phoneNumber ?? "",
          customerName: txn.customerName ?? "",
          customerNumber: txn.customerNumber ?? "",
          count: 1,
          cacheOnFailure: false,
        );
      }

      if (resp != null && resp is Map && resp['Success'] == true) {
        await removeCachedTransaction(txn.id ?? "");
        continue;
      }
      if (ApiFetcher.isNetworkError(resp)) {
        break;
      }
      if (resp != null) {
        debugPrint("Cached ${txn.type} transaction of ${txn.amount} was rejected, dropping it from cache");
        await removeCachedTransaction(txn.id ?? "");
        continue;
      }
      break;
    }
  }

  updateCustomerBillerTransactions(List<dynamic> a) {
    try{
      for(dynamic r in a){
        customerBillerTransactions.add(BillerTransactionModel.fromJson(r));
      }
      debugPrint("Customer biller transactions are $customerBillerTransactions");
    } catch(e){
      debugPrint("An error occurred updating bundles");
      debugPrint("$e");
    }
    notifyListeners();
  }

  updateAccountHistory(List<dynamic> a) {

    try{
      accountHistory.clear();
      for(dynamic r in a){
        accountHistory.add(AccountHistoryModel.fromJson(r));
      }
    } catch(e){
      debugPrint("An error occurred updating bundles");
      debugPrint("$e");
    }
    notifyListeners();
  }

  updateAccountStatement(List<dynamic> a) {

    try{
      accountStatement.clear();
      for(dynamic r in a){
        accountStatement.add(AccountStatementModel.fromJson(r));
      }
    } catch(e){
      debugPrint("An error occurred updating bundles");
      debugPrint("$e");
    }
    notifyListeners();
  }

  clearCustomerAccount(){
    customerAccounts.clear();
    notifyListeners();
  }

  updateCustomerAccounts(List<dynamic> a) {
    customerAccounts.clear();
    try{
      for(dynamic r in a){
        customerAccounts.add(CustomerAccountModel.fromJson(r));
      }
    } catch(e){
      debugPrint("An error occurred updating customer accounts");
      debugPrint("$e");
    }
    notifyListeners();
  }

  updateCustomerCorporatives(List<dynamic> a) {
    try{
      customerCorporatives.clear();
      for(dynamic r in a){
        customerCorporatives.add(CustomerCorporativeModel.fromJson(r));
      }
    } catch(e){
      debugPrint("An error occurred updating customer co-operative");
      debugPrint("$e");
    }
    notifyListeners();

    return customerCorporatives;
  }

  List<UserCorporativeModel> updateUserCorporatives(List<dynamic> a) {
    try{
      userCorporatives.clear();
      for(dynamic r in a){
        userCorporatives.add(UserCorporativeModel.fromJson(r));
      }
    } catch(e){
      debugPrint("An error occurred updating user co-operative");
      debugPrint("$e");
    }
    notifyListeners();

    return userCorporatives;
  }

  updateToken(String t) {
    token = t;
    notifyListeners();
  }

  updateRefreshToken(String t){
    refreshToken = t;
    notifyListeners();
  }

  updateUserLoggedInState(bool state) {
    userLoggedIn = state;
    notifyListeners();
  }

  updateCorporatives(List<dynamic> c) {
    try{
      corporatives.clear();

      for(dynamic r in c){
        debugPrint("Corporate status is ${r['Active']}");
        if(r['Active']==1) {
          debugPrint("Corporate is active");
          corporatives.add(CorporativeModel.fromJson(r));
        }
      }
    } catch(e){
      debugPrint("An error occurred updating bundles");
      debugPrint("$e");
    }
    notifyListeners();
  }

  // update customer
  // updateUser(dynamic user) {
  //   debugPrint("Updating $user");
  //   try {
  //     debugPrint("Try to update");
  //     userModel = UserModel.fromJson(user);
  //     debugPrint("User model is now ... ");
  //     debugPrint("$userModel");
  //     debugPrint(userModel.fullName);
  //   } catch (e){
  //     debugPrint("Error:::: $e");
  //   }
  //   debugPrint("About to notify listeners");
  //   notifyListeners();
  // }

  void login(String username, String password) async {
    await ApiFetcher.instance.login(username: username, password: password, clientId: "889901");
  }

  Future<void> refreshTokenFunc(String refreshToken_) async {
    await ApiFetcher.instance.refreshToken(token: refreshToken_, phoneNumber: "", clientId: "");
  }

  logout() {
    // ApiFetcher.instance.logout();
    resetUserBloc();
  }

  // reset user bloc
  resetUserBloc() async {
    // userModel = UserModel();
    firstNameController.text = "";
    lastNameController.text = "";
    dateController.text = "";
    token = "";
    userState = false;
    accountHistory.clear();
    corporatives.clear();
    customer = CustomerModel();
    userLoggedIn = false;
    customerAccounts.clear();
    customerBillerTransactions.clear();
    customerCorporatives.clear();
    accounts.clear();
    selectedAccount = CustomerAccountModel();
    cachedTransactions.clear();
    cachedDepositAmount = "0.00";
    cachedLoanAmount = "0.00";
    totalCachedAmount = "0.00";
    notifyListeners();

    await initLocalStorage();
    localStorage.clear();
  }
}