import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myapp/blocs/base_bloc.dart';
import 'package:myapp/constants/routes.dart';
import 'package:myapp/objects/custom_exception.dart';
import 'package:myapp/objects/transaction.dart';
import 'package:myapp/services/transaction_service.dart';

class AppBloc extends BaseBloc {
  final ValueNotifier<num> _fakeBalance = ValueNotifier<num>(5000);
  ValueNotifier<num> get balance {
    // use a fake balance for now
    return _fakeBalance;
  }

  // used just for including sent transactions in display
  final List<Transaction> _sentTransactions = [];

  late TransactionService _transactionService;

  /// Use [transactionService] for replacing default [TransactionService].
  AppBloc({TransactionService? transactionService}) {
    // INITIALIZATION
    _transactionService = transactionService ?? TransactionService();
  }

  /// Logs in using [username] and [password].
  ///
  /// Values streamed through [controller]:
  /// - `1` for loading
  /// - `2` for success
  ///
  /// If successful, will be navigated to [SecondScreen].
  ///
  /// Errors are streamed as [String].
  void login({
    required BuildContext context,
    required String username,
    required String password,
    StreamController<int>? controller,
  }) {
    controller?.sink.add(1);
    // a bit of delay to notice loading
    Future.delayed(const Duration(seconds: 1), () {
      // just some hardcoded authentication for now
      if (username == "Maya" && password == "test") {
        controller?.sink.add(2);
        if (context.mounted) {
          Navigator.of(context).pushReplacementNamed(Routes.secondScreen.value);
        }
      } else {
        controller?.sink.addError("Login failed");
      }
    });
  }

  /// Logs out.
  ///
  /// Will be navigated back to [FirstScreen].
  void logout({required BuildContext context}) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.firstScreen.value,
      (Route<dynamic> route) => false,
    );
  }

  /// Navigates to [ThirdScreen].
  void sendMoney({required BuildContext context}) {
    Navigator.of(context).pushNamed(Routes.thirdScreen.value);
  }

  /// Navigates to [FourthScreen].
  void viewTransactions({required BuildContext context}) {
    Navigator.of(context).pushNamed(Routes.fourthScreen.value);
  }

  /// Submits [amount] as [Transaction] to backend.
  ///
  /// Values streamed through [controller]:
  /// - `1` for loading
  /// - `2` for success
  ///
  /// Displays bottom sheet for the result.
  ///
  /// Errors are streamed as [String].
  Future<void> submit({
    required BuildContext context,
    required num amount,
    StreamController<int>? controller,
  }) async {
    try {
      controller?.sink.add(1);

      // check if amount is valid
      if (amount <= 0 || amount > balance.value) {
        // invalid
        controller?.sink.addError("Invalid amount");
        if (context.mounted) {
          super.showBottomSheet(context: context, message: "Invalid amount");
        }
        return;
      }

      // a bit of delay to notice loading
      await Future.delayed(const Duration(seconds: 1));

      Transaction res = await _transactionService.post(
        transaction: Transaction(
          amount: amount,
          title: DateTime.now().toString(),
          body: "Money sent",
        ),
      );

      // save to sent transactions
      _sentTransactions.add(res);

      // subtract amount from balance
      balance.value -= amount;

      controller?.sink.add(2);
      if (context.mounted) {
        super.showBottomSheet(
          context: context,
          message: "Transaction ${res.id} posted!",
        );
      }
    } on CustomException catch (e) {
      String err = e.message ?? "Unknown error";
      controller?.sink.addError(err);
      if (context.mounted) {
        super.showBottomSheet(context: context, message: err);
      }
    }
  }

  /// Fetches [Transaction] list from backend.
  ///
  /// Values streamed through [controller]:
  /// - `1` for loading
  /// - `List<Transaction>` for success
  ///
  ///
  /// Errors are streamed as [String].
  Future<void> getTransactions({
    required BuildContext context,
    required StreamController<dynamic> controller,
  }) async {
    try {
      controller.sink.add(1);

      // a bit of delay to notice loading
      await Future.delayed(const Duration(seconds: 1));

      // since posted data is not actually stored in backend (using a fake REST API), add _sentTransactions to be displayed
      List<Transaction> transactions = [];
      transactions.addAll(_sentTransactions);
      List<Transaction> trxns = await _transactionService.getAll();
      transactions.addAll(trxns);

      controller.sink.add(transactions);
    } on CustomException catch (e) {
      String err = e.message ?? "Unknown error";
      controller.sink.addError(err);
    }
  }

  @override
  void dispose() {
    balance.dispose();
  }
}
