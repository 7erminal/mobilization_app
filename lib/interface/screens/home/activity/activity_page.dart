import 'package:flutter/material.dart';
import 'package:mobilization_app/index.dart';
import 'package:provider/provider.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  bool loading = true;
  Future<dynamic>? _getActivityResut;

  Future<bool> getActivity() async {
    DateTime now = DateTime.now();
    String fromDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}T00:00:00.000Z";
    String toDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}T23:59:59.000Z";
    await ApiFetcher.instance.agentTransactions(agentCode: userBloc.user.agentCode?.agentCode ?? "", clientId: userBloc.user.agentCode?.agentCode ?? "", fromDate: fromDate, toDate: toDate);
    return true;
  }

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    _getActivityResut = getActivity();
  }

  @override
  Widget build(BuildContext context) {
    userBloc = Provider.of<UserBloc>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            BodyHeading(text: "Activity"),
            SizedBox(height: BrandValues.defaultVerticalScreenPadding),
            FutureBuilder<dynamic>(
              future: _getActivityResut, // a previously-obtained Future<String> or null
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                List<Widget> children;
                if (snapshot.hasData) {
                  children = <Widget>[
                    for(AgentTransactionModel activity in userBloc.agentTransactions)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            onTap: () async {
                              showLoading(context);
                              final statusResp = await ApiFetcher.instance.getTransactionStatus(
                                  phoneNumber: userBloc.user.phoneNumber ?? "",
                                  clientCode: "",
                                  transactionReference: activity.transactionRefNumber ?? "",
                                  count: 3
                              );
                              Navigator.pop(context);
                              if(statusResp != null && statusResp["Success"] == true) {
                                Navigator.pushNamed(context, TransactionDetails.id);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to fetch transaction details")));
                              }
                            },
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(Assets.brandLogo),
                            ),
                            title: CustomText(text: "${activity.service}", fontSize: BrandValues.defaultFontSize, textColor: BrandColors.black,),
                            subtitle: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(text: "${activity.paymentMethod}", fontSize: BrandValues.defaultSmallFontSize, textColor: BrandColors.grey,),
                                CustomText(text: "GHS${activity.amount}", fontSize: BrandValues.defaultFontSize, textColor: BrandColors.black,),
                              ],
                            ),
                            trailing: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomText(text: activity.status ?? "", fontSize: BrandValues.defaultFontSize, textColor: BrandColors.black,),
                                CustomText(text: activity.date ?? "", fontSize: BrandValues.defaultSmallFontSize, textColor: BrandColors.black,),
                              ],
                            ),
                          ),
                          const Divider()
                        ],
                      )
                  ];
                } else if (snapshot.hasError) {
                  children = <Widget>[
                    const Icon(Icons.error_outline, color: Colors.red, size: 60),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Error: ${snapshot.error}'),
                    ),
                  ];
                } else {
                  children = const <Widget>[
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Awaiting result...'),
                    ),
                  ];
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: children,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}