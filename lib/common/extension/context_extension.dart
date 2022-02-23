import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension BuildContextCommonExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQueryData.fromWindow(ui.window);

  ThemeData get themeData => Theme.of(this);

  double get queryWidth => mediaQuery.size.width;

  double get queryHeight => mediaQuery.size.height;

  double get queryPaddingTop => mediaQuery.padding.top;

  bool hasBloc<T extends Bloc>() {
    try {
      final _ = BlocProvider.of<T>(this);
      return true;
    } catch (_) {}
    return false;
  }
}