import 'package:dio/dio.dart';

import 'package:movie_app/model/movie.dart';
import 'package:dartz/dartz.dart';

import '../api.dart';
import '../constant/constants.dart';

class MovieService {
  static final dio = Dio();

  //get movies category
  static Future<Either<String, List<Movie>>> getMovieByCategory(
      {required String api, required int page}) async {
    try {
      final response = await dio
          .get(api, queryParameters: {'api_key': apiKey, 'page': page});

      final data = (response.data['results'] as List)
          .map((e) => Movie.fromJson(e))
          .toList();
      return Right(data);
    } on DioError catch (err) {
      return (Left(err.message));
    }
  }

  //search
  static Future<Either<String, List<Movie>>> getSearchMovie(
      {required String searchText}) async {
    try {
      final response = await dio.get(Api.searchMovie,
          queryParameters: {'api_key': apiKey, 'query': searchText});

      final data = (response.data['results'] as List)
          .map((e) => Movie.fromJson(e))
          .toList();
      return Right(data);
    } on DioError catch (err) {
      return Left(err.message);
    }
  }
}
