import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mobilization_app/index.dart';
import 'package:provider/provider.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  Future<dynamic>? corperatives;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  Future<dynamic> getCorperatives() async {
    if(userBloc.corporatives.isNotEmpty){
      return userBloc.corporatives;
    }
    final resp = await ApiFetcher.instance.getCorporatives();
    return resp;
  }

  void calculateTotalAmount() {
    double total = 0.0;
    for (var transaction in userBloc.agentTransactions) {
      total += double.tryParse(transaction.amount.toString()) ?? 0.0;
    }
    userBloc.totalAmount = total.toStringAsFixed(2);
  }

  @override
  void initState() {
    super.initState();
    corperatives = getCorperatives();

    userBloc.loadCachedTransactions().then((_) => userBloc.resendCachedTransactions());

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (!results.contains(ConnectivityResult.none)) {
        userBloc.resendCachedTransactions();
      }
    }, onError: (Object error) {
      debugPrint("Connectivity stream error: $error");
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    userBloc = Provider.of<UserBloc>(context);

    debugPrint("User is ${userBloc.user}");
    debugPrint("Phone number is ${userBloc.user.phoneNumber}");
    debugPrint("Value of persie is ${userBloc.persie}");

    return Scaffold(
      backgroundColor: BrandColors.white,
      body: Container(
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(vertical: BrandValues.defaultVerticalScreenPadding, horizontal: BrandValues.defaultHorizontalScreenPadding),
        // color: BrandColors.black,
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: BrandValues.defaultVerticalScreenPaddingSmall,),
            Divider(color: BrandColors.secondaryColorLight,),
            const SizedBox(height: BrandValues.defaultVerticalScreenPadding,),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BodyTextBlack(text: userBloc.user.phoneNumber ?? ""),
                    LargeHeading(text: userBloc.user.phoneNumber ?? "", fontWeight: BrandValues.bodyHeadingFontWeightBold),
                    MediumLargeHeading(text: userBloc.user.agentCode?.branchName ?? "", color: BrandColors.grey,),
                    BodyTextGrey(
                      text: "${DateTime.now().toLocal().year}/${DateTime.now().toLocal().month.toString().length < 2 ? "0${DateTime.now().toLocal().month}" : DateTime.now().toLocal().month}/${DateTime.now().toLocal().day.toString().length < 2 ? "0${DateTime.now().toLocal().day}" : DateTime.now().toLocal().day} ${DateTime.now().toLocal().hour.toString().length < 2 ? "0${DateTime.now().toLocal().hour}" : DateTime.now().toLocal().hour}:${DateTime.now().toLocal().minute.toString().length < 2 ? "0${DateTime.now().toLocal().minute}" : DateTime.now().toLocal().minute}",
                      fontWeight: BrandValues.bodyHeadingFontWeight,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: BrandValues.defaultVerticalScreenPaddingExtra,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BodyTextBlack(text: "Cash", fontWeight: BrandValues.bodyHeadingFontWeightBold,),
                Spacer(),
                BodyTextBlack(text: "Momo", fontWeight: BrandValues.bodyHeadingFontWeight,),
              ],
            ),
            const SizedBox(height: BrandValues.defaultVerticalScreenPadding,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 0,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BodyTextGrey(text: "Online: ", fontWeight: BrandValues.bodyTextFontWeightThin),
                        SizedBox(width: BrandValues.defaultHorizontalScreenPaddingSmall,),
                        BodyHeading(text: userBloc.cashAmount, fontWeight: BrandValues.bodyTextFontWeight,),
                      ],
                    ),
                    Transform.translate(
                      offset: const Offset(0, -10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          BodyTextGrey(text: "Offline: ", fontWeight: BrandValues.bodyTextFontWeightThin,),
                          SizedBox(width: BrandValues.defaultHorizontalScreenPaddingSmall,),
                          BodyHeading(text: userBloc.totalCachedAmount, color: BrandColors.grey, fontWeight: BrandValues.bodyTextFontWeightThin,),
                        ],
                      ),
                    )
                  ],
                ),
                const Spacer(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BodyTextBlack(text: userBloc.momoAmount),
                  ],
                ),
              ],
            ),
            const SizedBox(height: BrandValues.defaultVerticalScreenPadding,),
            Divider(color: BrandColors.secondaryColorLight,),
            const SizedBox(height: BrandValues.defaultVerticalScreenPadding,),
            FutureBuilder<dynamic>(
                future: corperatives,
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  debugPrint("Connection state is ${snapshot.connectionState}");

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

                  return TransactionWidget();
              },
            ),
          ],
        ),
      ),
    );
  }
}
