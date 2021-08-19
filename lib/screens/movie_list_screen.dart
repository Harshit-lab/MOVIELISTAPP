import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:movie/helper/movie_provider.dart';
import 'package:movie/screens/movie_edit_screen.dart';
import 'package:movie/utils/constants.dart';
import 'package:movie/widgets/list_item.dart';
import 'package:provider/provider.dart';

class MovieListScreen extends StatelessWidget {
  const MovieListScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<MovieProvider>(context, listen: false).getMovies(),
        builder: (context,snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator(),),
            );
          }
          else {
            if (snapshot.connectionState == ConnectionState.done) {
              return Scaffold(
                body: Consumer<MovieProvider>(
                  child: noMoviesUI(context),
                  builder: (context,movieprovider,child) => 
                    movieprovider.items.length <= 0 ? child: 
                    ListView.builder(
                      itemCount: movieprovider.items.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0)
                          return header();
                        else {
                          final i = index -1;
                          final item = movieprovider.items[i];
                          return ListItem(item.id, item.title, item.director, item.imagePath, item.date, context);
                        }
                      },
                      ),
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      goToMovieEditScreen(context);
                    },
                    child: Icon(Icons.add),
                  ),
              );
            }
          }
          return Container();
        },
    );
  }

  Widget header() {
    return Container(
      decoration: BoxDecoration(
        color: headerColor,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(75.0),
          bottomLeft: Radius.circular(75.0)
        )
      ),
      height: 100.0,
      width: double.infinity,
      child: Column(
        children: [
          Text(
          '',
          style: headerRideStyle,),
          Text(
            'Movies',
            style: headerNotesStyle,
            ),
        ],
      ),
    );
  }

  Widget noMoviesUI(BuildContext context) {
    return ListView(
      children: [
        header(),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Image.asset('crying_emoji.png', fit: BoxFit.cover,
              width: 200.0,
              height: 200.0,
              ),
            ),
            RichText(
              text: TextSpan(
                style: noNotesStyle,
                children: [
                  TextSpan(text: 'There are no movies available \n Tap on " '),
                  TextSpan(
                    text: '+',
                    style: boldPlus,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        goToMovieEditScreen(context);
                  }),
                  TextSpan(text: ' " to add a new movie'),
              ]),
            ),
          ],
        )
      ],
    );
  }

  void goToMovieEditScreen(BuildContext context) {
    Navigator.of(context).pushNamed(MovieEditScreen.route);
  }
}