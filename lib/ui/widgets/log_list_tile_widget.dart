import 'package:flutter/material.dart';

import '../../models/flight_event.dart';

class FlightEventLogListTile extends StatelessWidget {
  const FlightEventLogListTile({
    super.key,
    required this.index,
    required this.e,
    required this.onTap,
  });

  final int index;
  final FlightEvent e;
  final Function({required String flightNumber}) onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTap(flightNumber: e.flight.number);
      },
      leading: Text("$index"),
      title: Text(
          "${e.flight.departure.airport.icao} -> ${e.flight.arrival.airport.icao}"),
      subtitle: Text(e.timestamp.toString()),
    );
  }
}
