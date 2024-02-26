import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtfi_client_web/models/airports_icao_enum.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../cubits/sse_cubit.dart';
import '../../cubits/sse_settings_cubit.dart';

class DashboardControls extends StatelessWidget {
  const DashboardControls({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Tooltip(
            message: "Tells the application to stop or to continuously update the ui",
            child: BlocBuilder<SseCubit, SseState>(
            builder: (BuildContext context, SseState state) {
              return Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 12.0),
                    child: Text("RealTime UI controls"),
                  ),
                  IconButton(
                      onPressed: state is! SseListeningState
                          ? () {
                              context.read<SseCubit>().playStream();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                width: 400,
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                content: Text(
                                  "RealTime UI started",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer),
                                ),
                                behavior: SnackBarBehavior.floating,
                              ));
                            }
                          : null,
                      icon: const Icon(Icons.play_arrow_rounded)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: IconButton(
                        onPressed: state is SseListeningState
                            ? () {
                                context.read<SseCubit>().pauseStream();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  width: 400,
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  content: Text(
                                    "RealTime UI paused",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimaryContainer),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ));
                              }
                            : null,
                        icon: const Icon(Icons.pause_rounded)),
                  ),
                  IconButton(
                      onPressed: state is! SseInitialState
                          ? () {
                              context
                                  .read<SseCubit>()
                                  .restartStream()
                                  .then((value) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  width: 400,
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  content: Text(
                                    "RealTime UI restarted",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimaryContainer),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ));
                              });
                            }
                          : null,
                      icon: const Icon(Icons.restart_alt_rounded)),
                ],
              );
            },
          ),
          ),
        ),
        Expanded(
          child: Tooltip(
            message: "Tells the application to listen or not for new flights for the selected airport",
            child: BlocBuilder<SseSettingsCubit, SseSettingsState>(
              builder: (context, state) {
                return Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 12.0),
                      child: Text("Source Stream controls"),
                    ),
                    DropdownButton(
                        items: AirportsIcao.values
                            .map((e) => DropdownMenuItem<AirportsIcao>(
                                  value: e,
                                  child: Text(e.name.toUpperCase()),
                                ))
                            .toList(),
                        value: state.currentIcao,
                        onChanged: (e) async {
                          await context
                              .read<SseCubit>()
                              .restartStream()
                              .then((value) {
                            context
                                .read<SseSettingsCubit>()
                                .changeAirport(icao: e ?? AirportsIcao.ellx);
                            context.read<SseCubit>().playStream();
                          });
                        }),
                    IconButton(
                        onPressed: state is! SseSettingsPlayingStream
                            ? () {
                                context
                                    .read<SseSettingsCubit>()
                                    .playSourceStream();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  width: 400,
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  content: Text(
                                    "Source Stream started",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimaryContainer),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ));
                              }
                            : null,
                        icon: const Icon(Icons.play_arrow_rounded)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: IconButton(
                          onPressed: state is SseSettingsPlayingStream
                              ? () {
                                  context
                                      .read<SseSettingsCubit>()
                                      .pauseSourceStream();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    width: 400,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    content: Text(
                                      "Source Stream paused",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimaryContainer),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                  ));
                                }
                              : null,
                          icon: const Icon(Icons.pause_rounded)),
                    ),
                    IconButton(
                        onPressed: state is! SseSettingsInitial
                            ? () {
                                context.read<SseSettingsCubit>().clearCache();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  width: 400,
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  content: Text(
                                    "Source Stream cache cleared",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimaryContainer),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ));
                              }
                            : null,
                        tooltip: "Clear Source Stream cache",
                        icon: const Icon(Icons.clear_all_rounded)),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
