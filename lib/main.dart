import 'package:buyitapp/provider/adminMode.dart';
import 'package:buyitapp/provider/modelHud.dart';
import 'package:buyitapp/screens/login_screen.dart';
import 'package:buyitapp/screens/signup_screen.dart';
import 'package:buyitapp/users/homePage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  //HomePage.id:(context)=>HomePage()
  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
        ChangeNotifierProvider<ModelHud>(
          create: (context)=>ModelHud(),),
        ChangeNotifierProvider<AdminMode>(
          create: (context)=>AdminMode(),)
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: LoginScreen.id,
          routes: {
            LoginScreen.id:(context)=>LoginScreen(),
            SignupScreen.id:(context)=>SignupScreen(),

          },
        ),
    );
  }
}

