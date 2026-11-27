import 'package:flutter/material.dart';
import 'package:mobilization_app/index.dart';

class MenuListItem extends StatelessWidget {
  Function? onTap;
  String? title;
  String? subtext;
  Widget? icon;
  MenuListItem({
    super.key,
      this.onTap,
      this.title,
      this.subtext,
      this.icon
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(onTap != null){
          onTap!();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: BrandValues.defaultHorizontalScreenPadding, vertical: BrandValues.defaultVerticalScreenPadding),
        child: Row(
          children: [
            icon ?? Container(),
            SizedBox(width: BrandValues.defaultHorizontalScreenPaddingSmall,),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: title ?? "", fontSize: BrandValues.defaultFontSize, textColor: BrandColors.black,),
                subtext == "" ? Container() : CustomText(text: subtext ?? "", fontSize: BrandValues.defaultSmallFontSize, textColor: BrandColors.grey,),
              ],
            )
          ],
        ),
      ),
     );
  }
}
