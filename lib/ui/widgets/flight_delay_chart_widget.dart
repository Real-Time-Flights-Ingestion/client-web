import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../cubits/sse_cubit.dart';
import '../../models/flight_event.dart';

class FlightDelayChartRow extends StatelessWidget {
  const FlightDelayChartRow({
    super.key,
    required this.onPointTap,
  });

  final Function({required String flightNumber}) onPointTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FlightDelayChart(
            arrivalDelay: true,
            onPointTap: onPointTap,
          ),
        ),
        const SizedBox(
          width: 22,
        ),
        Expanded(
          child: FlightDelayChart(
            arrivalDelay: false,
            onPointTap: onPointTap,
          ),
        ),
      ],
    );
  }
}

class FlightDelayChart extends StatelessWidget {
  FlightDelayChart({
    super.key,
    required this.arrivalDelay,
    required this.onPointTap,
  });

  final bool arrivalDelay;

  final Function({required String flightNumber}) onPointTap;

  final ZoomPanBehavior _zoomPanBehavior = ZoomPanBehavior(
    enableMouseWheelZooming: true,
  );

  final TooltipBehavior _tooltipBehavior = TooltipBehavior(
    enable: true,
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SseCubit, SseState>(
      builder: (BuildContext context, SseState state) {
        List<FlightEvent> events = state.events.values.toList();
        return SfCartesianChart(
            title: ChartTitle(
                text: arrivalDelay ? "Arrivals delay" : "Departures delay"),
            primaryXAxis: const CategoryAxis(
              title: AxisTitle(text: "Flights"),
              labelPlacement: LabelPlacement.onTicks,
              labelPosition: ChartDataLabelPosition.outside,
              labelRotation: 45,
              edgeLabelPlacement: EdgeLabelPlacement.shift,
              interval: 1,
            ),
            primaryYAxis: const NumericAxis(
              title: AxisTitle(text: "Delay in minutes"),
              labelPosition: ChartDataLabelPosition.outside,
              edgeLabelPlacement: EdgeLabelPlacement.shift,
            ),
            zoomPanBehavior: _zoomPanBehavior,
            tooltipBehavior: _tooltipBehavior,
            series: [
              FastLineSeries<FlightEvent, String>(
                dataSource: events,
                trendlines: [
                  Trendline(
                      type: TrendlineType.linear,
                      color: Theme.of(context).colorScheme.secondary,
                      dashArray: const [12, 8]),
                ],
                onPointTap: (ChartPointDetails details) {
                  if (details.pointIndex != null) {
                    onPointTap(
                        flightNumber: events
                            .elementAt(details.pointIndex!)
                            .flight
                            .number);
                  }
                },
                markerSettings: MarkerSettings(
                  isVisible: true,
                  borderColor: Theme.of(context).colorScheme.onSurface,
                  borderWidth: 1,
                ),
                name: arrivalDelay ? "Arrivals delay" : "Departures delay",
                xValueMapper: (FlightEvent event, _) => event.flight.number,
                yValueMapper: (FlightEvent event, _) => arrivalDelay
                    ? event.flight.arrivalDelay?.inMinutes ?? 0
                    : event.flight.departureDelay?.inMinutes ?? 0,
                dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    textStyle: Theme.of(context).textTheme.labelSmall),
                dataLabelMapper: (FlightEvent event, int index) {
                  if (arrivalDelay) {
                    return "${event.flight.arrivalDelay?.inMinutes ?? "unk"}";
                  }
                  return "${event.flight.departureDelay?.inMinutes ?? "unk"}";
                },
              )
            ]);
      },
    );
  }
}
