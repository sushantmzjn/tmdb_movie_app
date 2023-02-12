import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pod_player/pod_player.dart';

import '../../model/movie.dart';
import '../../provider/video_provider.dart';

class DetailPage extends ConsumerWidget {
  final Movie movie;

  DetailPage(this.movie);

  @override
  Widget build(BuildContext context, ref) {
    final videoData = ref.watch(videoProvider(movie.id));
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
        Container(
          child: Column(
            children: [
              Container(
                height: 190.h,
                width: double.infinity,
                color: Colors.red,
                child: videoData.when(
                    data: (data) {
                      // print(data[0]);
                      return VideoPlay(data[0]);
                    },
                    error: (err, stack) => Center(child: Text('$err')),
                    loading: () => Container()),
              ),
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
              )
            ],
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
          autoPlay: true,
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
