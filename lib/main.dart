import 'package:flutter/material.dart';
import 'package:movie_corns/pages/add_review.dart';
import 'package:movie_corns/pages/home.dart';
import 'package:movie_corns/pages/login.dart';
import 'package:movie_corns/pages/movie.dart';
import 'package:movie_corns/pages/my_reviews.dart';
import 'package:movie_corns/pages/profile.dart';
import 'package:movie_corns/pages/register.dart';

import 'pages/splash.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: SplashPage(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => HomePage(title: 'All Movies'),
        '/my':(BuildContext context ) => MyReviewsPage(),
        '/profile':(BuildContext context ) => ProfilePage(),
        '/movie':(BuildContext context ) => MoviePage(),
        '/add-review':(BuildContext context ) => AddReviewPage(),
        '/login': (BuildContext context) => LoginPage(),
        '/register': (BuildContext context) => RegisterPage(),
      });
  }
}