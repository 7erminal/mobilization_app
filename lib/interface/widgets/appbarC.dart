import 'package:flutter/material.dart';
import 'package:mobilization_app/index.dart';

class AppBarC extends StatelessWidget implements PreferredSizeWidget {
  const AppBarC({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      actions: [Container(
        margin: const EdgeInsets.only(right: 20.0),
        child: InkWell(
          onTap: (){
            Navigator.pushNamed(context, Settings.id);
          },
          child: Image.asset(Assets.brandLogo, scale: 6,),
        )
      ),],
    );
  }
}