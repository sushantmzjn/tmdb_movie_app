class Movie {
  final String backdrop_path;
  final int id;
  final String title;
  final String overview;
  final String poster_path;
  final String release_date;
  final String vote_average;

  Movie(
      {required this.backdrop_path,
      required this.id,
      required this.title,
      required this.overview,
      required this.poster_path,
      required this.release_date,
      required this.vote_average});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
        id: json['id'],
        backdrop_path: json['backdrop_path'] ?? '',
        title: json['title'],
        overview: json['overview'],
        poster_path: json['poster_path'],
        release_date: json['release_date'],
        vote_average: '${json['vote_average']}');
  }
}
