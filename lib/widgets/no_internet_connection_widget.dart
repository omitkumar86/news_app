
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:news_app/consts/styles.dart';

class NoInternetConnectionWidget extends StatelessWidget {
  dynamic onPressed;
  NoInternetConnectionWidget({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            child: Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
                height: 120,
                width: 120,
                "assets/lottie/no_internet.json",
                fit: BoxFit.cover),
            SizedBox(
              height: 45,
            ),
            Text("No internet!", style: myStyleMontserrat(15, Colors.red, FontWeight.w600)),
            SizedBox(
              height: 5,
            ),
            Text("Please Check your internet connection", style: myStyleMontserrat(15, Theme.of(context).secondaryHeaderColor, FontWeight.w500)),
            SizedBox(
              height: 15,
            ),
            MaterialButton(
              onPressed: onPressed,
              minWidth: 150,
              color: Colors.deepOrange,
              //color: Theme.of(context).primaryColor,
              child: Text(
                "Try Again",
                style: myStyleMontserrat(16, Colors.white, FontWeight.w600),
              ),
            )
          ],
        ),
      ],
    )));
  }
}
