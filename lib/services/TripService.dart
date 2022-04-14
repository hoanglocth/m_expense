import 'package:m_expense/database/Repository.dart';
import 'package:m_expense/models/TripModel.dart';

class TripService {
  late Repository _repository;

  TripService() {
    _repository = Repository();
  }

  //Save Trip to sqlite
  saveTrip(TripModel tripModel) async {
    return await _repository.insertTrip('trip_table', tripModel.tripMap());
  }
  //Read All Trips from sqlite
  readAllTrip() async {
    return await _repository.readTrip('trip_table');
  }
  //Delete Trip by id from sqlite
  deleteTripById(tripId) async {
    return await _repository.deleteTripById('trip_table', tripId);
  }
}
