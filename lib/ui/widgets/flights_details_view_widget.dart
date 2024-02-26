import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/sse_cubit.dart';
import '../../models/flight/flight_model.dart';

class FlightDetailsView extends StatelessWidget {
  const FlightDetailsView({
    super.key,
    required this.flightNumber,
    required this.onClose,
  });

  final VoidCallback onClose;
  final String flightNumber;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<SseCubit, SseState>(builder: (context, state) {
        if (state.events.isEmpty) {
          return const Center(
            child: Text("No flights available"),
          );
        }
        if (!(state.events.containsKey(flightNumber))) {
          return const Center(
            child: Text("Flight's details not found"),
          );
        }
        Flight flightDetails = state.events[flightNumber]!.flight;
        return SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                        onPressed: onClose,
                        icon: const Icon(Icons.close_rounded)),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Flight details",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
              Divider(
                color: Theme.of(context).colorScheme.secondary,
              ),
              Text(
                "${flightDetails.number}${flightDetails.callSign != "unknown" ? " [${flightDetails.callSign}]" : ""}",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                "${flightDetails.fromIcao} -> ${flightDetails.toIcao}",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              ListTile(
                title: Text(flightDetails.status),
                subtitle: const Text("Flight status"),
                leading: const Icon(Icons.flight_rounded),
              ),
              ListTile(
                title: Text(
                    "${flightDetails.departureDelay?.inMinutes ?? "unknown"} min"),
                subtitle: const Text("Departure delay"),
                leading: const Icon(Icons.flight_takeoff_rounded),
              ),
              ListTile(
                leading: const Icon(Icons.flight_land_rounded),
                title: Text(
                    "${flightDetails.arrivalDelay?.inMinutes ?? "unknown"} min"),
                subtitle: const Text("Arrival delay"),
              ),
              ExpansionTile(
                title: const Text("Departure details"),
                children: [
                  ListTile(
                    leading: const Icon(Icons.location_city_rounded),
                    title:
                        Text(flightDetails.departure.airport.municipalityName),
                    subtitle: const Text("Location"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.flight_rounded),
                    title: Text(
                        "${flightDetails.departure.airport.name} - ${flightDetails.departure.airport.icao} (${flightDetails.departure.airport.iata})"),
                    subtitle: const Text("Airport"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.connecting_airports_rounded),
                    title: Text(flightDetails.departure.terminal),
                    subtitle: const Text("Terminal"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.desk_rounded),
                    title: Text(flightDetails.departure.gate),
                    subtitle: const Text("Gate"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.airplane_ticket_rounded),
                    title: Text(flightDetails.departure.checkInDesk),
                    subtitle: const Text("CheckIn desk"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.timelapse_rounded),
                    title: Text(
                        "${flightDetails.departure.scheduledTime.utc ?? "unknown"}"),
                    subtitle: const Text("Scheduled time"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.share_arrival_time_rounded),
                    title: Text(
                        "${flightDetails.departure.revisedTime.utc ?? "unknown"}"),
                    subtitle: const Text("Revised time"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.flight_takeoff_rounded),
                    title: Text(
                        "${flightDetails.departure.runwayTime.utc ?? "unknown"}"),
                    subtitle: const Text("Runway time"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.stream_rounded),
                    title: Text(flightDetails.arrival.quality.map((e) => e.name).join(", ")),
                    subtitle: const Text("Live stream quality"),
                  ),
                ],
              ),
              ExpansionTile(
                title: const Text("Arrival details"),
                children: [
                  ListTile(
                    leading: const Icon(Icons.location_city_rounded),
                    title: Text(flightDetails.arrival.airport.municipalityName),
                    subtitle: const Text("Location"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.flight_rounded),
                    title: Text(
                        "${flightDetails.arrival.airport.name} - ${flightDetails.departure.airport.icao} (${flightDetails.departure.airport.iata})"),
                    subtitle: const Text("Airport"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.connecting_airports_rounded),
                    title: Text(flightDetails.arrival.terminal),
                    subtitle: const Text("Terminal"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.desk_rounded),
                    title: Text(flightDetails.arrival.gate),
                    subtitle: const Text("Gate"),
                  ),
                  ListTile(
                    title: Text(flightDetails.arrival.baggageBelt),
                    subtitle: const Text("Baggage belt"),
                    leading: const Icon(Icons.luggage_rounded),
                  ),
                  ListTile(
                    leading: const Icon(Icons.timelapse_rounded),
                    title: Text(
                        "${flightDetails.arrival.scheduledTime.utc ?? "unknown"}"),
                    subtitle: const Text("Scheduled time"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.share_arrival_time_rounded),
                    title: Text(
                        "${flightDetails.arrival.revisedTime.utc ?? "unknown"}"),
                    subtitle: const Text("Revised time"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.flight_land_rounded),
                    title: Text(
                        "${flightDetails.arrival.runwayTime.utc ?? "unknown"}"),
                    subtitle: const Text("Runway time"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.stream_rounded),
                    title: Text(flightDetails.arrival.quality.map((e) => e.name).join(", ")),
                    subtitle: const Text("Live stream quality"),
                  ),
                ],
              ),
              ExpansionTile(
                title: const Text("Aircraft details"),
                children: [
                  ListTile(
                    title: Text(flightDetails.aircraft.reg),
                    subtitle: const Text("Aircraft registration number"),
                  ),
                  ListTile(
                    title: Text(flightDetails.aircraft.model),
                    subtitle: const Text("Aircraft model"),
                  ),
                  /*ListTile(
                    title: Text(flightDetails.aircraft.modeS),
                    subtitle: const Text("Aircraft modeS"),
                  ),*/
                ],
              ),
              ExpansionTile(
                title: const Text("Airline details"),
                children: [
                  ListTile(
                    title: Text(flightDetails.airline.name),
                    subtitle: const Text("Airline name"),
                  ),
                  ListTile(
                    title: Text(flightDetails.airline.icao),
                    subtitle: const Text("Airline ICAO"),
                  ),
                  ListTile(
                    title: Text(flightDetails.airline.iata),
                    subtitle: const Text("Airline IATA"),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
