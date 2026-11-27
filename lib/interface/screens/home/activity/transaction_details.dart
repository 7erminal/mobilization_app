import 'package:flutter/material.dart';
import 'package:mobilization_app/index.dart';
import 'package:provider/provider.dart';

class TransactionDetails extends StatefulWidget {
  const TransactionDetails({super.key});
  static const String id = "/transaction-details";

  @override
  State<TransactionDetails> createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {
  bool _isPolling = true;
  final PrinterService _printer = PrinterService();
  bool _isPrinting = false;

  @override
  void initState() {
    super.initState();
    // _printer.initPrinter();
    getTransactionDetails();
  }

  @override
  dispose() {
    _isPolling = false;
    super.dispose();
  }

  Future<void> _handlePayAndPrint() async {
    setState(() => _isPrinting = true);
    try {
      debugPrint("Attempting to print receipt with details: ${userBloc.transactionDetails}");
      debugPrint("Amount type: ${userBloc.transactionDetails.amount.runtimeType}, value: ${userBloc.transactionDetails.amount}");
      final double amount = userBloc.transactionDetails.amount is num
          ? (userBloc.transactionDetails.amount as num).toDouble()
          : double.tryParse('${userBloc.transactionDetails.amount}') ?? 0.0;

      // final bool ready = await _printer.isPrinterReady();
      // if (!ready) throw Exception('Printer not ready');
      String clientName = userBloc.user.userCorporatives != null && userBloc.user.userCorporatives!.isNotEmpty
          ? userBloc.user.userCorporatives![0].corpId?.clientName ?? "Unknown Client"
          : "Unknown Client";

      for(CorporativeModel corp in userBloc.corporatives ?? []) {
        debugPrint("Corporative: ${corp.clientName}");
        if(corp.id == userBloc.transactionDetails.corpId) {
          debugPrint("Found matching corporative: ${corp.clientName}");
          clientName = corp.clientName ?? clientName;
          break;
        }
      }

      await _printer.printReceipt({
        'clientName': clientName,
        'clientAddress': '${userBloc.user.agentCode?.location}, ${userBloc.user.agentCode?.country}',
        'clientNumber': '${userBloc.user.agentCode?.phoneNumber}',
        'transactionId': '${userBloc.transactionDetails.transactionRefNumber}',
        'customerName': '${userBloc.transactionDetails.customerName}',
        'customerNumber': '${userBloc.transactionDetails.customerNumber}',
        'customerAccount': '${userBloc.transactionDetails.sourceAccount}',
        'date': '${userBloc.transactionDetails.date}',
        'items': [
          {'name': '${userBloc.transactionDetails.service}', 'amount': amount},
        ],
        'paymentMethod': '${userBloc.transactionDetails.paymentMethod}',
        'status': '${userBloc.transactionDetails.status}',
        'total': amount,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Receipt printed successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Print failed: $e')),
        );
      }
    } finally {
      setState(() => _isPrinting = false);
    }
  }

  Future<void> getTransactionDetails() async {
    while (
        mounted &&
        _isPolling &&
        userBloc.transactionDetails.status == "PENDING") {
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted || !_isPolling) {
        break;
      }
      await ApiFetcher.instance.getTransactionStatus(
          phoneNumber: userBloc.user.phoneNumber ?? "",
          clientCode: "",
          transactionReference: userBloc.transactionDetails.transactionRefNumber ?? "",
          count: 3
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    userBloc = Provider.of<UserBloc>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: width,
        height: height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(BrandValues.boxRadiusVal),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: BrandColors.grey,
                                spreadRadius: 5,
                                blurRadius: 5,
                                offset: const Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                            child: Image.asset(Assets.brandLogo, scale: 3))),
                  ],
                ),
                SizedBox(height: BrandValues.defaultVerticalScreenPadding,),
                BodyTextBlack(text: "Transaction Details", fontWeight: FontWeight.bold,),
                SizedBox(height: BrandValues.defaultVerticalScreenPadding,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BodyTextBlack(text: "Transaction ID", fontWeight: FontWeight.bold,),
                    BodyTextBlack(text: userBloc.transactionDetails.transactionRefNumber ?? ""),
                  ],
                ),
                SizedBox(height: BrandValues.defaultHorizontalScreenPaddingSmall,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BodyTextBlack(text: "Service", fontWeight: FontWeight.bold,),
                    BodyTextBlack(text: userBloc.transactionDetails.service ?? ""),
                  ],
                ),
                SizedBox(height: BrandValues.defaultVerticalScreenPaddingSmall,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BodyTextBlack(text: "Amount", fontWeight: FontWeight.bold,),
                    BodyTextBlack(text: "GHS ${userBloc.transactionDetails.amount}"),
                  ],
                ),
                SizedBox(height: BrandValues.defaultVerticalScreenPaddingSmall,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BodyTextBlack(text: "Customer Name", fontWeight: FontWeight.bold,),
                    BodyTextBlack(text: userBloc.transactionDetails.customerName ?? ""),
                  ],
                ),
                SizedBox(height: BrandValues.defaultVerticalScreenPaddingSmall,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BodyTextBlack(text: "Customer Number", fontWeight: FontWeight.bold,),
                    BodyTextBlack(text: userBloc.transactionDetails.customerNumber ?? ""),
                  ],
                ),
                SizedBox(height: BrandValues.defaultVerticalScreenPaddingSmall,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BodyTextBlack(text: "Source Account", fontWeight: FontWeight.bold,),
                    BodyTextBlack(text: userBloc.transactionDetails.sourceAccount ?? ""),
                  ],
                ),
                SizedBox(height: BrandValues.defaultVerticalScreenPaddingSmall,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BodyTextBlack(text: "Destination Account", fontWeight: FontWeight.bold,),
                    BodyTextBlack(text: userBloc.transactionDetails.destinationAccount ?? ""),
                  ],
                ),
                SizedBox(height: BrandValues.defaultVerticalScreenPaddingSmall,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BodyTextBlack(text: "Payment Method", fontWeight: FontWeight.bold,),
                    BodyTextBlack(text: userBloc.transactionDetails.paymentMethod ?? ""),
                  ],
                ),
                SizedBox(height: BrandValues.defaultVerticalScreenPaddingSmall,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BodyTextBlack(text: "Transaction Date", fontWeight: FontWeight.bold,),
                    BodyTextBlack(text: userBloc.transactionDetails.date ?? ""),
                  ],
                ),
                SizedBox(height: BrandValues.defaultVerticalScreenPaddingSmall,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BodyTextBlack(text: "Transaction By", fontWeight: FontWeight.bold,),
                    BodyTextBlack(text: "${userBloc.transactionDetails.officerName} (${userBloc.transactionDetails.officerNumber})"),
                  ],
                ),
                SizedBox(height: BrandValues.defaultVerticalScreenPaddingSmall,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BodyTextBlack(text: "Transaction Status", fontWeight: FontWeight.bold,),
                    BodyTextBlack(text: "${userBloc.transactionDetails.status}"),
                  ],
                ),
                SizedBox(height: BrandValues.defaultVerticalScreenPadding,),
                CustomButton(
                    text: "Print",
                    onPressed: (){
                      debugPrint("Print Transaction Details");
                      _handlePayAndPrint();
                    }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
