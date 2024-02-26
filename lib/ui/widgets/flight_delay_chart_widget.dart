import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../cubits/sse_cubit.dart';
import '../../models/flight_event.dart';

class FlightDelayChartColumn extends StatelessWidget {
  const FlightDelayChartColumn({
    super.key,
    required this.onPointTap,
  });

  final Function({required String flightNumber}) onPointTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            "Arrivals Delay Chart",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        FlightDelayChart(
          arrivalDelay: true,
          onPointTap: onPointTap,
        ),
        const SizedBox(
          height: 22,
        ),
        Center(
          child: Text(
            "Departures Delay Chart",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        FlightDelayChart(
          arrivalDelay: false,
          onPointTap: onPointTap,
        ),
        const SizedBox(
          height: 22,
        ),
      ],
    );
  }
}

class FlightDelayChart extends StatefulWidget {
  const FlightDelayChart({
    super.key,
    required this.arrivalDelay,
    required this.onPointTap,
  });

  final bool arrivalDelay;

  final Function({required String flightNumber}) onPointTap;

  @override
  State<FlightDelayChart> createState() => _FlightDelayChartState();
}

class _FlightDelayChartState extends State<FlightDelayChart> {
  final ZoomPanBehavior _zoomPanBehavior = ZoomPanBehavior(
    enableMouseWheelZooming: false,
    enablePanning: true,
    enablePinching: true,
  );

  final TooltipBehavior _tooltipBehavior = TooltipBehavior(
    enable: true,
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SseCubit, SseState>(
      builder: (BuildContext context, SseState state) {
        List<FlightEvent> events = state.events.values.toList();
        return Row(
          children: [
            Expanded(
              child: SfCartesianChart(
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
                          widget.onPointTap(
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
                      name: widget.arrivalDelay
                          ? "Arrivals delay"
                          : "Departures delay",
                      xValueMapper: (FlightEvent event, _) =>
                          event.flight.number,
                      yValueMapper: (FlightEvent event, _) =>
                          widget.arrivalDelay
                              ? event.flight.arrivalDelay?.inMinutes ?? 0
                              : event.flight.departureDelay?.inMinutes ?? 0,
                      dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          textStyle: Theme.of(context).textTheme.labelSmall),
                      dataLabelMapper: (FlightEvent event, int index) {
                        if (widget.arrivalDelay) {
                          return "${event.flight.arrivalDelay?.inMinutes ?? "unk"}";
                        }
                        return "${event.flight.departureDelay?.inMinutes ?? "unk"}";
                      },
                    )
                  ]),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    _zoomPanBehavior.zoomIn();
                  },
                  icon: const Icon(Icons.zoom_in_rounded),
                ),
                IconButton(
                  onPressed: () {
                    _zoomPanBehavior.zoomOut();
                  },
                  icon: const Icon(Icons.zoom_out_rounded),
                ),
                IconButton(
                  onPressed: () {
                    _zoomPanBehavior.reset();
                  },
                  icon: const Icon(Icons.refresh_rounded),
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
