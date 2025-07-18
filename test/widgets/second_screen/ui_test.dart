import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:myapp/blocs/app_bloc.dart';
import 'package:myapp/blocs/bloc_provider.dart';
import 'package:myapp/widgets/second_screen.dart';

import '../../mocks/bloc_test.mocks.dart';

void main() {
  group("Test SecondScreen", () {
    late AppBloc mockAppBloc;

    setUp(() async {
      mockAppBloc = MockAppBloc();
    });

    testWidgets(
      "should display current balance, Send Money, View Transactions & Logout buttons",
      (widgetTester) async {
        // mock [mockAppBloc.balance]
        when(mockAppBloc.balance).thenAnswer((_) {
          return ValueNotifier<num>(5000);
        });

        await widgetTester.pumpWidget(
          MaterialApp(
            home: Material(
              child: Center(
                child: BlocProvider(bloc: mockAppBloc, child: SecondScreen()),
              ),
            ),
          ),
        );

        // test
        await expectLater(
          find.byType(SecondScreen),
          matchesGoldenFile("goldens/show_balance.png"),
        );
      },
    );
  });
}
