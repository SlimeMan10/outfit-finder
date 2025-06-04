import 'package:flutter/material.dart';
import 'package:outfit_finder/providers/database_provider.dart';

class OutFitFinderApp extends StatelessWidget {
  final DatabaseProvider venues;

  const OutFitFinderApp({super.key, required this.venues});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Outfit Finder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Outfit Finder App'),
        ),
      ),
    );
  }
}
