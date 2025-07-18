import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myapp/blocs/app_bloc.dart';
import 'package:myapp/blocs/bloc_provider.dart';
import 'package:myapp/objects/transaction.dart';

class FourthScreen extends StatefulWidget {
  const FourthScreen({super.key, this.initialTransactions});

  /// Can be used for prepopulation
  final List<Transaction>? initialTransactions;

  @override
  State<FourthScreen> createState() => _State();
}

class _State extends State<FourthScreen> {
  late AppBloc _appBloc;

  final StreamController<dynamic> _streamController =
      StreamController<dynamic>();

  @override
  void initState() {
    super.initState();

    AppBloc? bloc = BlocProvider.of<AppBloc>(context);
    assert(bloc != null, "AppBloc must be provided");
    if (bloc != null) {
      _appBloc = bloc;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _appBloc.getTransactions(context: context, controller: _streamController);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fourth Screen")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _streamController.stream,
              initialData: widget.initialTransactions,
              builder: (ctx, snapshot) {
                List<Transaction> transactions = [];

                if (snapshot.hasError) {
                  String error = snapshot.error as String;
                  return Text(error, style: TextStyle(color: Colors.red));
                }

                if (snapshot.hasData) {
                  if (snapshot.data is int && snapshot.data == 1) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data is List<Transaction>) {
                    transactions = snapshot.data;
                  }
                }

                return ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (listCtx, position) {
                    return ListTile(
                      title: Text(transactions[position].title ?? ""),
                      subtitle: Text(transactions[position].body ?? ""),
                      trailing: Text(transactions[position].amount.toString()),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0, bottom: 24.0),
            child: InkWell(
              onTap: () {
                _appBloc.logout(context: context);
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }
}
