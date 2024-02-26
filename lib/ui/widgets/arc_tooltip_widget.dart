part of 'map_chart_widget.dart';

class ArcTooltip extends StatelessWidget {
  const ArcTooltip({
    super.key,
    required this.route,
  });

  final Flight route;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: (route.isArrived ?? false)
                    ? const Icon(Icons.flight_land_rounded)
                    : (route.isAirborne ?? false)
                        ? const Icon(Icons.flight_takeoff_rounded)
                        : (route.notDepartedYet ?? false)
                            ? const Icon(Icons.airplane_ticket_rounded)
                            : const Icon(Icons.question_mark_rounded),
              ),
              Text(
                "${route.number} | ${route.departure.airport.icao} -> ${route.arrival.airport.icao}",
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize),
              ),
            ],
          ),
          Divider(color: Theme.of(context).colorScheme.onSecondaryContainer),
          Text(
              "Departure delay : ${route.departureDelay?.inMinutes ?? "unknown"} min"),
          Text(
              "Arrival delay : ${route.arrivalDelay?.inMinutes ?? "unknown"} min"),
        ],
      ),
    );
  }
}
