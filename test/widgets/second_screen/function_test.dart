import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:myapp/blocs/app_bloc.dart';
import 'package:myapp/blocs/bloc_provider.dart';
import 'package:myapp/widgets/fourth_screen.dart';
import 'package:myapp/widgets/second_screen.dart';
import 'package:myapp/widgets/third_screen.dart';

import '../../mocks/bloc_test.mocks.dart';

void main() {
  group("Test SecondScreen", () {
    late AppBloc mockAppBloc;

    setUp(() async {
      mockAppBloc = MockAppBloc();

      // mock [mockAppBloc.balance]
      when(mockAppBloc.balance).thenAnswer((_) {
        return ValueNotifier<num>(5000);
      });
    });

    testWidgets(
      "Clicking show/hide icon should hide the amount (e.g. ******) and vice versa",
      (widgetTester) async {
        await widgetTester.pumpWidget(
          MaterialApp(
            home: Material(
              child: Builder(
                builder: (context) {
                  return Center(
                    child: BlocProvider(
                      bloc: mockAppBloc,
                      child: SecondScreen(),
                    ),
                  );
                },
              ),
            ),
          ),
        );

        // find button
        Finder button = find.byKey(const Key("VISIBILITY_ICON_BUTTON"));

        // tap button
        await widgetTester.tap(button);

        // wait for all animations to complete
        await widgetTester.pumpAndSettle();

        // test
        expect(find.text("*******"), findsOneWidget);

        // tap button
        await widgetTester.tap(button);

        // wait for all animations to complete
        await widgetTester.pumpAndSettle();

        // test
        expect(find.text("5000.00"), findsOneWidget);
      },
    );

    testWidgets("Clicking send money button should open the 3rd screen", (
      widgetTester,
    ) async {
      await widgetTester.pumpWidget(
        BlocProvider(
          bloc: mockAppBloc,
          child: MaterialApp(
            home: Material(
              child: Builder(
                builder: (context) {
                  return Center(child: SecondScreen());
                },
              ),
            ),
          ),
        ),
      );

      // get context of SecondScreen
      final BuildContext context = widgetTester.element(
        find.byType(SecondScreen),
      );

      // mock [mockAppBloc.sendMoney()]
      when(mockAppBloc.sendMoney(context: context)).thenAnswer((_) {
        // for widget testing, just mock navigation to ThirdScreen as it's out of scope of the Widget
        // actual navigation should be done in integration testing
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const ThirdScreen()));
      });

      // find button
      Finder button = find.byKey(const Key("SEND_MONEY_BUTTON"));

      // tap button
      await widgetTester.tap(button);

      // wait for all animations to complete
      await widgetTester.pumpAndSettle();

      // test
      expect(find.byType(ThirdScreen), findsOneWidget);
    });

    testWidgets("Clicking view transactions button should open the 4th screen", (
      widgetTester,
    ) async {
      await widgetTester.pumpWidget(
        BlocProvider(
          bloc: mockAppBloc,
          child: MaterialApp(
            home: Material(
              child: Builder(
                builder: (context) {
                  return Center(child: SecondScreen());
                },
              ),
            ),
          ),
        ),
      );

      // get context of SecondScreen
      final BuildContext context = widgetTester.element(
        find.byType(SecondScreen),
      );

      // mock [mockAppBloc.viewTransactions()]
      when(mockAppBloc.viewTransactions(context: context)).thenAnswer((_) {
        // for widget testing, just mock navigation to FourthScreen as it's out of scope of the Widget
        // actual navigation should be done in integration testing
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const FourthScreen()));
      });

      // find button
      Finder button = find.byKey(const Key("VIEW_TRANSACTIONS_BUTTON"));

      // tap button
      await widgetTester.tap(button);

      // wait for all animations to complete
      await widgetTester.pumpAndSettle();

      // test
      expect(find.byType(FourthScreen), findsOneWidget);
    });
  });
}
