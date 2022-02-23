import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testmo_coderpush/blocs/base/observer.dart';
import 'package:testmo_coderpush/blocs/blocs.dart';
import 'package:testmo_coderpush/constants/constants.dart';
import 'package:testmo_coderpush/global/global.dart';
import 'package:testmo_coderpush/journey/routes.dart';

Future<void> main() async {
  Bloc.observer = AppBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait<void>([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
  ]);

  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LaunchingBloc>(
          create: (_) =>
          LaunchingBloc.instance()..add(LaunchingPreloadDataStarted()),
        ),
      ],
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        navigatorObservers: [
          AppRouteObserver(),
          HeroController(),
        ],
        builder: (context, widget) {
          return MultiBlocListener(
            listeners: [
              BlocListener<LaunchingBloc, LaunchingState>(
                listener: (_, state) {},
              ),
            ],
            child: widget!,
          );
        },
        title: 'Test CoderPush',
        routes: Routes.allRoutes(context),
        initialRoute: Screens.splash,
      ),
    );
  }
}
