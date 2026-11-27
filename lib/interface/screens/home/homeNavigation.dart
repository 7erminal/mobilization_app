import 'package:flutter/material.dart';
import 'package:mobilization_app/index.dart';
import 'package:provider/provider.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/uil.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';

class HomeNavigation extends StatefulWidget {
  const HomeNavigation({super.key});
  static const String id = "/home-navigation";

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  // bool isLoggedIn = false;
  String? corporationName;
  String? userPhoneNumber;

  Future<dynamic>? corporatives_;

  int _selectedIndex = 0;

  final List<Widget> _loggedInWidgets = const [
    FirstScreen(),
    ActivityPage()
  ];

  // Refresh
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<Null> refreshDetails() async {
    debugPrint("About to refresh details");
    if(!mounted)return;
    refreshKey.currentState?.show(atTop: false);
    getAgentTransactions();
    ApiServices.getCorporatives();

    // Close keyboard if open
    FocusManager.instance.primaryFocus?.unfocus();

    return null;
  }

  void getAgentTransactions() async {
    DateTime now = DateTime.now();
    String fromDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}T00:00:00.000Z";
    String toDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}T23:59:59.000Z";
    ApiFetcher.instance.agentTransactions(agentCode: userBloc.user.agentCode?.agentCode ?? "", clientId: "", fromDate: fromDate, toDate: toDate);
  }

  Future<void> _checkAuthAndInitialize() async {
    userBloc = Provider.of<UserBloc>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Check if user is logged in (from shared preferences, token, etc.)
    // await authProvider.checkAuthStatus();

    debugPrint("Is user authenticated? ${authProvider.isAuthenticated}");
    if (authProvider.isAuthenticated) {
      // Initialize inactivity timer
      debugPrint("User is authenticated");
      // authProvider.initInactivityTimer(context);

      // Navigate to home
      // Navigator.of(context).pushReplacementNamed(HomeNavigation.id);
    } else {
      // Navigate to login
      Navigator.of(context).pushReplacementNamed(LoginScreen.id);
    }
  }

  void _handleAutoLogout() {
    // userBloc = Provider.of<UserBloc>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    userBloc.logout();
    authProvider.logout(context);


    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out due to inactivity')),
    );
  }

  @override
  void initState() {
    super.initState();
    // Check authentication status and initialize
    corporatives_ = _getCorporatives();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusManager.instance.primaryFocus?.unfocus();
      _checkAuthAndInitialize();
    });
  }

  Future<dynamic> _getCorporatives() async {
    try {
      var response = [];
      showLoading(context);
      while(userBloc.corporatives.isEmpty){
        // showLoading(context);
        await ApiFetcher.instance.getCorporatives();
        // Navigator.pop(context);

        debugPrint("Response returned for get corporatives...");
      }
      Navigator.pop(context);

      return response;

    } catch(e){
      debugPrint("An error occurred in the api fetcher: $e");
      return null;
    }
  }



  @override
  Widget build(BuildContext context) {
    userBloc = Provider.of<UserBloc>(context);

    debugPrint("User's phone number in main navigation is ${userBloc.user.phoneNumber}");
    return RefreshIndicator(
      onRefresh: refreshDetails,
      color: BrandColors.primaryColor,
      child: Scaffold(
        appBar: AppBarC(),
          backgroundColor: BrandColors.white,
          body: _loggedInWidgets.elementAt(_selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Iconify(MaterialSymbols.add_home_work_outline, color: BrandColors.secondaryColor),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Iconify(Uil.transaction, color: BrandColors.secondaryColor,),
                label: 'Transactions',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: BrandColors.primaryColor,
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          )

      ),
    );
  }
}