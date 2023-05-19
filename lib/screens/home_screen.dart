import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:news_app/consts/vars.dart';
import 'package:news_app/inner_screens/search_screen.dart';
import 'package:news_app/model/news_model.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/services/utils.dart';
import 'package:news_app/widgets/drawer_widget.dart';
import 'package:news_app/widgets/empty_screen.dart';
import 'package:news_app/widgets/top_tending.dart';
import 'package:news_app/widgets/vertical_spacing.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../consts/styles.dart';
import '../widgets/articles_widget.dart';
import '../widgets/no_internet_connection_widget.dart';
import '../widgets/tabs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var newsType = NewsType.allNews;
  int currentPageIndex = 0;
  String sortBy = SortByEnum.publishedAt.name;

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).getColor;
    final newsProvider = Provider.of<NewsProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: color),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: true,
          title: Text(
            'News app',
            style: GoogleFonts.lobster(
                textStyle:
                    TextStyle(color: color, fontSize: 20, letterSpacing: 0.6)),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: const SearchScreen(),
                      inheritTheme: true,
                      ctx: context),
                );
              },
              icon: const Icon(
                IconlyLight.search,
              ),
            )
          ],
        ),
        drawer: const DrawerWidget(),
        body: Provider.of<InternetConnectionStatus>(context) ==
            InternetConnectionStatus.disconnected ?
        NoInternetConnectionWidget(
            onPressed: (){
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("No internet connection!", style: myStyleMontserrat(15, Colors.white, FontWeight.w500)),
                backgroundColor: Colors.red,
              ));
            }
        ):SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Row(
                children: [
                  TabsWidget(
                    text: 'All news',
                    color: newsType == NewsType.allNews
                        ? Theme.of(context).cardColor
                        : Colors.transparent,
                    function: () {
                      if (newsType == NewsType.allNews) {
                        return;
                      }
                      setState(() {
                        newsType = NewsType.allNews;
                      });
                    },
                    fontSize: newsType == NewsType.allNews ? 22 : 14,
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  TabsWidget(
                    text: 'Top trending',
                    color: newsType == NewsType.topTrending
                        ? Theme.of(context).cardColor
                        : Colors.transparent,
                    function: () {
                      if (newsType == NewsType.topTrending) {
                        return;
                      }
                      setState(() {
                        newsType = NewsType.topTrending;
                      });
                    },
                    fontSize: newsType == NewsType.topTrending ? 22 : 14,
                  ),
                ],
              ),
              const VerticalSpacing(10),
              newsType == NewsType.topTrending
                  ? Container()
                  : SizedBox(
                      height: kBottomNavigationBarHeight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          paginationButtons(
                            text: "Prev",
                            function: () {
                              if (currentPageIndex == 0) {
                                return;
                              }
                              setState(() {
                                currentPageIndex -= 1;
                              });
                            },
                          ),
                          Flexible(
                            flex: 2,
                            child: ListView.builder(
                                itemCount: 5,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: ((context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Material(
                                      color: currentPageIndex == index
                                          ? Colors.blue
                                          : Theme.of(context).cardColor,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            currentPageIndex = index;
                                            print(
                                                "dddddddddddddddd$index $currentPageIndex");
                                          });
                                        },
                                        child: Center(
                                            child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("${index + 1}"),
                                        )),
                                      ),
                                    ),
                                  );
                                })),
                          ),
                          paginationButtons(
                            text: "Next",
                            function: () {
                              if (currentPageIndex == 4) {
                                return;
                              }
                              setState(() {
                                currentPageIndex += 1;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
              const VerticalSpacing(10),
              newsType == NewsType.topTrending
                  ? Container()
                  : Align(
                      alignment: Alignment.topRight,
                      child: Material(
                        color: Theme.of(context).cardColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: DropdownButton(
                              value: sortBy,
                              items: dropDownItems,
                              onChanged: (String? value) {
                                setState(() {
                                  sortBy = value!;
                                });
                              }),
                        ),
                      ),
                    ),
              FutureBuilder<List<Article>>(
                  future: newsType == NewsType.topTrending
                      ? newsProvider.fetchTopHeadlines()
                      : newsProvider.fetchAllNewsData(
                          page: currentPageIndex + 1, sortBy: sortBy),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Container(
                        child: EmptyNewsWidget(
                            text: "${snapshot.error}",
                            imagePath: "assets/images/no_news.png"),
                      );
                    } else if (snapshot.data == null) {
                      return Expanded(
                          child: EmptyNewsWidget(
                        text: "",
                        imagePath: "",
                      ));
                    }
                    return newsType == NewsType.allNews
                        ? ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (ctx, index) {
                              return ChangeNotifierProvider.value(
                                  value: snapshot.data![index],
                                  child: ArticlesWidget());
                            })
                        : SizedBox(
                            height: size.height * 0.6,
                            child: Swiper(
                              autoplayDelay: 8000,
                              autoplay: true,
                              itemWidth: size.width * 0.9,
                              layout: SwiperLayout.STACK,
                              viewportFraction: 0.9,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return TopTrendingWidget(
                                    article: snapshot.data![index]);
                              },
                            ),
                          );
                  }),
            ]),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> get dropDownItems {
    List<DropdownMenuItem<String>> menuItem = [
      DropdownMenuItem(
        value: SortByEnum.relevancy.name,
        child: Text(SortByEnum.relevancy.name),
      ),
      DropdownMenuItem(
        value: SortByEnum.publishedAt.name,
        child: Text(SortByEnum.publishedAt.name),
      ),
      DropdownMenuItem(
        value: SortByEnum.popularity.name,
        child: Text(SortByEnum.popularity.name),
      ),
    ];
    return menuItem;
  }

  Widget paginationButtons({required Function function, required String text}) {
    return ElevatedButton(
      onPressed: () {
        function();
      },
      child: Text(text),
      style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          padding: EdgeInsets.all(6),
          textStyle:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}
