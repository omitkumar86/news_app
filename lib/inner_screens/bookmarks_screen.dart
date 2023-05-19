import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:news_app/widgets/empty_screen.dart';
import 'package:provider/provider.dart';
import '../consts/styles.dart';
import '../services/utils.dart';
import '../widgets/no_internet_connection_widget.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).getColor;
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: color),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: true,
          title: Text(
            'Bookmarks',
            style: GoogleFonts.lobster(
                textStyle:
                    TextStyle(color: color, fontSize: 20, letterSpacing: 0.6)),
          ),
        ),
        body: Provider.of<InternetConnectionStatus>(context) ==
                InternetConnectionStatus.disconnected
            ? NoInternetConnectionWidget(onPressed: () {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("No internet connection!",
                      style:
                          myStyleMontserrat(15, Colors.white, FontWeight.w500)),
                  backgroundColor: Colors.red,
                ));
              })
            : EmptyNewsWidget(
                text: 'You didn\'t add anything yet to your bookmarks',
                imagePath: "assets/images/bookmark.png",
              )
        // ListView.builder(
        //     itemCount: 20,
        //     itemBuilder: (ctx, index) {
        //       return const ArticlesWidget();
        //     }),
        );
  }
}
