import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:m_expense/screens/AddTrip.dart';
import 'package:m_expense/screens/EditTrip.dart';
import 'package:m_expense/screens/ViewTrip.dart';
import 'package:m_expense/services/TripService.dart';
import 'models/TripModel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M-Expense',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<TripModel> _tripList = <TripModel>[];
  final _tripService = TripService();

  getAllTripDetails() async {
    var trips = await _tripService.readAllTrip();
    _tripList = <TripModel>[];
    trips.forEach((trip) {
      setState(() {
        var _tripModel = TripModel();
        _tripModel.idTrip = trip['id_trip'];
        _tripModel.nameTrip = trip['name_trip'];
        _tripModel.destinationTrip = trip['destination_trip'];
        _tripModel.dateTrip = trip['date_trip'];
        _tripModel.riskTrip = trip['risk_trip'];
        _tripModel.descriptionTrip = trip['description_trip'];
        _tripList.add(_tripModel);
      });
    });
  }

  @override
  void initState() {
    getAllTripDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("M-Expense"),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                showDialog(
                    useSafeArea: true,
                    context: context,
                    builder: (context) => AlertDialog(
                      scrollable: true,
                      title: const Text("Confirm"),
                      content:
                      const Text("Do you want to delete all data?"),
                      actions: [
                        ElevatedButton(
                            onPressed: () async {
                              await _tripService.deleteAllTrip();
                              if (!mounted) return;
                              Navigator.pop(context);
                              setState(() {
                                getAllTripDetails();
                              });
                              Fluttertoast.showToast(
                                  msg: "Deleted all records");
                            },
                            child: const Text("Yes")),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {
                                getAllTripDetails();
                              });
                            },
                            child: const Text("No")),
                      ],
                    ));
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      body: ListView.builder(
          itemCount: _tripList.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) async {
                var result =
                await _tripService.deleteTripById(_tripList[index].idTrip);
                if (result != null) {
                  setState(() {
                    getAllTripDetails();
                  });
                  Fluttertoast.showToast(
                      msg: "Deleted record");
                }
              },
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewTrip(
                            tripModel: _tripList[index],
                          )));
                },
                title: Text(_tripList[index].nameTrip ?? ''),
                subtitle: Text(_tripList[index].destinationTrip ?? ''),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditTrip(
                                    tripModel: _tripList[index],
                                  ))).then((data) {
                            if (data != null) {
                              getAllTripDetails();
                              Fluttertoast.showToast(
                                  msg: "Trip updated successfully");
                            }
                          });
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.teal,
                        )),
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddTrip()))
              .then((data) {
            if (data != null) {
              setState(() {
                getAllTripDetails();
              });
              Fluttertoast.showToast(
                  msg: "Trip added successfully");
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
