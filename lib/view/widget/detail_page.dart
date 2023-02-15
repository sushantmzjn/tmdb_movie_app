import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:movie_app/provider/movie_provider.dart';
import 'package:movie_app/provider/recomend_provider.dart';
import 'package:pod_player/pod_player.dart';

import '../../model/movie.dart';
import '../../provider/video_provider.dart';

class DetailPage extends ConsumerWidget {
  final Movie movie;
  DetailPage(this.movie);

  @override
  Widget build(BuildContext context, ref) {
    final videoData = ref.watch(videoProvider(movie.id));
    final recommendedData =ref.watch(recommendedProvider(movie.id));

    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
                'https://image.tmdb.org/t/p/w600_and_h900_bestv2${movie.poster_path}'),
            onError: (exception, stackTrace) {
              const AssetImage('images/no_image.png');
            },
          )),
          child: BackdropFilter(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
              filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0)),
        ),
        SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  height: 190.h,
                  width: double.infinity,
                  color: Colors.red,
                  child: videoData.when(
                      data: (data) {
                        // print(data[0]);
                        return data.isEmpty
                            ? const Center(child: Text('no video'))
                            : VideoPlay(data[0]);
                      },
                      error: (err, stack) => Center(child: Text('$err')),
                      loading: () => Container()),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              movie.title,
                              style: TextStyle(
                                  fontSize: 20.sp, fontWeight: FontWeight.w800),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Rating', style: TextStyle(fontSize: 10.sp)),
                              Text(
                                movie.vote_average,
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.lightBlue),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(movie.overview,
                              style: TextStyle(fontSize: 14.sp, letterSpacing: .5)),
                          SizedBox(height: 8.h),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Release Date', style: TextStyle(fontSize: 10.sp)),
                              Text(movie.release_date,
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      letterSpacing: .5,
                                      color: Colors.lightBlue)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Recommended Movies', style: TextStyle(fontSize: 16.sp, letterSpacing: .5)),
                            ),
                          ],
                        ),
                        Container(
                          height: 160.h,
                          padding: const EdgeInsets.only(left: 1.0, right: 1.0, bottom: 2.0 ),
                          child: recommendedData.when(data: (data){
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: data.length,
                                itemBuilder: (c, i){
                                print(data);
                                  return data.isEmpty ? const Center(child: Text('No Recommendation', style: TextStyle(color: Colors.red),)) : Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 3.0),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child:
                                        GestureDetector(
                                          onTap: (){
                                            // print(data[i].id);
                                            Navigator.of(context).push(
                                              MaterialPageRoute(builder: ((context)=>  DetailPage(data[i])))
                                            );
                                            // Get.to(()=> DetailPage(movie), transition: Transition.downToUp);
                                            },
                                          child: CachedNetworkImage(
                                            errorWidget: (context, url, error) =>
                                                Image.asset('images/no_image.png'),
                                            placeholder: (context, url) => const Center(
                                                child: SpinKitThreeInOut(
                                                  size: 15.0,
                                                  color: Colors.white,
                                                )),
                                            fit: BoxFit.fitHeight,
                                            imageUrl:
                                            'https://image.tmdb.org/t/p/w600_and_h900_bestv2${data[i].poster_path}' ,
                                          ),
                                        )
                                        ),
                                  );
                                });
                          }, error: (e, s)=> Container(), loading:()=> const Center(child : Text('Loading...'))),
                        ),
                      ],
                    ),
                  ],
                )



              ],
            ),
          ),
        ),
      ]),
    ));
  }
}

class VideoPlay extends StatefulWidget {
  final String keys;

  // final Movie movie;

  VideoPlay(this.keys);

  @override
  State<VideoPlay> createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {
  late final PodPlayerController controller;

  @override
  void initState() {
    controller = PodPlayerController(
        playVideoFrom: PlayVideoFrom.youtube('https://youtu.be/${widget.keys}'),
        podPlayerConfig: const PodPlayerConfig(
          autoPlay: false,
          isLooping: false,
        ))
      ..initialise();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Colors.red,
        child: widget.keys == ''
            ? const Center(child: Text('video not available'))
            : PodVideoPlayer(controller: controller));
  }
}
