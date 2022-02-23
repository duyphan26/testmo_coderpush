import 'package:flutter/material.dart';
import 'package:testmo_coderpush/constants/constants.dart';
import 'package:testmo_coderpush/mixins/mixins.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with WidgetDidMount<SplashPage> {
  @override
  void widgetDidMount(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pushReplacementNamed(Screens.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      drawerEdgeDragWidth: 0.0,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              Colors.pinkAccent,
              Colors.redAccent,
            ],
          ),
        ),
      ),
    );
  }
}
