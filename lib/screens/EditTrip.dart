import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../models/TripModel.dart';
import '../services/TripService.dart';

class EditTrip extends StatefulWidget {
  final TripModel tripModel;

  const EditTrip({Key? key, required this.tripModel}) : super(key: key);

  @override
  State<EditTrip> createState() => _EditTripState();
}

class _EditTripState extends State<EditTrip> {
  final _tripNameController = TextEditingController();
  final _tripDestinationController = TextEditingController();
  final _tripDateController = TextEditingController();
  final _tripRiskController = TextEditingController();
  final _tripDescriptionController = TextEditingController();
  bool _validateName = false;
  bool _validateDestination = false;
  bool _isChecked = false;
  final _tripService = TripService();

  @override
  void initState() {
    setState(() {
      _tripNameController.text = widget.tripModel.nameTrip ?? '';
      _tripDestinationController.text = widget.tripModel.destinationTrip ?? '';
      _tripDateController.text = widget.tripModel.dateTrip ?? '';
      _tripRiskController.text = widget.tripModel.riskTrip ?? '';
      if (_tripRiskController.text == "Yes") {
        _isChecked = true;
      } else {
        _isChecked = false;
      }
      _tripDescriptionController.text = widget.tripModel.descriptionTrip ?? '';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Trip Information"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: _tripNameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Name of Trip',
                    errorText:
                    _validateName ? 'Name Value Can\'t Be Empty' : null,
                  )),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: _tripDestinationController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Destination of Trip',
                    errorText: _validateDestination
                        ? 'Destination Value Can\'t Be Empty'
                        : null,
                  )),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: _tripDateController,
                  readOnly: true,
                  onTap: () async {
                    DateTime? _tempDate = DateFormat('dd-MM-yyyy')
                        .parse(_tripDateController.text);
                    DateTime? _pickDate = await showDatePicker(
                      context: context,
                      initialDate: _tempDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2222),
                    );
                    if (_pickDate != null) {
                      setState(() {
                        _tripDateController.text = DateFormat('dd-MM-yyyy')
                            .format(_pickDate)
                            .toString();
                      });
                    }
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Date of Trip',
                  )),
              const SizedBox(
                height: 20.0,
              ),
              CheckboxListTile(
                title: const Text("Risk Assessment"),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0), // Optionally
                  side: const BorderSide(color: Colors.grey),
                ),
                value: _isChecked,
                onChanged: (newCheckedValue) {
                  setState(() {
                    _isChecked = newCheckedValue!;
                    if (_isChecked == true) {
                      _tripRiskController.text = "Yes";
                    } else {
                      _tripRiskController.text = "No";
                    }
                  });
                },
                activeColor: Colors.red,
                checkColor: Colors.white,
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                  controller: _tripDescriptionController,
                  keyboardType: TextInputType.multiline,
                  textAlignVertical: TextAlignVertical.top,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description of Trip',
                    alignLabelWithHint: true,
                    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 90),
                  )),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.teal,
                          textStyle: const TextStyle(fontSize: 15)),
                      onPressed: () async {
                        setState(() {
                          _tripNameController.text.isEmpty
                              ? _validateName = true
                              : _validateName = false;
                          _tripDestinationController.text.isEmpty
                              ? _validateDestination = true
                              : _validateDestination = false;
                        });
                        if (_validateName == false &&
                            _validateDestination == false) {
                          // print("Good Data Can Save");
                          var _tripModel = TripModel();
                          _tripModel.idTrip = widget.tripModel.idTrip;
                          _tripModel.nameTrip = _tripNameController.text;
                          _tripModel.destinationTrip =
                              _tripDestinationController.text;
                          _tripModel.dateTrip = _tripDateController.text;
                          _tripModel.riskTrip = _tripRiskController.text;
                          _tripModel.descriptionTrip =
                              _tripDescriptionController.text;
                          var result =
                          await _tripService.updateTrip(_tripModel);
                          if (!mounted) return;
                          Navigator.pop(context, result);
                        }
                      },
                      child: const Text('Save')),
                  const SizedBox(
                    width: 10.0,
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                          textStyle: const TextStyle(fontSize: 15)),
                      onPressed: () {
                        _tripNameController.text = '';
                        _tripDestinationController.text = '';
                        _tripRiskController.text = '';
                        _tripDescriptionController.text = '';
                      },
                      child: const Text('Clear All'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
