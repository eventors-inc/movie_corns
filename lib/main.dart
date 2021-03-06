import 'package:flutter/material.dart';
import 'package:movie_corns/constants/constants.dart';
import 'package:movie_corns/pages/view_movieDetail.dart';
import 'package:movie_corns/pages/home.dart';
import 'package:movie_corns/pages/login.dart';
import 'package:movie_corns/pages/movies.dart';
import 'package:movie_corns/pages/my_reviews.dart';
import 'package:movie_corns/pages/profile.dart';
import 'package:movie_corns/pages/register.dart';
import 'package:movie_corns/pages/add_review.dart';

import 'pages/splash.dart';

/*
 * IT17050272 - D. Manoj Kumar | IT17143950 - G.M.A.S. Bastiansz
 * 
 * Includes all the routes which need to access the dart files
 */

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Movie Corns',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashPage(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) =>
              HomePage(title: TitleConstants.ALL_MOVIES),
          '/my': (BuildContext context) => MyReviewsPage(),
          '/profile': (BuildContext context) => ProfilePage(),
          '/movie': (BuildContext context) => MoviePage(),
          '/view-movieDetail': (BuildContext context) => ViewMovieDetailPage(),
          '/add-review': (BuildContext context) => AddReviewPage(),
          '/login': (_) => new LoginPage(),
          '/register': (BuildContext context) => RegisterPage(),
        });
  }
}
