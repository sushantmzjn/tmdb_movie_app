import 'movie.dart';

class MovieState {
  final bool isLoad;
  final bool isError;
  final String errorMessage;
  final List<Movie> movies;
  final int page;
  final bool isLoadMore;

  MovieState(
      {required this.isLoad,
      required this.isError,
      required this.errorMessage,
      required this.movies,
      required this.page,
      required this.isLoadMore});

  MovieState copyWith(
      {bool? isLoad,
      bool? isError,
      String? errorMessage,
      List<Movie>? movies,
      int? page,
      bool? isLoadMore}) {
    return MovieState(
        isLoad: isLoad ?? this.isLoad,
        isError: isError ?? this.isError,
        errorMessage: errorMessage ?? this.errorMessage,
        movies: movies ?? this.movies,
        isLoadMore: isLoadMore ?? this.isLoadMore,
        page: page ?? this.page);
  }
}
