import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

// Config file that is applied to all tests.

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    final Future<ByteData> font = rootBundle.load(
      "assets/fonts/roboto/Roboto-Regular.ttf",
    );
    final FontLoader fontLoader = FontLoader('Roboto')..addFont(font);
    await fontLoader.load();
  });

  await testMain();
}
