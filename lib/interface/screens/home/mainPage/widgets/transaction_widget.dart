import 'package:flutter/material.dart';
import 'package:mobilization_app/index.dart';
import 'package:provider/provider.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';

class TransactionWidget extends StatefulWidget {
  const TransactionWidget({super.key});

  @override
  State<TransactionWidget> createState() => _TransactionWidgetState();
}

enum TransactionType { deposit, loan }
enum PaymentMethod { mobileMoney, bankTransfer, cash }

class _TransactionWidgetState extends State<TransactionWidget> {
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController selectedProductController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController mobileMoneyNumberController = TextEditingController();
  String labelText = "Account ID";
  IconData prefixIcon = Icons.account_balance_wallet_outlined;
  bool isValidated = false;
  bool isTransacting = false;
  bool isValidating = false;
  bool isDialogOpen = false;
  late FocusNode accountIdFocusNode;
  late FocusNode productFocusNode;
  TransactionType? transactionType = TransactionType.deposit;
  PaymentMethod? paymentMethod = PaymentMethod.mobileMoney;
  Future<dynamic>? corperatives;
  String selectedCorporativeId = "";
  String selectedLoanId = "";
  String? selectedCooperativeValue;
  String selectedNetwork = "MTN_MOBILEMONEY";

  Future<dynamic>? loanList;

  @override
  void initState() {
    super.initState();
    accountIdFocusNode = FocusNode();
    productFocusNode = FocusNode();

    accountIdFocusNode.addListener(() {
      if (accountIdFocusNode.hasFocus) {
        // Logic when the field gains focus
        debugPrint("TextField has focus");
        validateAccountID();
      } else {
        // Logic when the field loses focus (on blur)
        debugPrint("TextField lost focus");
        validateAccountID(reset: false);
      }
    });
  }


  @override
  void dispose() {
    accountNumberController.dispose();
      selectedProductController.dispose();
      accountIdFocusNode.dispose();
      productFocusNode.dispose();
    mobileMoneyNumberController.dispose();
      amountController.dispose();

    super.dispose();
  }

  Future<void> validateAccountID({bool reset = true}) async {
    // Simulate an API call to validate the account ID
    if(!mounted)return;
    if(reset){
      setState(() {
        isValidating = false;
        isValidated = false;
        accountNumberController.clear();
        mobileMoneyNumberController.clear();
        userBloc.updateSelectedAccount(CustomerAccountModel());
        userBloc.updateCustomerAccounts([]);
        setState(() {
          transactionType = TransactionType.deposit;
          selectedCorporativeId = "";

        });
      });
    } else {
      debugPrint("Validating account ID: ${accountNumberController.text} for cooperative ID: $selectedCorporativeId");

      setState(() {
        selectedCorporativeId = "";
      });

      for(UserCorporativeModel userCorp in userBloc.user.userCorporatives ?? []) {
        if (accountNumberController.text.isNotEmpty) {
          debugPrint("Validating account ID: ${accountNumberController
              .text} for cooperative ID: $selectedCorporativeId 2");
          setState(() {
            isValidating = true;
          });
          final resp = await ApiFetcher.instance.accountDetails(
              phoneNumber: userBloc.user.phoneNumber ?? "",
              clientId: userCorp.corpId?.clientCode ?? "",
              accountId: accountNumberController.text);
          setState(() {
            isValidating = false;
          });

          if(resp['StatusCode']==true) {
            setState(() {
              isValidated =
              true; // Assume validation is successful for demonstration
              selectedCorporativeId = userCorp.corpId?.clientCode ?? "";
            });
          } else {
            informationDialogWithButton(context, "Failed", resp['StatusMessage'], BrandColors.danger, BrandColors.black, "OK", ()=>Navigator.pop(context), true);
          }
        }
      }
    }
  }

  Future<dynamic> getLoanList() async {
    // if(userBloc.loans.isNotEmpty){
    //   return userBloc.loans;
    // }
    final resp = await ApiFetcher.instance.getLoans(phoneNumber: userBloc.user.phoneNumber ?? "", clientCode: selectedCorporativeId, accountNumber: userBloc.selectedAccount.accountNumber ?? "");
    return resp;
  }

  Future<dynamic> transact(String type) async {
    // check which transaction type is selected and call the appropriate API endpoint
    // if(paymentMethod == ""){
    //   ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text("Please select a payment method"))
    //   );
    //   informationDialogWithButton(
    //       context, "Notice", "Please select a payment method to continue", BrandColors.pendingColor, BrandColors.grey, "Ok", ()=>Navigator.pop(context), true);
    //   return;
    // }
    String paymentNetwork = "";
    String network = selectedNetwork;
    if(paymentMethod == PaymentMethod.mobileMoney){
      paymentNetwork = "MOBILEMONEY";
    } else if(paymentMethod == PaymentMethod.bankTransfer){
      paymentNetwork = "BANK_TRANSFER";
    } else if(paymentMethod == PaymentMethod.cash){
      paymentNetwork = "CASH";
      network = "";
    }

    debugPrint("Selected payment method: $paymentMethod, network: $network, payment network: $paymentNetwork");

    if(userBloc.selectedAccount.accountNumber == null || userBloc.selectedAccount.accountNumber == "0000000" || userBloc.selectedAccount.accountNumber == ""){
      informationDialogWithButton(
          context, "Notice", "Please select an account number to continue.", BrandColors.pendingColor, BrandColors.grey, "Ok", ()=>Navigator.pop(context), true);
      return;
    }

    var source = paymentMethod == PaymentMethod.mobileMoney ? mobileMoneyNumberController.text : userBloc.selectedAccount.accountNumber ?? "0000000";

    if(transactionType == TransactionType.deposit){
      // call deposit API endpoint
      debugPrint("About to check with network:: $selectedNetwork");
      debugPrint("Sending account number as source for $transactionType transaction: ${userBloc.selectedAccount.accountNumber}");
      final resp = await ApiFetcher.instance.deposit(
        accountNumber: userBloc.selectedAccount.accountNumber ?? "0000000",
        amount: amountController.text,
        paymentNetwork: paymentNetwork,
        network: network,
        destination: userBloc.selectedAccount.accountNumber ?? "0000000",
        clientcode: selectedCorporativeId,
        source: source,
        phoneNumber: userBloc.user.phoneNumber ?? "",
        customerName: userBloc.selectedAccount.customerName ?? "",
        customerNumber: userBloc.selectedAccount.accountNumber ?? "",
        count: 3
      );

      return resp;
    } else if(transactionType == TransactionType.loan){
      // call loan API endpoint
      final resp = await ApiFetcher.instance.loanRepayment(
          customerName: userBloc.selectedAccount.customerName ?? "",
          customerNumber: userBloc.selectedAccount.accountNumber ?? "",
          accountNumber: userBloc.selectedAccount.accountNumber ?? "0000000",
          amount: amountController.text,
          sourceAccount: source,
          loanId: selectedLoanId,
          paymentNetwork: paymentNetwork,
          network: network,
          clientcode: selectedCorporativeId,
          phoneNumber: userBloc.user.phoneNumber ?? "0000000000",
          count: 3
      );

      return resp;
    }

    return true; // Assume transaction is successful for demonstration
  }

  void clearParams(){
    accountNumberController.clear();
    selectedProductController.clear();
    mobileMoneyNumberController.clear();
    amountController.clear();
    setState(() {
      selectedCorporativeId = "";
      selectedNetwork = "MTN_MOBILEMONEY";
      selectedLoanId = "";
      selectedCooperativeValue = null;
      isValidated = false;
      transactionType = TransactionType.deposit;
      paymentMethod = PaymentMethod.mobileMoney;
      userBloc.clearCustomerAccount();
    });
    userBloc.updateSelectedAccount(CustomerAccountModel());
  }

  @override
  Widget build(BuildContext context) {
    userBloc = Provider.of<UserBloc>(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: BrandValues.defaultVerticalScreenPadding, horizontal: BrandValues.defaultHorizontalScreenPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(BrandValues.buttonTRadius)),
        color: BrandColors.lightGrey,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // DropdownButtonFormField<String>(
          //   decoration: InputDecoration(
          //     labelText: "Select Cooperative",
          //     prefixIcon: const Icon(Icons.account_balance),
          //     fillColor: BrandColors.white,
          //     filled: true,
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(BrandValues.boxRadiusVal),
          //     ),
          //   ),
          //   items: userBloc.corporatives.map((CorporativeModel coop) {
          //     return DropdownMenuItem<String>(
          //       value: coop.clientCode.toString(),
          //       child: CustomText(text: coop.clientName ?? "", fontSize: BrandValues.defaultFontSize, textColor: BrandColors.grey),
          //     );
          //   }).toList(),
          //   onChanged: (String? value) {
          //     debugPrint("Selected cooperative ID: $value");
          //     setState(() {
          //       selectedCorporativeId = value ?? "";
          //       selectedCooperativeValue = value;
          //     });
          //   },
          // ),
          // SizedBox(height: BrandValues.defaultVerticalScreenPaddingSmall,),
          buildOutlineTextField(
            controller: accountNumberController,
            labelText: labelText,
            prefixIcon: prefixIcon,
            focusNode: accountIdFocusNode,
            keyboardType: TextInputType.number
          ),
          const SizedBox(height: BrandValues.defaultVerticalScreenPadding,),
          isValidating ? buildLoadingWidget() : isValidated == false ? CustomOutlineButton(
              text: "Validate",
              onPressed: (){
                accountIdFocusNode.unfocus();
                debugPrint("Validating account ID: ${accountNumberController.text} for cooperative ID: $selectedCorporativeId");
                validateAccountID(reset: false);
              }
          ) : Container(),
          isValidated ?
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: CustomText(text: "Accounts", fontSize: BrandValues.defaultFontSize, textColor: BrandColors.black, fontWeight: FontWeight.w600,),
              ),
              SizedBox(height: BrandValues.defaultVerticalScreenPaddingSmall,),
              for(CustomerAccountModel account in userBloc.customerAccounts) ...[
              InkWell(
                onTap: (){
                  setState(() {
                    userBloc.updateSelectedAccount(account);
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: account.accountNumber == userBloc.selectedAccount.accountNumber ? BrandColors.extraLightPrimaryColor : BrandColors.white,
                      borderRadius: BorderRadius.circular(BrandValues.boxRadiusVal),
                      border: Border.all(color: account.accountNumber == userBloc.selectedAccount.accountNumber ? BrandColors.secondPrimaryColor : BrandColors.grey, width: 0.5)
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: BrandValues.defaultHorizontalScreenPaddingSmall, vertical: BrandValues.defaultHorizontalScreenPaddingSmall),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          CustomText(
                              text: account.customerName ?? "",
                              fontSize: BrandValues.defaultFontSize,
                              textColor: BrandColors.black,
                            fontWeight: BrandValues.bodyTextFontWeight,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CustomText(
                            text: account.accountNumber ?? "",
                            fontSize: BrandValues.defaultFontSize,
                            textColor: BrandColors.black,
                            fontWeight: BrandValues.bodyTextFontWeightBold,
                          ),
                          Spacer(),
                          account.accountNumber == userBloc.selectedAccount.accountNumber ? Iconify(Ic.outline_check, color: BrandColors.successColor, size: BrandValues.defaultFontSize,) : Container()
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              ],
              const SizedBox(height: BrandValues.defaultVerticalScreenPadding,),
              RadioGroup<TransactionType>(
                groupValue: transactionType,
                onChanged: (TransactionType? value) {
                  setState(() {
                    transactionType = value;
                  });

                  debugPrint("Transaction type is ${transactionType.toString()}");

                  if(transactionType == TransactionType.loan){
                    setState(() {
                      loanList = getLoanList();
                    });
                  }
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Deposit'),
                        Radio<TransactionType>(value: TransactionType.deposit),
                      ]
                    ),
                    const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Loan'),
                          Radio<TransactionType>(value: TransactionType.loan),
                        ]
                    ),
                  ],
                ),
              ),
              transactionType == TransactionType.loan ? const SizedBox(height: BrandValues.defaultVerticalScreenPadding,) : Container(),
              transactionType == TransactionType.loan ? FutureBuilder(
                future: loanList,
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: buildLoadingWidget(),
                    );
                  }
                  debugPrint("Snapshot data is ${snapshot.data}");

                  if (snapshot.hasError) {
                    debugPrint("Error fetching data: ${snapshot.error}");
                    return Center(
                      child: BodyTextBlack(text: "An error occurred while fetching data"),
                    );
                  }

                  debugPrint("Snapshot has data: ${snapshot.hasData}, data is null: ${snapshot.data == null}");

                  if (!snapshot.hasData || snapshot.data == null) {
                    debugPrint("No data available");
                    return Center(
                      child: BodyTextBlack(text: "No data available"),
                    );
                  }

                  debugPrint("Data fetched successfully: ${snapshot.data}");

                  final data = snapshot.data;
                  final hasItems = data is List ? data.isNotEmpty : true;

                  if (!hasItems) {
                    return Center(
                      child: BodyTextBlack(text: "No records found"),
                    );
                  }

                  return DropdownButtonFormField<String>(
                    dropdownColor: BrandColors.white,
                    decoration: InputDecoration(
                      labelText: "Loan list",
                      prefixIcon: const Icon(Icons.account_balance),
                      fillColor: BrandColors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(BrandValues.boxRadiusVal),
                      ),
                      // contentPadding: EdgeInsets.symmetric(vertical: BrandValues.defaultVerticalScreenPadding)
                    ),
                    items: userBloc.loans.map((LoanModel loan) {
                      return DropdownMenuItem<String>(
                        value: loan.LoanId,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(text: loan.LoanType ?? "", fontSize: BrandValues.defaultFontSize, textColor: BrandColors.black),
                            CustomText(text: loan.LoanBalance ?? "", fontSize: BrandValues.defaultSmallFontSize, textColor: BrandColors.grey),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      debugPrint("Selected Loan ID: $value");
                      setState(() {
                        selectedLoanId = value ?? "";
                      });
                    },
                  );
                }
              ) : Container(),
              const SizedBox(height: BrandValues.defaultVerticalScreenPadding,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BodyHeading(text: "Payment method"),
                ],
              ),
              RadioGroup<PaymentMethod>(
                groupValue: paymentMethod,
                onChanged: (PaymentMethod? value) {
                  setState(() {
                    paymentMethod = value;
                  });
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Mobile Money'),
                          Radio<PaymentMethod>(value: PaymentMethod.mobileMoney),
                        ]
                    ),
                    const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Cash'),
                          Radio<PaymentMethod>(value: PaymentMethod.cash),
                        ]
                    ),
                  ],
                ),
              ),
              paymentMethod == PaymentMethod.mobileMoney ? SizedBox(height: BrandValues.defaultVerticalScreenPadding,) : Container(),
              paymentMethod == PaymentMethod.mobileMoney ? buildOutlineTextField(
                  controller: mobileMoneyNumberController,
                  // labelText: paymentMethod != PaymentMethod.mobileMoney && transactionType == TransactionType.loan ? "Phone number" : "Mobile money number",
                  labelText: paymentMethod == PaymentMethod.cash && transactionType == TransactionType.loan ? "Phone number" : "Mobile money number",
                  prefixIcon: Icons.numbers,
                  keyboardType: TextInputType.number
              ) : Container(),
              paymentMethod == PaymentMethod.mobileMoney ? SizedBox(height: BrandValues.defaultVerticalScreenPadding,) : Container(),
              paymentMethod == PaymentMethod.mobileMoney ?
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(text: "Select network", fontSize: BrandValues.defaultLargeFontSize, textColor: BrandColors.primaryColor),
                      const SizedBox(height: BrandValues.defaultVerticalScreenPaddingSmall,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          NetworkCircle(
                              text: "",
                              onTap: (){
                                setState(() {
                                  selectedNetwork = "MTN_MOBILEMONEY";
                                });
                              },
                              icon: AssetImage(Assets.mtnIcon),
                            isActive: selectedNetwork == "MTN_MOBILEMONEY",
                          ),
                          NetworkCircle(
                            text: "",
                            onTap: (){
                              setState(() {
                                selectedNetwork = "TELECEL_MOBILEMONEY";
                              });
                            },
                            icon: AssetImage(Assets.telecelIcon),
                            isActive: selectedNetwork == "TELECEL_MOBILEMONEY",
                          ),
                          NetworkCircle(
                            text: "",
                            onTap: (){
                              setState(() {
                                selectedNetwork = "AT_MOBILEMONEY";
                              });
                            },
                            icon: AssetImage(Assets.atIcon),
                            isActive: selectedNetwork == "AT_MOBILEMONEY",
                          )
                        ]
                      )
                    ],
                  )
                  : Container(),
              SizedBox(height: BrandValues.defaultVerticalScreenPadding,),
              buildOutlineTextField(
                  controller: amountController,
                  labelText: "Amount",
                  prefixIcon: Icons.numbers,
                keyboardType: TextInputType.number
              ),
              SizedBox(height: BrandValues.defaultVerticalScreenPaddingExtra,),
              isTransacting == true ? buildLoadingWidget() : CustomOutlineButton(
                text: "Save",
                onPressed: () async {
                  // Save data
                  debugPrint("Selected account number is ${userBloc.selectedAccount.accountNumber}");
                  if(userBloc.selectedAccount.accountNumber == null || userBloc.selectedAccount.accountNumber == "0000000" || userBloc.selectedAccount.accountNumber == ""){
                    informationDialogWithButton(
                        context, "Notice", "Please select an account number to continue.", BrandColors.pendingColor, BrandColors.grey, "Ok", ()=>Navigator.pop(context), true);
                    return;
                  }
                  if(paymentMethod == PaymentMethod.mobileMoney && mobileMoneyNumberController.text.isEmpty){
                    informationDialogWithButton(
                        context, "Notice", "Please enter mobile money number to continue", BrandColors.pendingColor, BrandColors.grey, "Ok", ()=>Navigator.pop(context), true);
                    return;
                  }
                  if(amountController.text.isEmpty){
                    informationDialogWithButton(
                        context, "Notice", "Please enter amount to continue", BrandColors.pendingColor, BrandColors.grey, "Ok", ()=>Navigator.pop(context), true);
                    return;
                  }
                  if(transactionType == TransactionType.loan && selectedLoanId.isEmpty){
                    informationDialogWithButton(
                        context, "Notice", "Please select a loan to continue", BrandColors.pendingColor, BrandColors.grey, "Ok", ()=>Navigator.pop(context), true);
                    return;
                  }
                  if(selectedCorporativeId.isEmpty){
                    informationDialogWithButton(
                        context, "Notice", "Invalid account ID. Please enter a valid account ID and validate to continue.", BrandColors.pendingColor, BrandColors.grey, "Ok", ()=>Navigator.pop(context), true);
                    return;
                  }
                  if(paymentMethod == PaymentMethod.cash && transactionType == TransactionType.deposit){
                    mobileMoneyNumberController.text = userBloc.selectedAccount.accountNumber ?? "0000000";
                  }
                  showLoading(context);
                  setState(() {
                    isTransacting = true;
                  });
                  var resp = await transact(transactionType.toString());
                  Navigator.pop(context);

                  setState(() {
                    isTransacting = false;
                  });

                  if(resp != null){
                    debugPrint("Deposit response: $resp");
                    if(resp["Success"] == true){

                      String message = transactionType == TransactionType.deposit ? "Deposit in progress. Please wait." : "Loan repayment in progress. Please wait.";

                      informationDialogWithButton(
                          context, "Success", message, paymentMethod == PaymentMethod.cash ? BrandColors.successColor : BrandColors.pendingColor, BrandColors.grey, "Ok", ()=>Navigator.pop(context), true);

                      // Get today's date at start of the day as from date and end of the day as to date
                      final now = DateTime.now();

                      // convert from date and to date to string in the format yyyy-MM-dd HH:mm:ss
                      String fromDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}T00:00:00.000Z";
                      String toDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}T23:59:59.000Z";
                      ApiFetcher.instance.agentTransactions(agentCode: "${userBloc.user.agentCode?.agentCode}", clientId: "", fromDate: fromDate, toDate: toDate);
                      for(var i = 0; i < 5; i++){
                        await Future.delayed(Duration(seconds: 5));
                        final statusResp = await ApiFetcher.instance.getTransactionStatus(phoneNumber: userBloc.user.phoneNumber ?? "", clientCode: selectedCorporativeId, transactionReference: userBloc.transactionResp.transactionId ?? "", count: i+1);
                        debugPrint("Deposit status response: $statusResp");
                        if(statusResp != null && statusResp["Success"] == true){
                          clearParams();
                          Navigator.pushNamedAndRemoveUntil(context, TransactionDetails.id, (route) => route.isFirst);
                          break;
                        } else {
                          if(i == 2){
                            informationDialogWithButton(
                                context, "Failed", statusResp["StatusMessage"], BrandColors.danger, BrandColors.grey, "Ok", ()=>Navigator.pop(context), true);
                          }
                        }
                      }
                    } else {
                      informationDialogWithButton(
                          context, "Failed", resp["Message"] ?? "Deposit failed. Please try again.", BrandColors.danger, BrandColors.grey, "Ok", ()=>Navigator.pop(context), true);
                    }
                  } else {
                    informationDialogWithButton(
                        context, "Failed", "Deposit failed. Please try again.", BrandColors.danger, BrandColors.grey, "Ok", ()=>Navigator.pop(context), true);
                  }
                },
              )
            ],
          ) : Container()
        ],
      ),
    );
  }
}
