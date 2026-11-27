import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart'
;
class Functions{
  Functions._();

  // create a constructor for the class
  static final Functions _instance = Functions._();

  static Functions get instance => _instance;

  String getCountry(String countryCode){
    String country = countryCode;
    if(countryCode=="GH"){
      country = "Ghana";
    }

    return country;
  }

  String trimCountryCode(String countryCode){
    String countryCodePrefix = countryCode;
    countryCodePrefix = countryCode.substring(1);

    return countryCodePrefix;
  }

  /*
  * ###########################################
  * ##### convert the image to base64 #########
  * ###########################################
  * */
  static dynamic convertImageToBase64(File image) async {
    debugPrint("Converting image to base64");
    final bytes = await image.readAsBytes();
    final base64Image = base64Encode(bytes);
    return base64Image;
  }
}