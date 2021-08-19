import 'package:intl/intl.dart';

class Movie {
  int _id;
  String _title;
  String _director;
  String _imagePath;

  Movie(this._id, this._director, this._title, this._imagePath);

  int get id => _id;
  String get title => _title;
  String get director => _director;
  String get imagePath => _imagePath;

  String get date {
    final date = DateTime.fromMillisecondsSinceEpoch(_id);
    return DateFormat('EEE h:mm a, dd/MM/yyyy').format(date);
  }
}