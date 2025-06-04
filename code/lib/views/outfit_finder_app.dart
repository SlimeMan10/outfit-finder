import 'package:flutter/material.dart';
import 'package:outfit_finder/providers/database_provider.dart';
import 'package:outfit_finder/components/weather_filter.dart';
import 'package:outfit_finder/models/outfit.dart';

class OutFitFinderApp extends StatefulWidget {
  final DatabaseProvider venues;

  const OutFitFinderApp({super.key, required this.venues});

  @override
  State<OutFitFinderApp> createState() => _OutFitFinderAppState();
}

class _OutFitFinderAppState extends State<OutFitFinderApp> {
  int _selectedIndex = 0;
  late Future<List<Outfit>> _outfitsFuture;

  @override
  void initState() {
    super.initState();
    _outfitsFuture = widget.venues.getAllOutfits();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Outfit Finder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Outfit Finder'),
        ),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Hello! This is a test message to verify rendering.',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Outfit>>(
                future: _outfitsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  final outfits = snapshot.data ?? [];
                  if (outfits.isEmpty) {
                    return const Center(
                      child: Text('No outfits available'),
                    );
                  }

                  return IndexedStack(
                    index: _selectedIndex,
                    children: [
                      WeatherFilter(outfits: outfits),
                      const Center(
                        child: Text('All Outfits View Coming Soon'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.cloud),
              label: 'Weather Filter',
            ),
            NavigationDestination(
              icon: Icon(Icons.list),
              label: 'All Outfits',
            ),
          ],
        ),
      ),
    );
  }
}
