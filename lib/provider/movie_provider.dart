import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/model/movie_state.dart';
import 'package:movie_app/services/moive_service.dart';

import '../api.dart';

final defaultState = MovieState(
    isLoad: false,
    isError: false,
    errorMessage: '',
    movies: [],
    page: 1,
    isLoadMore: false);

final popularProvider = StateNotifierProvider<PopularMovie, MovieState>(
    (ref) => PopularMovie(defaultState));
final topratedProvider = StateNotifierProvider<TopRatedMovies, MovieState>(
    (ref) => TopRatedMovies(defaultState));
final upcomingProvider = StateNotifierProvider<UpComingMovies, MovieState>(
    (ref) => UpComingMovies(defaultState));
final nowPlayingProvider = StateNotifierProvider<NowPlayingMovies, MovieState>(
    (ref) => NowPlayingMovies(defaultState));

//popular
class PopularMovie extends StateNotifier<MovieState> {
  PopularMovie(super.state) {
    getMovieByCategory();
  }

  Future<void> getMovieByCategory() async {
    state =
        state.copyWith(isLoad: state.isLoadMore ? false : true, isError: false);
    final response = await MovieService.getMovieByCategory(
        api: Api.popularMovie, page: state.page);
    response.fold((l) {
      state = state.copyWith(isLoad: false, isError: true, errorMessage: l);
    }, (r) {
      state = state.copyWith(
          isLoad: false, isError: false, movies: [...state.movies, ...r]);
    });
  }

  Future<void> loadMore() async {
    state = state.copyWith(isLoadMore: true, page: state.page + 1);
    getMovieByCategory();
  }
}

//top rated
class TopRatedMovies extends StateNotifier<MovieState> {
  TopRatedMovies(super.state) {
    getMovieByCategory();
  }

  Future<void> getMovieByCategory() async {
    state =
        state.copyWith(isLoad: state.isLoadMore ? false : true, isError: false);
    final response = await MovieService.getMovieByCategory(
        api: Api.topRatedMovie, page: state.page);
    response.fold((l) {
      state = state.copyWith(isLoad: false, isError: true, errorMessage: l);
    }, (r) {
      state = state.copyWith(
          isLoad: false, isError: false, movies: [...state.movies, ...r]);
    });
  }

  Future<void> loadMore() async {
    state = state.copyWith(isLoadMore: true, page: state.page + 1);
    getMovieByCategory();
  }
}

//up coming
class UpComingMovies extends StateNotifier<MovieState> {
  UpComingMovies(super.state) {
    getMovieByCategory();
  }

  Future<void> getMovieByCategory() async {
    state =
        state.copyWith(isLoad: state.isLoadMore ? false : true, isError: false);
    final response = await MovieService.getMovieByCategory(
        api: Api.upcomingMovie, page: state.page);
    response.fold((l) {
      state = state.copyWith(isLoad: false, isError: true, errorMessage: l);
    }, (r) {
      state = state.copyWith(
          isLoad: false, isError: false, movies: [...state.movies, ...r]);
    });
  }

  Future<void> loadMore() async {
    state = state.copyWith(isLoadMore: true, page: state.page + 1);
    getMovieByCategory();
  }
}

//now playing
class NowPlayingMovies extends StateNotifier<MovieState> {
  NowPlayingMovies(super.state) {
    getMovieByCategory();
  }

  Future<void> getMovieByCategory() async {
    state =
        state.copyWith(isLoad: state.isLoadMore ? false : true, isError: false);
    final response = await MovieService.getMovieByCategory(
        api: Api.nowPlaying, page: state.page);
    response.fold((l) {
      state = state.copyWith(isLoad: false, isError: true, errorMessage: l);
    }, (r) {
      state = state.copyWith(
          isLoad: false, isError: false, movies: [...state.movies, ...r]);
    });
  }

  Future<void> loadMore() async {
    state = state.copyWith(isLoadMore: true, page: state.page + 1);
    getMovieByCategory();
  }
}

//recommend
// final recommendedProvider = StateNotifierProvider<RecommendedMovies, MovieState>(
//         (ref) => RecommendedMovies(defaultState));
//
//
// class RecommendedMovies extends StateNotifier<MovieState>{
//   RecommendedMovies(super.state){
//     getMovieByCategory();
//   }
//
//   Future<void> getMovieByCategory() async{
//     state = state.copyWith(isLoad: true, isError: false);
//     final response =  await MovieService.getMovieByCategory(api: Api.recommendMovie, page: 1);
//     response.fold((l) {
//       state = state.copyWith(isLoad: false, isError: true, errorMessage: l);
//     }, (r) {
//       state = state.copyWith(isLoad: false, isError: false, movies: r);
//     });
//   }
//
// }
