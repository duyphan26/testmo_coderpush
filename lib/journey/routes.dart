import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testmo_coderpush/blocs/base/event_bus.dart';
import 'package:testmo_coderpush/blocs/blocs.dart';
import 'package:testmo_coderpush/common/common.dart';
import 'package:testmo_coderpush/constants/constants.dart';
import 'package:testmo_coderpush/global/global.dart';
import 'package:testmo_coderpush/journey/home/home_page.dart';
import 'package:testmo_coderpush/journey/home/users_target/users_target_page.dart';
import 'package:testmo_coderpush/repository/models/models.dart';
import 'package:testmo_coderpush/splash_page.dart';

class Routes {
  static Map<String, WidgetBuilder> allRoutes(BuildContext context) {
    return {
      Screens.splash: (_) => const SplashPage(),
      Screens.home: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<LoadListBloc<User>>(
              create: (context) =>
                  EventBus().newBlocWithConstructor<LoadListBloc<User>>(
                Keys.Blocs.peopleListBloc,
                () => LoadListBloc<User>(
                  Keys.Blocs.peopleListBloc,
                  loadListInteractor: Provider().userInteractor,
                ),
              ),
            ),
            BlocProvider<ManageActionBloc>(
              create: (_) => ManageActionBloc.instance(),
            ),
          ],
          child: const HomePage(),
        );
      },
      Screens.usersTarget: (context) {
        final arguments = asT<Map<String, dynamic>>(
                ModalRoute.of(context)?.settings.arguments) ??
            {};
        final List<User> users = arguments[HomePageParamsKey.usersTarget];

        return UsersTargetPage(
          users: users,
        );
      },
    };
  }
}
