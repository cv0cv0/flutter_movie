import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_movie/detail/detail.dart';
import 'package:flutter_movie/model/movie.dart';
import 'package:flutter_movie/util/util.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  var _movies = [];

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('豆瓣电影'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.person),
            onPressed: () {},
          )
        ],
      ),
      body: _body(),
    );
  }

  _initData() async {
    var response = await createHttpClient().read(
      'https://api.douban.com/v2/movie/in_theaters?apikey=0b2bdeda43b5688921839c8ecb20399b&city=%E5%8C%97%E4%BA%AC&start=0&count=100&client=&udid=',
    );

    if (mounted) {
      setState(() {
        _movies = Util.toMovieList(Page.LIST, response);
      });
    }
  }

  _body() {
    if (_movies.isEmpty) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      return new ListView.builder(
        itemBuilder: _item,
        itemCount: _movies.length,
      );
    }
  }

  _item(BuildContext context, int index) {
    Movie movie = _movies[index];

    return new GestureDetector(
      onTap: () => _toDetailPage(movie, index),
      child: new Column(
        children: <Widget>[
          new Row(
            children: <Widget>[
              _image(movie, index),
              new Expanded(child: _info(movie)),
              new Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: new Icon(Icons.keyboard_arrow_right),
              )
            ],
          ),
          new Divider()
        ],
      ),
    );
  }

  _image(Movie movie, int index) {
    var padding;
    if (index == 0) {
      padding =
          const EdgeInsets.only(left: 6.0, top: 12.0, right: 8.0, bottom: 6.0);
    } else {
      padding =
          const EdgeInsets.only(left: 6.0, top: 6.0, right: 8.0, bottom: 6.0);
    }

    return new Padding(
      padding: padding,
      child: new Image.network(
        movie.smallImage,
        width: 100.0,
        height: 120.0,
      ),
    );
  }

  _info(Movie movie) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.only(bottom: 6.0),
          child: new Text(
            movie.title,
            textAlign: TextAlign.left,
            style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
        ),
        new Text('导演：${movie.director}'),
        new Text('主演：${movie.cast}'),
        new Text('评分：${movie.average}'),
        new Text(
          '${movie.collectCount}人看过',
          style: new TextStyle(
            fontSize: 12.0,
            color: Colors.redAccent,
          ),
        )
      ],
    );
  }

  _toDetailPage(movie, index) {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (BuildContext context) {
          return new DetailPage(movie, index);
        },
      ),
    );
  }
}
