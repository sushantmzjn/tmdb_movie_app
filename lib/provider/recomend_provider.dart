import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/model/movie.dart';

import '../constant/constants.dart';

final recommendedProvider = FutureProvider.family((ref, int id) => RecommendedMovies.getVideoKey(id) );

class RecommendedMovies{
  static Future<List<Movie>> getVideoKey(int movieId) async {
    final dio =Dio();
    try{
      final response = await dio.get('https://api.themoviedb.org/3/movie/$movieId/recommendations',
      queryParameters:{
        'api_key': apiKey
      });

      final data = (response.data['results'] as List).map((e) => Movie.fromJson(e)).toList();
      print(response.data);
      return data;
    }on DioError catch(err){
      print(err.response);
      throw err.message;
    }
  }
}