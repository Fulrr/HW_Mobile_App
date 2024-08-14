import 'dart:developer' as dev;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/config/config.dart';
import 'package:flutter_application_3/models/response/trip_get_res.dart';
import 'package:flutter_application_3/page/trips.dart';
import 'package:flutter_application_3/page/profile.dart';
import 'package:http/http.dart' as http;

class ShowTripPage extends StatefulWidget {
  final int? cid;
  ShowTripPage({super.key, required this.cid});

  @override
  State<ShowTripPage> createState() => _ShowTripPageState();
}

class _ShowTripPageState extends State<ShowTripPage> {
  String url = '';
  List<TripGetRes> tripGetResponses = [];
  late Future<void> loadData;
  String selectedZone = 'all';

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  Future<void> loadDataAsync() async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];
    var res = await http.get(Uri.parse('$url/trips'));
    dev.log(res.body);
    List<TripGetRes> allTrips = tripGetResFromJson(res.body);

    if (selectedZone == 'all') {
      tripGetResponses = allTrips;
    } else {
      tripGetResponses = allTrips
          .where((trip) => trip.destinationZone == selectedZone)
          .toList();
    }

    dev.log(tripGetResponses.length.toString());
  }

  void filterByZone(String zone) {
    setState(() {
      selectedZone = zone;
      loadData = loadDataAsync();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการทริป'),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              dev.log(value);
              if (value == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(idx: widget.cid ?? 0),
                  ),
                );
              } else if (value == 'logout') {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('ข้อมูลส่วนตัว'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('ออกจากระบบ'),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 10.0, right: 10, left: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("ปลายทาง"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FilledButton(
                            onPressed: () => filterByZone('all'),
                            child: const Text('ทั้งหมด')),
                        FilledButton(
                            onPressed: () => filterByZone('เอเชีย'),
                            child: const Text('เอเชีย')),
                        FilledButton(
                            onPressed: () => filterByZone('ยุโรป'),
                            child: const Text('ยุโรป')),
                        FilledButton(
                            onPressed: () => filterByZone('อาเซียน'),
                            child: const Text('อาเซียน')),
                        FilledButton(
                            onPressed: () =>
                                filterByZone('เอเชียตะวันออกเฉียงใต้'),
                            child: const Text('เอเชียตะวันออกเฉียงใต้')),
                        FilledButton(
                            onPressed: () => filterByZone('ประเทศไทย'),
                            child: const Text('ประเทศไทย')),
                        FilledButton(
                            onPressed: () => filterByZone('อื่นๆ'),
                            child: const Text('อื่นๆ')),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: tripGetResponses.isEmpty
                      ? Center(
                          child: Text(
                            'ไม่พบทริปใน${selectedZone == 'all' ? 'ทั้งหมด' : selectedZone}',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      : ListView.builder(
                          itemCount: tripGetResponses.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: Image.network(
                                        tripGetResponses[index].coverimage,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(Icons.error);
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            tripGetResponses[index].name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                              'Country: ${tripGetResponses[index].country}'),
                                          Text(
                                              'Duration: ${tripGetResponses[index].duration}'),
                                          Text(
                                              'Price: ${tripGetResponses[index].price}'),
                                          const SizedBox(height: 8),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: FilledButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        TripPage(
                                                            idx:
                                                                tripGetResponses[
                                                                        index]
                                                                    .idx),
                                                  ),
                                                );
                                              },
                                              child: const Text(
                                                  'รายละเอียดเพิ่มเติม'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
