import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import '../../cubits/sse_cubit.dart';
import '../../cubits/sse_settings_cubit.dart';
import '../../models/airport_model.dart';
import '../../models/airports_icao_enum.dart';
import '../../models/flight/flight_model.dart';
import '../../models/flight_event.dart';
import 'map_legend_box_widget.dart';

part 'airport_marker_tooltip_widget.dart';

part 'arc_tooltip_widget.dart';

class MapChart extends StatefulWidget {
  const MapChart({super.key, required this.callback});

  final Function({required String flightNumber}) callback;

  @override
  State<MapChart> createState() => _MapChartState();
}

const Map<AirportsIcao, MapLatLng> locations = {
  AirportsIcao.lirf: MapLatLng(41.8045, 12.2508),
  AirportsIcao.ellx: MapLatLng(49.6266, 6.21152),
  AirportsIcao.katl: MapLatLng(33.6367, -84.4281),
};

class _MapChartState extends State<MapChart> with TickerProviderStateMixin {
  final MapShapeLayerController _mapShapeLayerController =
      MapShapeLayerController();

  final Set<Airport> _markers = {};

  final Map<String, Flight> _routes = {};

  AirportsIcao _currentIcao = AirportsIcao.ellx;

  late MapShapeSource _dataSource;
  late AnimationController animationController;
  late Animation<double> animation;
  late final MapZoomPanBehavior _zoomPanBehavior = MapZoomPanBehavior(
    zoomLevel: 4,
    showToolbar: true,
    focalLatLng: locations[_currentIcao],
    toolbarSettings: MapToolbarSettings(
      position: MapToolbarPosition.topRight,
      direction: Axis.vertical,
      iconColor: Theme.of(context).colorScheme.onSecondaryContainer,
      itemBackgroundColor: Theme.of(context).colorScheme.secondaryContainer,
    ),
  );

  @override
  void initState() {
    _dataSource = const MapShapeSource.asset(
      'assets/test.geo.json',
      shapeDataField: 'name',
    );
    animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );
    animationController.forward(from: 0);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - (kToolbarHeight * 1.15),
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Material(
            color: const Color(0xff050A30),
            child: BlocListener<SseSettingsCubit, SseSettingsState>(
              listener: (context, state) {
                if (state.currentIcao != _currentIcao) {
                  setState(() {
                    _currentIcao = state.currentIcao;
                    _mapShapeLayerController.clearMarkers();
                    _markers.clear();
                    _routes.clear();
                    _zoomPanBehavior.focalLatLng = locations[_currentIcao];
                  });
                }
              },
              child: BlocListener<SseCubit, SseState>(
                listener: (context, state) {
                  if (state.events.isEmpty) return;
                  FlightEvent event = state.events.values.last;
                  if (_markers.add(event.flight.departure.airport)) {
                    _mapShapeLayerController.insertMarker(_markers.length - 1);
                  }
                  if (_markers.add(event.flight.arrival.airport)) {
                    _mapShapeLayerController.insertMarker(_markers.length - 1);
                  }
                  setState(() {
                    _routes[event.flight.number] = event.flight;
                  });
                  animationController.reset();
                  animationController.forward(from: 0);
                },
                child: SfMaps(
                  layers: [
                    MapShapeLayer(
                      source: _dataSource,
                      zoomPanBehavior: _zoomPanBehavior,
                      color: Colors.grey[800],
                      loadingBuilder: (_) => const CircularProgressIndicator(),
                      initialMarkersCount: 0,
                      showDataLabels: true,
                      dataLabelSettings: MapDataLabelSettings(
                          textStyle: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface),
                          overflowMode: MapLabelOverflow.hide),
                      selectionSettings: const MapSelectionSettings(),
                      controller: _mapShapeLayerController,
                      markerBuilder: (BuildContext context, int index) {
                        return MapMarker(
                          latitude: _markers.elementAt(index).location.lat,
                          longitude: _markers.elementAt(index).location.lon,
                          child: Icon(
                            Icons.location_on_rounded,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        );
                      },
                      markerTooltipBuilder: (BuildContext context, int index) {
                        return AirportMarkerTooltip(
                            marker: _markers.elementAt(index));
                      },
                      tooltipSettings: const MapTooltipSettings(
                          strokeColor: Colors.black, strokeWidth: 1.5),
                      sublayers: [
                        MapArcLayer(
                          arcs: _routes.values
                              .map((e) => MapArc(
                                  onTap: () {
                                    widget.callback(flightNumber: e.number);
                                  },
                                  from: e.fromLatLng,
                                  to: e.toLatLng,
                                  color: e.fromLatLng == locations[_currentIcao]
                                      ? Colors.green[800]
                                      : Colors.deepOrangeAccent,
                                  width: 2))
                              .toSet(),
                          animation: animation,
                          tooltipBuilder: (BuildContext context, int index) {
                            return ArcTooltip(
                              route: _routes.values.elementAt(index),
                              arrival:
                                  _routes.values.elementAt(index).toLatLng ==
                                      locations[_currentIcao],
                            );
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: MapLegendBox(),
          ),
        ],
      ),
    );
  }
}
