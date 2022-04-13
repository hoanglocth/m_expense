class TripModel{
  int? idTrip;
  String? nameTrip;
  String? destinationTrip;
  String? dateTrip;
  String? riskTrip;
  String? descriptionTrip;
  tripMap() {
    var mapping = <String, dynamic>{};
    mapping['id_trip'] = idTrip?? null;
    mapping['name_trip'] = nameTrip!;
    mapping['destination_trip'] = destinationTrip!;
    mapping['date_trip'] = dateTrip!;
    mapping['risk_trip'] = riskTrip!;
    mapping['description_trip'] = descriptionTrip!;
    return mapping;
  }
}