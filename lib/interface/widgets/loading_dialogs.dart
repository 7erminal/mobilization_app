import 'package:flutter/material.dart';
import 'package:mobilization_app/index.dart';

showLoading(BuildContext context){
  showDialog(
    barrierDismissible: false,
      context: context,
      builder: (context) => Center(
        child: Container(
          width: BrandValues.defaultLoadingContainerSize,
          height: BrandValues.defaultLoadingContainerSize,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(BrandValues.boxRadiusVal)
          ),
          child: const Padding(
            padding: EdgeInsets.all(BrandValues.modalRadiusVal),
            child: CircularProgressIndicator(
              strokeWidth: BrandValues.loadStrokeWidth,
              valueColor: AlwaysStoppedAnimation<Color>(BrandColors.primaryColor),
            ),
          ),
        ),
      )
  );
}

Widget buildLoadingWidget(){
  return const Center(
    child: CircularProgressIndicator(
      strokeWidth: BrandValues.loadStrokeWidth,
      valueColor: AlwaysStoppedAnimation<Color>(BrandColors.primaryColor),
    ),
  );
}