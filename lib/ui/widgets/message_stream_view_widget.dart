import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/sse_cubit.dart';
import '../../models/flight_event.dart';

class MessagesStreamView extends StatelessWidget {
  const MessagesStreamView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<SseCubit, SseState>(
        builder: (BuildContext context, state) {
          FlightEvent? last =
              state.events.isNotEmpty ? state.events.values.last : null;
          if (last == null) {
            return const Center(child: Text("Awaiting stream messages"));
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Stream messages received: ${state.events.length}',
              ),
              Text(
                  "New Flight: ${last.flight.fromIcao} -> ${last.flight.toIcao} [${last.timestamp.toString()}]"),
            ],
          );
        },
      ),
    );
  }
}
