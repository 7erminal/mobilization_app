import 'package:flutter/material.dart';
import 'package:mobilization_app/index.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/cil.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});
  static const String id = '/settings';

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBarC(),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: BrandValues.defaultVerticalScreenPaddingExtra, horizontal: BrandValues.defaultHorizontalScreenPadding),
            child: Column(
              children: [
                MenuListItem(
                  title: "Log out",
                  onTap: () {
                    authProvider.logout(context);
                    Navigator.pushReplacementNamed(context, LoginScreen.id);
                  },
                  subtext: "",
                  icon: Iconify(Cil.account_logout, color: BrandColors.black, size: 25),
                ),
                Divider(height: 1, color: BrandColors.grey,),
                MenuListItem(
                  title: "Delete account",
                  onTap: () {},
                  subtext: "",
                  icon: Iconify(Ic.sharp_delete_forever, color: BrandColors.black, size: 25),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

