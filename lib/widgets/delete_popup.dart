import 'package:flutter/material.dart';
import 'package:movie/helper/models/movie.dart';
import 'package:movie/helper/movie_provider.dart';
import 'package:provider/provider.dart';

class DeletePopup extends StatelessWidget {
  final Movie selectedMovie;

  DeletePopup(this.selectedMovie);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      title: Text('Delete?'),
      content: Text('Are you sure you want to delete this movie?'),
      actions: [
        TextButton(
          onPressed: () {
            Provider.of<MovieProvider>(context, listen: false).deleteMovie(selectedMovie.id);
            Navigator.popUntil(context, ModalRoute.withName('/'));
          }, 
          child: Text('Yes'),
        ),
        TextButton(
          onPressed: () {
              Navigator.pop(context);
          }, 
          child: Text(
            'No'
          )),
      ],
    );
  }
}