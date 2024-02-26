import 'package:flutter/material.dart';

import '../widgets/dashboard_controls_widget.dart';
import '../widgets/flight_delay_chart_widget.dart';
import '../widgets/flights_details_view_widget.dart';
import '../widgets/log_list_widget.dart';
import '../widgets/map_chart_widget.dart';
import '../widgets/message_stream_view_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _logsVisible = false;
  bool _detailsVisible = false;
  String _selectedFlightNumber = "";

  final ScrollController _logsScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("RTFI Real Time UI"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: _logsVisible,
              child: Expanded(
                flex: 2,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LogList(
                      logsScrollController: _logsScrollController,
                      onTap: _showDetails,
                    ),
                    const VerticalDivider(),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const DashboardControls(),
                    const Divider(),
                    const MessagesStreamView(),
                    const FlightDelayChartRow(),
                    MapChart(callback: _showDetails),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: _detailsVisible,
              child: Expanded(
                flex: 2,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const VerticalDivider(),
                    _selectedFlightNumber.isNotEmpty
                        ? FlightDetailsView(
                            flightNumber: _selectedFlightNumber,
                            onClose: () {
                              setState(() {
                                _detailsVisible = false;
                              });
                            },
                          )
                        : const Center(
                            child: Text("No flight selected"),
                          )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        onPressed: () {
          setState(() {
            _logsVisible = !_logsVisible;
          });
        },
        child: _logsVisible
            ? const Icon(Icons.close_rounded)
            : const Icon(Icons.text_snippet_rounded),
      ),
    );
  }

  _showDetails({required String flightNumber}) {
    setState(() {
      _selectedFlightNumber = flightNumber;
      _detailsVisible = true;
    });
  }
}
