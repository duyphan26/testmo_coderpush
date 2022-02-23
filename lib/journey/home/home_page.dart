import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testmo_coderpush/blocs/base/event_bus.dart';
import 'package:testmo_coderpush/blocs/blocs.dart';
import 'package:testmo_coderpush/constants/constants.dart';
import 'package:testmo_coderpush/journey/common/load_tinder_layout.dart';
import 'package:testmo_coderpush/repository/models/models.dart';
import 'package:testmo_coderpush/widgets/widgets.dart';
import 'package:testmo_coderpush/common/common.dart';

import 'home_tinder_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MatchEngine? _matchEngine;
  ValueNotifier<SlideRegion?> _region = ValueNotifier<SlideRegion?>(null);

  void _onMatchEngineIsReady(MatchEngine engine) {
    setState(() {
      _matchEngine = engine;
    });
  }

  void _onLikeComplete(User user) {
    final latestUser = EventBus()
        .blocFromKey<PeopleBloc>(Keys.Blocs.peopleBloc(user.id))!
        .state
        .user;

    EventBus().event<ManageActionBloc>(
      Keys.Blocs.manageActionBloc,
      ManageActionLikeStarted(latestUser),
    );
  }

  void _onNopeComplete(User user) {
    final latestUser = EventBus()
        .blocFromKey<PeopleBloc>(Keys.Blocs.peopleBloc(user.id))!
        .state
        .user;

    EventBus().event<ManageActionBloc>(
      Keys.Blocs.manageActionBloc,
      ManageActionNopeStarted(latestUser),
    );
  }

  void _onSuperLikeComplete(User user) {
    final latestUser = EventBus()
        .blocFromKey<PeopleBloc>(Keys.Blocs.peopleBloc(user.id))!
        .state
        .user;

    EventBus().event<ManageActionBloc>(
      Keys.Blocs.manageActionBloc,
      ManageActionSuperLikeStarted(latestUser),
    );
  }

  void _handleItemChanged(User user) {
    EventBus().event<PeopleBloc>(
      Keys.Blocs.peopleBloc(user.id),
      PeopleLoadDetailInfoStarted(),
    );
  }

  void _navigateListPage(List<User> users) {
    if (users.isNotEmpty) {
      Navigator.of(context).pushNamed(
        Screens.usersTarget,
        arguments: {
          HomePageParamsKey.usersTarget: users,
        },
      );
    }
  }

  void _onSlideRegionUpdate(SlideRegion? region) {
    if (_region.value != region) {
      _region.value = region;
    }
  }

  void _handleNopeTapped() {
    _matchEngine!.currentItem?.setNope();
  }

  void _handleSuperLikeTapped() {
    _matchEngine!.currentItem?.setSuperLike();
  }

  void _handleLikeTapped() {
    _matchEngine!.currentItem?.setLike();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ManageActionBloc, ManageActionState>(
          listener: (_, state) {},
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Stack(
            children: [
              Positioned(
                top: context.queryPaddingTop + 20.0,
                left: 0.0,
                right: 0.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 12.0,
                      ),
                      child: Text(
                        'HOME',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 40.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: LoadTinderLayout<User>(
                  blocKey: Keys.Blocs.peopleListBloc,
                  params: {
                    LoadListInteractorParamsKey.limit: ListSetting.limit,
                  },
                  onMatchEngineIsReady: _onMatchEngineIsReady,
                  onLikeComplete: _onLikeComplete,
                  onNopeComplete: _onNopeComplete,
                  onSuperLikeComplete: _onSuperLikeComplete,
                  itemChanged: _handleItemChanged,
                  onSlideRegionUpdate: _onSlideRegionUpdate,
                  itemFrontBuilder: (user, _) {
                    return ValueListenableBuilder<SlideRegion?>(
                      valueListenable: _region,
                      builder: (_, region, ___) {
                        return HomeTinderFrontItem(
                          Key('$homeTinderFrontItemKey'
                              '${user.id}'),
                          user: user,
                          region: region,
                        );
                      },
                    );
                  },
                  itemBackBuilder: (user, _) {
                    return HomeTinderBackItem(
                      const Key(homeTinderBackItemKey),
                      user: user,
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 10.0,
                left: 0.0,
                right: 0.0,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: _handleNopeTapped,
                          borderRadius: BorderRadius.circular(56.0),
                          child: Container(
                            width: 56.0,
                            height: 56.0,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.0,
                                color: Colors.red,
                                style: BorderStyle.solid,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 36.0,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: _handleSuperLikeTapped,
                          borderRadius: BorderRadius.circular(56.0),
                          child: Container(
                            width: 56.0,
                            height: 56.0,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.0,
                                color: Colors.blue,
                                style: BorderStyle.solid,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.star,
                              size: 36.0,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: _handleLikeTapped,
                          borderRadius: BorderRadius.circular(56.0),
                          child: Container(
                            width: 56.0,
                            height: 56.0,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.0,
                                color: Colors.green,
                                style: BorderStyle.solid,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.ac_unit,
                              size: 36.0,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    BlocBuilder<ManageActionBloc, ManageActionState>(
                      builder: (_, state) {
                        var likedTextSuffix = '(${state.likedUsers.length})';
                        if (state is ManageActionLikeCompleteRunInProgress) {
                          likedTextSuffix = '...';
                        }

                        return Container(
                          color: Colors.grey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: state.nopeUsers.isNotEmpty
                                    ? () => _navigateListPage(state.nopeUsers)
                                    : () {},
                                child: Text(
                                    'Nope List (${state.nopeUsers.length})'),
                              ),
                              ElevatedButton(
                                onPressed: state.likedUsers.isNotEmpty
                                    ? () => _navigateListPage(state.likedUsers)
                                    : () {},
                                child: Text('Liked List $likedTextSuffix'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
