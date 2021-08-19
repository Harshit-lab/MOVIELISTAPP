import 'package:flutter/material.dart';
import 'package:movie/helper/database_helper.dart';
import 'package:movie/helper/models/movie.dart';
import 'package:movie/utils/constants.dart';

class MovieProvider with ChangeNotifier {
  List _items = [];

  List get items {
    return [..._items];
  }

  Movie getMovie(int id) {
    return _items.firstWhere((movie) => movie.id == id, orElse: () => null);
  }

  Future deleteMovie (id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
    return DatabaseHelper.delete(id);
  }


  Future addOrUpdateMovie (int id, String title, String content, String imagePath, EditMode editMode) async {
    final movie = Movie(id,content,title,imagePath);

    if(EditMode.ADD == editMode) {
      _items.insert(0, movie);
    } else {
      _items[_items.indexWhere((movie) => movie.id == id)] = movie;
    }

    notifyListeners();

    DatabaseHelper.insert({
      'id': movie.id,
      'director': movie.director,
      'title': movie.title,
      'imagePath': movie.imagePath,
    });
  }

  Future getMovies() async {
    final moviesList = await DatabaseHelper.getMoviesFromDB();

    _items = moviesList.map(
      (item) => Movie(item['id'], item['director'], item['title'], item['imagePath'])
    ).toList();
    notifyListeners();
  }
}