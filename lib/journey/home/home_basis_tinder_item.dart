import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testmo_coderpush/blocs/blocs.dart';
import 'package:testmo_coderpush/common/common.dart';
import 'package:testmo_coderpush/repository/models/models.dart';
import 'package:testmo_coderpush/models/models.dart';
import 'package:testmo_coderpush/widgets/widgets.dart';

class _ItemLayout extends StatelessWidget {
  final User user;
  final SlideRegion? region;

  _ItemLayout({
    Key? key,
    required this.user,
    required this.region,
  }) : super(key: key);

  Widget _buildRegionText(BuildContext context) {
    if (region == SlideRegion.inNope) {
      return Positioned(
        right: 10.0,
        child: Transform(
          transform: Matrix4.skewY(0.3)..rotateZ(3.14 / 12.0),
          origin: const Offset(0.0, 20.0),
          child: Container(
            height: 60.0,
            width: 100.0,
            decoration: BoxDecoration(
              border: Border.all(
                width: 3.0,
                color: Colors.red,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: const Center(
              child: Text(
                'NOPE',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 32.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (region == SlideRegion.inLike) {
      return Positioned(
        left: 10.0,
        child: Transform(
          transform: Matrix4.skewY(-0.3)..rotateZ(-3.14 / 12.0),
          origin: const Offset(100.0, 20.0),
          child: Container(
            height: 60.0,
            width: 100.0,
            decoration: BoxDecoration(
              border: Border.all(
                width: 3.0,
                color: Colors.green,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: const Center(
              child: Text(
                'LIKE',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 32.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (region == SlideRegion.inSuperLike) {
      return Positioned(
        bottom: 100.0,
        left: context.queryWidth / 2 - 60.0,
        child: Transform(
          transform: Matrix4.skewY(-0.1)..rotateZ(-3.14 / 12.0),
          origin: const Offset(20.0, 50.0),
          child: Container(
            height: 80.0,
            width: 120.0,
            decoration: BoxDecoration(
              border: Border.all(
                width: 3.0,
                color: Colors.blue,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: const Center(
              child: Text(
                'SUPER\nLIKE',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 32.0,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: NetworkImage(user.picture),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.black,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.6, 1],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 16.0,
                left: 4.0,
                right: 4.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            user.toFullName,
                            style: const TextStyle(
                              fontSize: 36,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 2,
                          ),
                        ),
                        if (user.dateOfBirth != null)
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 6.0,
                            ),
                            child: Text(
                              '${user.toAge}',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        const SizedBox(
                          width: 40.0,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 2.0,
                    ),
                    Row(
                      children: [
                        Container(
                          width: 10.0,
                          height: 10.0,
                          margin: const EdgeInsets.only(
                            left: 4.0,
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(
                          width: 6.0,
                        ),
                        const Text(
                          'Recently Active',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (region != null) _buildRegionText(context),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeBasisTinderItem extends StatelessWidget {
  final User user;
  final SlideRegion? region;

  HomeBasisTinderItem({
    Key? key,
    required this.user,
    required this.region,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return context.hasBloc<PeopleBloc>()
        ? BlocConsumer<PeopleBloc, PeopleState>(
            listener: (_, state) {},
            buildWhen: (_, current) =>
                current is PeopleRunInitial ||
                current is PeopleLoadDetailInfoRunSuccess,
            builder: (context, state) => _ItemLayout(
              user: state.user,
              region: region,
            ),
          )
        : _ItemLayout(
            user: user,
            region: region,
          );
  }
}
