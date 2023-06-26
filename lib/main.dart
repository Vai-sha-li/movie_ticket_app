import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/movie_details_screen.dart';
import 'screens/seat_arrangement_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MovieTicketApp());
}

class MovieTicketApp extends StatelessWidget {
  const MovieTicketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Ticket',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: 'Register',
      routes: {
        'HomeScreen': (context) => const HomeScreen(),
        'Register': (context) => const Register(),
        'Login': (context) => const Login(),
      },
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/movie_details':
            final dynamic movie = settings.arguments;
            return MaterialPageRoute(
              builder: (context) => MovieDetailsScreen(movie: movie),
            );
          case '/seat_arrangement':
            final dynamic movie = settings.arguments;
            return MaterialPageRoute(
              builder: (context) => SeatArrangementScreen(movie: movie),
            );
          default:
            return null;
        }
      },
    );
  }
}