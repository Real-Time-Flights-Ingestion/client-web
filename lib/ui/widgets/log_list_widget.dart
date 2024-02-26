import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/sse_cubit.dart';
import '../../models/flight_event.dart';
import 'log_list_tile_widget.dart';

class LogList extends StatelessWidget {
  const LogList({
    super.key,
    required ScrollController logsScrollController,
    required this.onTap,
  }) : _logsScrollController = logsScrollController;

  final ScrollController _logsScrollController;
  final Function({required String flightNumber}) onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<SseCubit, SseState>(
        builder: (context, state) {
          List<FlightEvent> reversedLogs =
              state.events.values.toList().reversed.toList();
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              controller: _logsScrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(top: 8, left: 8, bottom: 65),
              itemCount: reversedLogs.length,
              itemBuilder: (BuildContext context, int index) {
                FlightEvent e = reversedLogs[index];
                return FlightEventLogListTile(
                    onTap: onTap, index: reversedLogs.length - index, e: e);
              },
            ),
          );
        },
      ),
    );
  }
}
