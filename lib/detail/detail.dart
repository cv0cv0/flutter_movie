import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_movie/model/movie.dart';
import 'package:flutter_movie/util/util.dart';

class DetailPage extends StatefulWidget {
  DetailPage(this._movie, this._index);

  final Movie _movie;
  final _index;

  @override
  State<StatefulWidget> createState() {
    return new _DetailPageState();
  }
}

class _DetailPageState extends State<DetailPage> {
  Movie _movie;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget._movie.title),
      ),
      body: _body(),
    );
  }

  _initData() async {
    var response = await createHttpClient().read(
      'http://api.douban.com/v2/movie/subject/${widget._movie.movieId}',
    );

    setState(() {
      _movie = Util.toMovieList(Page.DETAIL, response);
    });
  }

  _body() {
    if (_movie == null) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      var textStyle = new TextStyle(fontSize: 16.0);

      return new ListView(
        padding: const EdgeInsets.all(12.0),
        children: <Widget>[
          _image(),
          _title(),
          new Text('导演：${_movie.director}', style: textStyle),
          new Text('主演：${_movie.cast}', style: textStyle),
          new Text('评分：${_movie.average}', style: textStyle),
          _summary()
        ],
      );
    }
  }

  _image() {
    return new Center(
      child: new Image.network(
        _movie.smallImage,
        height: 240.0,
      ),
    );
  }

  _title() {
    return new Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
      child: new Text(
        _movie.title,
        style: new TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
    );
  }

  _summary() {
    return new Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: new Text(
        '剧情简介：${_movie.summary}',
        style: new TextStyle(fontSize: 14.0),
      ),
    );
  }
}
