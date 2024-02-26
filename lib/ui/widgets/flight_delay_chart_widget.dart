import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../cubits/sse_cubit.dart';
import '../../models/flight_event.dart';

class FlightDelayChartRow extends StatelessWidget {
  const FlightDelayChartRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: FlightDelayChart(arrivalDelay: true),
        ),
        SizedBox(
          width: 22,
        ),
        Expanded(
          child: FlightDelayChart(
            arrivalDelay: false,
          ),
        ),
      ],
    );
  }
}

class FlightDelayChart extends StatelessWidget {
  const FlightDelayChart({
    super.key,
    required this.arrivalDelay,
  });

  final bool arrivalDelay;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SseCubit, SseState>(
      builder: (BuildContext context, SseState state) {
        List<FlightEvent> events = state.events.values.toList();
        return SfCartesianChart(primaryXAxis: const CategoryAxis(), series: [
          FastLineSeries<FlightEvent, String>(
              dataSource: events,
              xValueMapper: (FlightEvent event, _) => event.flight.number,
              yValueMapper: (FlightEvent event, _) => arrivalDelay
                  ? event.flight.arrivalDelay?.inMinutes ?? 0
                  : event.flight.departureDelay?.inMinutes ?? 0)
        ]);
      },
    );
  }
}
