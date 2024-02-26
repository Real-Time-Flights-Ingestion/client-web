import 'package:flutter/material.dart';

class MapLegendBox extends StatelessWidget {
  const MapLegendBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Flight types",
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.green[800], shape: BoxShape.circle),
                    width: 14,
                    height: 14,
                  ),
                ),
                const Text("Departures")
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.deepOrangeAccent, shape: BoxShape.circle),
                  width: 14,
                  height: 14,
                ),
              ),
              const Text("Arrivals")
            ],
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Flight status",
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: Icon(Icons.question_mark_rounded),
                ),
                Text("Unknown")
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: Icon(Icons.airplane_ticket_rounded),
                ),
                Text("At airport")
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: Icon(Icons.flight_takeoff_rounded),
                ),
                Text("Airborne")
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: Icon(Icons.flight_land_rounded),
                ),
                Text("Landed")
              ],
            ),
          ),
        ],
      ),
    );
  }
}
