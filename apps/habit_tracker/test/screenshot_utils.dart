import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Screenshots are only generated on demand:
/// `SCREENSHOTS=1 flutter test --update-goldens test/screenshot_test.dart`
final bool screenshotsEnabled = Platform.environment['SCREENSHOTS'] == '1';

/// Loads the real Roboto and Material Icons fonts shipped with the Flutter
/// SDK, so screenshots look like the app on a device instead of using the
/// blocky test font.
Future<void> loadRealFonts() async {
  final exe = Platform.resolvedExecutable;
  final cache = exe.substring(0, exe.indexOf('/bin/cache/') + 11);
  final dir = '${cache}artifacts/material_fonts';
  Future<ByteData> read(String name) async =>
      ByteData.sublistView(await File('$dir/$name').readAsBytes());

  final roboto = FontLoader('Roboto');
  for (final w in ['Regular', 'Medium', 'Bold']) {
    roboto.addFont(read('Roboto-$w.ttf'));
  }
  await roboto.load();
  await (FontLoader(
    'MaterialIcons',
  )..addFont(read('MaterialIcons-Regular.otf'))).load();
}

/// Runs [body] on a 390x844 phone (2x density) with shadows enabled.
Future<void> onPhone(WidgetTester tester, Future<void> Function() body) async {
  tester.view.physicalSize = const Size(780, 1688);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  debugDisableShadows = false;
  try {
    await body();
  } finally {
    debugDisableShadows = true;
  }
}
