import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:myapp/blocs/app_bloc.dart';
import 'package:myapp/blocs/bloc_provider.dart';
import 'package:myapp/widgets/third_screen.dart';

import '../../mocks/bloc_test.mocks.dart';

void main() {
  group("Test ThirdScreen", () {
    late AppBloc mockAppBloc;

    setUp(() async {
      mockAppBloc = MockAppBloc();
    });

    testWidgets(
      "User should enter the amount he/she wants to send.",
      (widgetTester) async {
        // mock [mockAppBloc.balance]
        when(mockAppBloc.balance).thenAnswer((_) {
          return ValueNotifier<num>(5000);
        });

        await widgetTester.pumpWidget(
          BlocProvider(
            bloc: mockAppBloc,
            child: MaterialApp(
              home: Material(
                child: Builder(
                  builder: (context) {
                    return Center(child: ThirdScreen());
                  },
                ),
              ),
            ),
          ),
        );

        // find textField
        Finder textField = find.byKey(const Key("AMOUNT_TEXTFIELD"));

        // tap textField
        await widgetTester.tap(textField);

        // wait for all animations to complete
        await widgetTester.pumpAndSettle();

        // test
        await expectLater(
          find.byType(ThirdScreen),
          matchesGoldenFile("goldens/show_input.png"),
        );
      },
    );
  });
}
