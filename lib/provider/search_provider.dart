import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/movie_state.dart';
import '../services/moive_service.dart';

final defaultState = MovieState(
  isLoad: false,
  isError: false,
  errorMessage: '',
  movies: [],
  page: 1,
  isLoadMore: false
);

final searchProvider =
    StateNotifierProvider.autoDispose<SearchMovie, MovieState>(
        (ref) => SearchMovie(defaultState));

class SearchMovie extends StateNotifier<MovieState> {
  SearchMovie(super.state);

  Future<void> getSearchMovie(String searchText) async {
    state = state.copyWith(isLoad: true, isError: false);
    final response = await MovieService.getSearchMovie(searchText: searchText);
    response.fold((l) {
      state = state.copyWith(isLoad: false, isError: true, errorMessage: l);
    }, (r) {
      state = state.copyWith(isLoad: false, isError: false, movies: r);
    });
  }
}
