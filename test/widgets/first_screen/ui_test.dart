import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/blocs/app_bloc.dart';
import 'package:myapp/blocs/bloc_provider.dart';
import 'package:myapp/widgets/first_screen.dart';

import '../../mocks/bloc_test.mocks.dart';

void main() {
  group("Test FirstScreen", () {
    late AppBloc mockAppBloc;

    setUp(() async {
      mockAppBloc = MockAppBloc();
    });

    testWidgets(
      "should display Username & Password textfields, and Login button",
      (widgetTester) async {
        await widgetTester.pumpWidget(
          MaterialApp(
            home: Material(
              child: Center(
                child: BlocProvider(bloc: mockAppBloc, child: FirstScreen()),
              ),
            ),
          ),
        );

        // test
        await expectLater(
          find.byType(FirstScreen),
          matchesGoldenFile("goldens/no_input.png"),
        );
      },
    );
  });
}
