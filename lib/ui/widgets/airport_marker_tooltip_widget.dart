part of 'map_chart_widget.dart';

class AirportMarkerTooltip extends StatelessWidget {
  const AirportMarkerTooltip({
    super.key,
    required this.marker,
  });

  final Airport marker;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              "${marker.shortName} - ${marker.icao} (${marker.iata})",
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize),
            ),
          ),
          Divider(
            color: Theme.of(context).colorScheme.onSecondaryContainer,
            height: 10,
            thickness: 1.2,
          ),
          Text(
            marker.municipalityName,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize),
          ),
        ],
      ),
    );
  }
}
