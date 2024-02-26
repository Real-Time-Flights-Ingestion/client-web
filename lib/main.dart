import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import 'cubits/sse_cubit.dart';
import 'cubits/sse_settings_cubit.dart';
import 'ui/screens/dashboard_screen.dart';

void main() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    if (kDebugMode) {
      print(
          '(${record.sequenceNumber}) [${record.time}] ${record.loggerName} - ${record.level.name.toUpperCase()}: ${record.message} | ${record.error ?? ""}\n${record.stackTrace ?? ""}');
    }
  });
  runApp(const RtfiApp());
}

class RtfiApp extends StatelessWidget {
  const RtfiApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData darkThemeData = FlexThemeData.dark(
      scheme: FlexScheme.outerSpace,
      useMaterial3: true,
    );
    ThemeData lightThemeData = FlexThemeData.light(
      scheme: FlexScheme.outerSpace,
      useMaterial3: true,
    );
    return MaterialApp(
      title: 'RTFI Web Client',
      theme: FlexThemeData.light(
        scheme: FlexScheme.outerSpace,
        useMaterial3: true,
      ).copyWith(
          listTileTheme: lightThemeData.listTileTheme.copyWith(
              subtitleTextStyle: lightThemeData.textTheme.labelMedium
                  ?.copyWith(color: lightThemeData.colorScheme.secondary))),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.outerSpace,
        useMaterial3: true,
      ).copyWith(
          listTileTheme: darkThemeData.listTileTheme.copyWith(
              subtitleTextStyle: darkThemeData.textTheme.labelMedium
                  ?.copyWith(color: darkThemeData.colorScheme.secondary))),
      themeMode: ThemeMode.system,
      home: MultiBlocProvider(providers: [
        BlocProvider(
          create: (BuildContext context) => SseCubit(),
        ),
        BlocProvider(create: (BuildContext context) => SseSettingsCubit())
      ], child: const DashboardScreen()),
    );
  }
}
