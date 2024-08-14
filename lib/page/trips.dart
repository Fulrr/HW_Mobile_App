import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/response/TripIdxGetResponse.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';

class TripPage extends StatefulWidget {
  final int idx;
  const TripPage({Key? key, required this.idx}) : super(key: key);

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  String url = '';
  late Future<TripIdxGetResponse> _tripFuture;

  @override
  void initState() {
    super.initState();
    _tripFuture = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Details'),
      ),
      body: FutureBuilder<TripIdxGetResponse>(
        future: _tripFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text('No data available'),
            );
          }
          final trip = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trip.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text('Country: ${trip.country}'),
                if (trip.coverimage.isNotEmpty)
                  Image.network(
                    trip.coverimage,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200, // Adjust the height as needed
                    errorBuilder: (context, error, stackTrace) {
                      return Center(child: Text('Image not available'));
                    },
                  ),
                const SizedBox(height: 8),
                Text('Duration: ${trip.duration} days'),
                Text('Price: \$${trip.price}'),
                const SizedBox(height: 16),
                Text(trip.detail),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<TripIdxGetResponse> loadDataAsync() async {
    final config = await Configuration.getConfig();
    url = config['apiEndpoint'];
    final res = await http.get(Uri.parse('$url/trips/${widget.idx}'));
    log(res.body); // Log the raw response
    if (res.statusCode == 200) {
      final jsonData = json.decode(res.body);
      if (jsonData is List) {
        // If it's a list, take the first item
        return TripIdxGetResponse.fromJson(jsonData.first);
      } else if (jsonData is Map<String, dynamic>) {
        // If it's a single object
        return TripIdxGetResponse.fromJson(jsonData);
      } else {
        throw Exception('Unexpected JSON structure');
      }
    } else {
      throw Exception('Failed to load trip data');
    }
  }
}
