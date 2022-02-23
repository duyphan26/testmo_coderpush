import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testmo_coderpush/blocs/base/event_bus.dart';
import 'package:testmo_coderpush/blocs/blocs.dart';
import 'package:testmo_coderpush/constants/constants.dart';
import 'package:testmo_coderpush/global/global.dart';
import 'package:testmo_coderpush/journey/home/home_basis_tinder_item.dart';
import 'package:testmo_coderpush/repository/models/models.dart';
import 'package:testmo_coderpush/widgets/widgets.dart';

const String homeTinderFrontItemKey = 'home_tinder_front_item_';
const String homeTinderBackItemKey = 'home_tinder_back_item';

class HomeTinderBackItem extends StatelessWidget {
  HomeTinderBackItem(
    Key key, {
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return HomeBasisTinderItem(
      user: user,
      region: null,
    );
  }
}

class HomeTinderFrontItem extends StatelessWidget {
  HomeTinderFrontItem(
    Key key, {
    required this.user,
        required   this.region,
  }) : super(key: key);

  final User user;
  final SlideRegion? region;

  @override
  Widget build(BuildContext context) {
    final blocKey = Keys.Blocs.peopleBloc(user.id);
    return BlocProvider<PeopleBloc>(
      create: (_) => EventBus().newBlocWithConstructor<PeopleBloc>(
        blocKey,
        () => PeopleBloc(
          blocKey,
          initialUser: user,
          userInteractor: Provider().userInteractor,
        ),
      ),
      child: HomeBasisTinderItem(
        user: user,
        region: region,
      ),
    );
  }
}
