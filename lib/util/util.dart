import 'dart:convert';

import 'package:flutter_movie/model/movie.dart';

class Util {
  static toMovieList(Page page, json) {
    switch (page) {
      case Page.LIST:
        return JSON
            .decode(json)['subjects']
            .map((map) => _toMovie(map))
            .toList();
      case Page.DETAIL:
        return _toMovie(JSON.decode(json));
    }
  }

  static _toMovie(map) {
    final directors = map['directors'];
    final casts = map['casts'];

    var director = '';
    for (var i = 0; i < directors.length; i++) {
      if (i == 0) {
        director += directors[i]['name'];
      } else {
        director += '/${directors[i]['name']}';
      }
    }

    var cast = '';
    for (var i = 0; i < casts.length; i++) {
      if (i == 0) {
        cast += casts[i]['name'];
      } else {
        cast += '/${casts[i]['name']}';
      }
    }

    return new Movie(
      map['title'],
      map['rating']['average'],
      map['collect_count'],
      map['images']['small'],
      director,
      cast,
      map['id'],
      summary: map['summary'],
    );
  }
}

enum Page {
  LIST,
  DETAIL,
}
