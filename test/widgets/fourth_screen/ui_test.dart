import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/blocs/app_bloc.dart';
import 'package:myapp/blocs/bloc_provider.dart';
import 'package:myapp/objects/transaction.dart';
import 'package:myapp/widgets/fourth_screen.dart';

import '../../mocks/bloc_test.mocks.dart';

void main() {
  group("Test FourthScreen", () {
    late AppBloc mockAppBloc;

    setUp(() async {
      mockAppBloc = MockAppBloc();
    });

    testWidgets("Should show details like the amount sent.", (
      widgetTester,
    ) async {
      List<Transaction> mockTransactions = [
        Transaction(
          title: "Grocery",
          body: "Weekly needs for the month of July.",
          amount: 15000.00,
        ),
        Transaction(title: "Tuition", body: "1st Sem", amount: 40000.00),
        Transaction(title: "Rent", body: "For July", amount: 20000.00),
        Transaction(
          title: "Bills",
          body: "for the month of July.",
          amount: 35000.00,
        ),
      ];

      await widgetTester.pumpWidget(
        BlocProvider(
          bloc: mockAppBloc,
          child: MaterialApp(
            home: Material(
              child: Builder(
                builder: (context) {
                  return Center(
                    child: FourthScreen(initialTransactions: mockTransactions),
                  );
                },
              ),
            ),
          ),
        ),
      );

      // test
      await expectLater(
        find.byType(FourthScreen),
        matchesGoldenFile("goldens/show_transactions.png"),
      );
    });
  });
}
