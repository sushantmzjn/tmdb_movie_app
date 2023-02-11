import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../provider/search_provider.dart';

class SearchPage extends ConsumerWidget {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context, ref) {
    final searchData = ref.watch(searchProvider);
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top :8.0, right: 8.0, left: 8.0),
            child: Row(children: [
              IconButton(
                  onPressed: () {
                    ref.invalidate(searchProvider);
                    Navigator.of(context).pop();
                  },
                  icon: Icon(CupertinoIcons.left_chevron)),
              Expanded(
                child: TextFormField(
                  controller: searchController,
                  onFieldSubmitted: (val) {
                    if (val.isEmpty) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('text cannot be empty')));
                    } else {
                      ref.read(searchProvider.notifier).getSearchMovie(val);
                      searchController.clear();
                    }
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(CupertinoIcons.search),
                      hintText: 'Search',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      border: OutlineInputBorder()),
                ),
              ),
            ]),
          ),
          Expanded(
            child: searchData.isLoad
                ? Center(child: CircularProgressIndicator())
                : searchData.isError
                    ? Center(
                        child: Text(searchData.errorMessage),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 8.0, left:2.0 ,right: 3.0),
                        child: GridView.builder(
                            itemCount: searchData.movies.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 2 / 3,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5,
                                    crossAxisCount: 2),
                            itemBuilder: (context, index) {
                              final movie = searchData.movies[index];
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: CachedNetworkImage(
                                    errorWidget: (c, s, d) =>
                                        Image.asset('images/no_image.png'),
                                    placeholder: (c, s) => Center(
                                            child: SpinKitThreeInOut(
                                          size: 15,
                                          color: Colors.white,
                                        )),
                                    fit: BoxFit.fitHeight,
                                    imageUrl:
                                        'https://image.tmdb.org/t/p/w600_and_h900_bestv2${movie.poster_path}'),
                              );
                            }),
                      ),
          ),
        ],
      ),
    ));
  }
}
