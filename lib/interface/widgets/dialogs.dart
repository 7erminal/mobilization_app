import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobilization_app/index.dart';

void informationDialogWithButton(BuildContext context, String title, String description, Color? titleColor, Color? descriptionColor, String button1Text, Function navigator1_, bool? isDismisable) async
{
  final mediaQueryData = MediaQuery.of(context);

  final scale = mediaQueryData.textScaler.clamp(
    minScaleFactor: 1.0, // Minimum scale factor allowed.
    maxScaleFactor: 1.2, // Maximum scale factor allowed.
  );

  return showDialog(
      barrierDismissible: isDismisable ?? true,
      useRootNavigator: false,
      context: context,
      builder: (context) => GestureDetector(
        // behavior: HitTestBehavior.opaque,
        onTap: () async {
          debugPrint("Screen has been touched 2");
        },
        onHorizontalDragEnd: (details) async {
          debugPrint("Screen drag 0");
        },
        onVerticalDragEnd: (details) async {
          debugPrint("Screen drag 1");
        },
        child: MediaQuery(
          data: mediaQueryData.copyWith(
            textScaler: scale,
          ),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: CustomText(
              text: title,
              textColor: titleColor ?? BrandColors.black,
              fontWeight: FontWeight.w700,
              fontSize: BrandValues.defaultLargeFontSize,
              textAlign: TextAlign.center,
            ),
            content: CustomText(
              text: description,
              fontSize: BrandValues.defaultFontSize,
              textAlign: TextAlign.center,
              textColor: descriptionColor ?? BrandColors.black,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    CustomOutlineButton(
                      textColor: descriptionColor ?? BrandColors.black,
                      text: button1Text,
                      onPressed: () {
                        // if(userBloc.isData==true) {
                        //   systemBloc.startTimer(context);
                        // }
                        debugPrint("Pop this");
                        navigator1_();
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ));
}

void informationDialogWithButtons(BuildContext context, String title, String description, Color? titleColor, Color? descriptionColor, String button1Text, String button2Text, Function navigator1_, Function navigator2_) async
{
  final mediaQueryData = MediaQuery.of(context);

  final scale = mediaQueryData.textScaler.clamp(
    minScaleFactor: 1.0, // Minimum scale factor allowed.
    maxScaleFactor: 1.2, // Maximum scale factor allowed.
  );

  return showDialog(
      barrierDismissible: true,
      useRootNavigator: false,
      context: context,
      builder: (context) => GestureDetector(
        // behavior: HitTestBehavior.opaque,
        onTap: () async {
          debugPrint("Screen has been touched 2");
        },
        onHorizontalDragEnd: (details) async {
          debugPrint("Screen drag 0");
        },
        onVerticalDragEnd: (details) async {
          debugPrint("Screen drag 1");
        },
        child: MediaQuery(
          data: mediaQueryData.copyWith(
            textScaler: scale,
          ),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: CustomText(
              text: title,
              textColor: titleColor ?? BrandColors.black,
              fontWeight: FontWeight.w700,
              fontSize: BrandValues.defaultLargeFontSize,
              textAlign: TextAlign.center,
            ),
            content: CustomText(
              text: description,
              fontSize: BrandValues.defaultSmallFontSize,
              textAlign: TextAlign.center,
              textColor: descriptionColor ?? BrandColors.black,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    CustomOutlineButton(
                      textColor: descriptionColor ?? BrandColors.black,
                      text: button1Text,
                      onPressed: () {
                        // if(userBloc.isData==true) {
                        //   systemBloc.startTimer(context);
                        // }
                        navigator1_();
                      },
                    ),
                    const Spacer(),
                    CustomOutlineButton(
                      textColor: BrandColors.dangerLight,
                      text: button2Text,
                      onPressed: () {
                        /*
                * ##############################################################################
                * ############# pop pop again to exit the app  #################################
                * ##############################################################################
                * */
                        // pop pop again to exit the app
                        // if(userBloc.isData==true) {
                        //   systemBloc.startTimer(context);
                        // }
                        navigator2_();
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ));
}

void informationDialogWithButtonWidgetContent(BuildContext context, String title, Widget content, Color? titleColor, String button2Text, Function navigator2_) async
{
  final mediaQueryData = MediaQuery.of(context);

  final scale = mediaQueryData.textScaler.clamp(
    minScaleFactor: 1.0, // Minimum scale factor allowed.
    maxScaleFactor: 1.2, // Maximum scale factor allowed.
  );

  // userBloc = Provider.of<UserBloc>(context);

  return showDialog(
      barrierDismissible: true,
      useRootNavigator: false,
      context: context,
      builder: (context) => GestureDetector(
        // behavior: HitTestBehavior.opaque,
        onTap: () async {
          debugPrint("Screen has been touched 2");
        },
        onHorizontalDragEnd: (details) async {
          debugPrint("Screen drag 0");
        },
        onVerticalDragEnd: (details) async {
          debugPrint("Screen drag 1");
        },
        child: MediaQuery(
          data: mediaQueryData.copyWith(
            textScaler: scale,
          ),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: CustomText(
              text: title,
              textColor: titleColor ?? BrandColors.black,
              fontWeight: FontWeight.w700,
              fontSize: BrandValues.defaultLargeFontSize,
              textAlign: TextAlign.center,
            ),
            content: content,
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    // CustomOutlineButton(
                    //   textColor: BrandColors.white,
                    //   text: button1Text,
                    //   onPressed: () {
                    //     // if(userBloc.isData==true) {
                    //     //   systemBloc.startTimer(context);
                    //     // }
                    //     navigator1_();
                    //   },
                    // ),
                    const Spacer(),
                    CustomOutlineButton(
                      textColor: BrandColors.black,
                      text: button2Text,
                      onPressed: () {
                        /*
                * ##############################################################################
                * ############# pop pop again to exit the app  #################################
                * ##############################################################################
                * */
                        // pop pop again to exit the app
                        // if(userBloc.isData==true) {
                        //   systemBloc.startTimer(context);
                        // }
                        navigator2_();
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ));
}

void informationDialogWithButtonsWidgetContent(BuildContext context, String title, Widget content, Color? titleColor, String button1Text, String button2Text, Function navigator1_, Function navigator2_) async
{
  final mediaQueryData = MediaQuery.of(context);

  final scale = mediaQueryData.textScaler.clamp(
    minScaleFactor: 1.0, // Minimum scale factor allowed.
    maxScaleFactor: 1.2, // Maximum scale factor allowed.
  );

  // userBloc = Provider.of<UserBloc>(context);

  return showDialog(
      barrierDismissible: true,
      useRootNavigator: false,
      context: context,
      builder: (BuildContext context) => GestureDetector(
        // behavior: HitTestBehavior.opaque,
        onTap: () async {
          debugPrint("Screen has been touched 2");
        },
        onHorizontalDragEnd: (details) async {
          debugPrint("Screen drag 0");
        },
        onVerticalDragEnd: (details) async {
          debugPrint("Screen drag 1");
        },
        child: MediaQuery(
          data: mediaQueryData.copyWith(
            textScaler: scale,
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setDialogState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: CustomText(
                  text: title,
                  textColor: titleColor ?? BrandColors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: BrandValues.defaultLargeFontSize,
                  textAlign: TextAlign.center,
                ),
                content: content,
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        CustomOutlineButton(
                          textColor: BrandColors.black,
                          text: button1Text,
                          onPressed: () {
                            // if(userBloc.isData==true) {
                            //   systemBloc.startTimer(context);
                            // }
                            navigator1_();
                          },
                        ),
                        const Spacer(),
                        CustomOutlineButton(
                          textColor: BrandColors.dangerLight,
                          text: button2Text,
                          onPressed: () {
                            /*
                    * ##############################################################################
                    * ############# pop pop again to exit the app  #################################
                    * ##############################################################################
                    * */
                            // pop pop again to exit the app
                            // if(userBloc.isData==true) {
                            //   systemBloc.startTimer(context);
                            // }
                            navigator2_();
                          },
                        )
                      ],
                    ),
                  ),
                ],
              );
            }
          ),
        ),
      )
  );
}

void _showInactivityWarning(BuildContext context) {
  InactivityService? _inactivityService;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text('Session Timeout'),
      content: const Text('You will be logged out in 60 seconds due to inactivity'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            _inactivityService!.resetTimer();
          },
          child: const Text('Stay Logged In'),
        ),
      ],
    ),
  );
}

