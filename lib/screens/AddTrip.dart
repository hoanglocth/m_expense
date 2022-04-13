import 'package:m_expense/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTrip extends StatefulWidget {
  const AddTrip({Key? key}) : super(key: key);

  @override
  State<AddTrip> createState() => _AddTripState();
}

class _AddTripState extends State<AddTrip> {
  final _tripNameController = TextEditingController();
  final _tripDestinationController = TextEditingController();
  final _tripDateController = TextEditingController(
      text: DateFormat('dd-MM-yyyy').format(DateTime.now()).toString());
  final _tripRiskController = TextEditingController();
  final _tripDescriptionController = TextEditingController();
  bool _validateName = false;
  bool _validateDestination = false;
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Trip"),
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
                    DateTime? _pickDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
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
                          showDialogConfirm(context);
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

  void showDialogConfirm(BuildContext context) {
    Widget okBtn = TextButton(
        onPressed: () {
        },
        child: const Text('Ok'));

    Widget cancelBtn = TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('Cancel'));

    AlertDialog confirmDialog = AlertDialog(
      title: const Text("Confirm Data"),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        //position
        mainAxisSize: MainAxisSize.min,
        // wrap content in flutter
        children: <Widget>[
          Text("Name : " + _tripNameController.text),
          Text("Destination : " + _tripDestinationController.text),
          Text("Date : " + _tripDateController.text),
          Text("Risk Assessment : " + _tripRiskController.text),
          Text("Description : \n" + _tripDescriptionController.text),
        ],
      ),
      actions: <Widget>[okBtn, cancelBtn],
    );

    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          FocusScope.of(context).unfocus();
          TextEditingController().clear();
          return confirmDialog;
        });
  }
}
