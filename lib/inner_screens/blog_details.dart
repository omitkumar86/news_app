import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/services/global_methods.dart';
import 'package:news_app/widgets/vertical_spacing.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../consts/styles.dart';
import '../services/utils.dart';
import '../widgets/no_internet_connection_widget.dart';

class NewsDetailsScreen extends StatefulWidget {
  static const routeName = "/NewsDetailsScreen";

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final color = Utils(context).getColor;
    final publishedAt = ModalRoute.of(context)!.settings.arguments as String;
    final newsProvider = Provider.of<NewsProvider>(context);
    final currentNews = newsProvider.findByDate(publishAt: publishedAt);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: color),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Text(
          "${currentNews.source!.name}",
          textAlign: TextAlign.center,
          style: TextStyle(color: color),
        ),
        // leading: IconButton(
        //   icon: Icon(
        //     IconlyLight.arrowLeft,
        //     color: color,
        //   ),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
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
          : ListView(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${currentNews.title}",
                        textAlign: TextAlign.justify,
                        style: titleTextStyle,
                      ),
                      const VerticalSpacing(25),
                      Row(
                        children: [
                          Text(
                            "${currentNews.dateToShow}",
                            style: smallTextStyle,
                          ),
                          const Spacer(),
                          Text(
                            "${currentNews.readingTimeText}",
                            style: smallTextStyle,
                          ),
                        ],
                      ),
                      const VerticalSpacing(20),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: Hero(
                          tag: "${currentNews.publishedAt}",
                          child: FancyShimmerImage(
                            boxFit: BoxFit.fill,
                            errorWidget:
                                Image.asset('assets/images/empty_image.png'),
                            imageUrl: "${currentNews.urlToImage}",
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 10,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                try {
                                  await Share.share('${currentNews.url}',
                                      subject: 'Look what I made!');
                                } catch (err) {
                                  GlobalMethods.errorDialog(
                                      errorMessage: err.toString(),
                                      context: context);
                                }
                              },
                              child: Card(
                                elevation: 10,
                                shape: const CircleBorder(),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    IconlyLight.send,
                                    size: 28,
                                    color: color,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Card(
                                elevation: 10,
                                shape: const CircleBorder(),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    IconlyLight.bookmark,
                                    size: 28,
                                    color: color,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const VerticalSpacing(20),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextContent(
                        label: 'Description',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      const VerticalSpacing(10),
                      TextContent(
                        label: "${currentNews.description}",
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                      const VerticalSpacing(
                        20,
                      ),
                      const TextContent(
                        label: 'Contents',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      const VerticalSpacing(
                        10,
                      ),
                      TextContent(
                        label: "${currentNews.content}",
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class TextContent extends StatelessWidget {
  const TextContent({
    Key? key,
    required this.label,
    required this.fontSize,
    required this.fontWeight,
  }) : super(key: key);

  final String label;
  final double fontSize;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      label,
      textAlign: TextAlign.justify,
      style: GoogleFonts.roboto(fontSize: fontSize, fontWeight: fontWeight),
    );
  }
}
