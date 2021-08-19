import 'package:flutter/material.dart';
import 'package:movie/helper/movie_provider.dart';
import 'package:movie/screens/movie_edit_screen.dart';
import 'package:movie/screens/movie_view_screen.dart';
import 'package:movie/screens/movie_list_screen.dart';
import 'package:provider/provider.dart';
//import 'package:firebase_core/firebase_core.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return ChangeNotifierProvider.value(
      value: MovieProvider(),
      child: MaterialApp(
        title: 'Movie List',
        // theme: ThemeData(
        //   brightness: Brightness.dark,
        // ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/' : (context) => MovieListScreen(),
          MovieViewScreen.route : (context) => MovieViewScreen(),
          MovieEditScreen.route : (context) => MovieEditScreen(),
        },
      ),
    );
  }
}