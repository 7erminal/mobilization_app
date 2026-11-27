import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobilization_app/index.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authProvider),
        ChangeNotifierProvider(create: (_) => userBloc)
        // ChangeNotifierProvider(create: (_) => AccountsBloc()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: BrandValues.appName.toString(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: BrandColors.primaryColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: BrandColors.secondaryColor,
          primary: BrandColors.primaryColor,
        ),
      ),
      // darkTheme: BrandTheme.darkThemeData,
      // themeMode: ThemeMode.light,
      /*
                * ##################################################################
                * ################ IF THERE IS A USER LOGGED IN ####################
                * ##################################################################
                * */
      // home: LoginScreen(),
      /*
                * ##########################################################
                * ################### NAMED ROUTES #########################
                * ##########################################################
                * */
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        HomeNavigation.id: (context) => const HomeNavigation(),
        Register.id: (context) => const Register(),
        Settings.id: (context) => const Settings(),
        TransactionDetails.id: (context) => const TransactionDetails(),
      },
    );
  }
}
