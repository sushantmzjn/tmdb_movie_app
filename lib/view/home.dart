import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:movie_app/view/search.dart';
import 'package:movie_app/view/widget/connection.dart';
import 'package:movie_app/view/widget/tab_bar.dart';

enum CategoryType { popular, top_rated, upcomming, now_playing }

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return DefaultTabController(
      length: 4,
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'TMDB Movies',
              style: TextStyle(letterSpacing: 2),
            ),
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: GestureDetector(
                    onTap: () {
                      Get.to(() => SearchPage(),
                          transition: Transition.downToUp);
                    },
                    child: Icon(CupertinoIcons.search)),
              )
            ],
            bottom: TabBar(
              isScrollable: true,
              splashBorderRadius: BorderRadius.circular(8.0),
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                Tab(
                  child: Text('Now Playing'),
                ),
                Tab(
                  child: Text('Popular'),
                ),
                Tab(
                  child: Text('Top Rated'),
                ),
                Tab(
                  child: Text('Up comming'),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                  child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  ConnectionWidget(widget: CategoryTabBar(CategoryType.now_playing, '1')),
                  ConnectionWidget(widget: CategoryTabBar(CategoryType.popular, '2')),
                  ConnectionWidget(widget: CategoryTabBar(CategoryType.top_rated, '3')),
                  ConnectionWidget(widget: CategoryTabBar(CategoryType.upcomming, '4')),
                ],
              ))
            ],
          )),
    );
  }
}
