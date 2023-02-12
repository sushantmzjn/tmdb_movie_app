import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:movie_app/provider/movie_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movie_app/view/home.dart';
import 'package:movie_app/view/widget/detail_page.dart';

class CategoryTabBar extends ConsumerWidget {
  final CategoryType categoryType;
  final String pageKey;

  CategoryTabBar(this.categoryType, this.pageKey);

  @override
  Widget build(BuildContext context, ref) {
    final movieData = categoryType == CategoryType.popular
        ? ref.watch(popularProvider)
        : categoryType == CategoryType.top_rated
            ? ref.watch(topratedProvider)
            : categoryType == CategoryType.now_playing
                ? ref.watch(nowPlayingProvider)
                : ref.watch(upcomingProvider);

    if (movieData.isLoad) {
      return Center(
          child: SpinKitHourGlass(
        color: Colors.white,
      ));
    } else if (movieData.isError) {
      return Center(child: Text(movieData.errorMessage));
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 5.0, right: 3.0, left: 3.0),
        child: NotificationListener(
          onNotification: (ScrollEndNotification onNotification) {
            final before = onNotification.metrics.extentBefore;
            final max = onNotification.metrics.maxScrollExtent;
            // print(before);
            // print(max);
            if (before == max) {
              if (categoryType == CategoryType.popular) {
                ref.read(popularProvider.notifier).loadMore();
              } else if (categoryType == CategoryType.now_playing) {
                ref.read(nowPlayingProvider.notifier).loadMore();
              }else if (categoryType == CategoryType.top_rated) {
                ref.read(topratedProvider.notifier).loadMore();
              }else if (categoryType == CategoryType.upcomming) {
                ref.read(upcomingProvider.notifier).loadMore();
              }
            }
            return true;
          },
          child: GridView.builder(
              key: PageStorageKey<String>(pageKey),
              itemCount: movieData.movies.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 2 / 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  crossAxisCount: 3),
              itemBuilder: (context, index) {
                final movie = movieData.movies[index];
                return InkWell(
                  onTap: (){
                    Get.to(() => DetailPage(movie), transition:Transition.downToUp );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: CachedNetworkImage(
                      errorWidget: (context, url, error) =>
                          Image.asset('images/no_image.png'),
                      placeholder: (context, url) => Center(
                          child: SpinKitThreeInOut(
                        size: 15.0,
                        color: Colors.white,
                      )),
                      fit: BoxFit.fitHeight,
                      imageUrl:
                          'https://image.tmdb.org/t/p/w600_and_h900_bestv2${movie.poster_path}',
                    ),
                  ),
                );
              }),
        ),
      );
    }
  }
}
