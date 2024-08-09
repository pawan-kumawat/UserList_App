import 'package:flutter/material.dart';
import 'package:project_1/screens/user_list_screen.dart';
import 'package:provider/provider.dart';
import 'provider/user_provider.dart';

// Main entry point of the app
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MyApp(),
    ),
  );
}

// Main app widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // User List Screen with search functionality
      home: UserListScreen(),
    );
  }
}



