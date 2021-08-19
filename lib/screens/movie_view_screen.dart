import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movie/helper/models/movie.dart';
import 'package:movie/helper/movie_provider.dart';
import 'package:movie/screens/movie_edit_screen.dart';
import 'package:movie/utils/constants.dart';
import 'package:movie/widgets/delete_popup.dart';
import 'package:provider/provider.dart';

class MovieViewScreen extends StatefulWidget {
  static const route = '/movie-view';
  @override
  _MovieViewScreenState createState() => _MovieViewScreenState();
}

class _MovieViewScreenState extends State<MovieViewScreen> {
  var selectedMovie;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final id;
    id =  ModalRoute.of(this.context)!.settings.arguments;
    final provider = Provider.of<MovieProvider>(context);
    if (provider.getMovie(id) != null) 
      selectedMovie = provider.getMovie(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.7,
        backgroundColor: white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
          color: black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: () => _showDialog(), 
            icon: Icon(Icons.delete), color: black,)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(selectedMovie?.title,
              style: viewTitleStyle,),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.access_time,
                      size: 18,
                    ),
                    ),
                    Text('${selectedMovie?.date}')
                ],
              ),
              if (selectedMovie.imagePath != null)
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
                 child: Image.file(File(selectedMovie.imagePath)),
                 ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  selectedMovie.director,
                  style: viewContentStyle,
                ),
                ),
          ],
          ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, MovieEditScreen.route, arguments: selectedMovie.id);
        },
        child: Icon(Icons.edit),
        ),
    );
  }

  _showDialog() {
    showDialog(context: this.context, builder: (context) {
     return DeletePopup(selectedMovie);
    });    
  }
}