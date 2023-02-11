import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioClient = Provider(
  (ref) => Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/',
      connectTimeout: 10000,
    ),
  ),
);
