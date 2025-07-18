import 'package:flutter/material.dart';
import 'package:myapp/blocs/app_bloc.dart';
import 'package:myapp/blocs/bloc_provider.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _State();
}

class _State extends State<SecondScreen> {
  late AppBloc _appBloc;
  bool _isBalanceVisible = true;

  @override
  void initState() {
    super.initState();

    AppBloc? bloc = BlocProvider.of<AppBloc>(context);
    assert(bloc != null, "AppBloc must be provided");
    if (bloc != null) {
      _appBloc = bloc;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Second Screen")),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Balance:"),
                    const SizedBox(width: 8),
                    ValueListenableBuilder(
                      valueListenable: _appBloc.balance,
                      builder: (
                        BuildContext context,
                        num value,
                        Widget? child,
                      ) {
                        return Text(
                          _isBalanceVisible
                              ? value.toStringAsFixed(2)
                              : "*" * value.toStringAsFixed(2).length,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),

                    IconButton(
                      key: const Key("VISIBILITY_ICON_BUTTON"),
                      icon: Icon(
                        _isBalanceVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isBalanceVisible = !_isBalanceVisible;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  key: const Key("SEND_MONEY_BUTTON"),
                  onPressed: () {
                    _appBloc.sendMoney(context: context);
                  },
                  child: const Text('Send Money'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  key: const Key("VIEW_TRANSACTIONS_BUTTON"),
                  onPressed: () {
                    _appBloc.viewTransactions(context: context);
                  },
                  child: const Text('View Transactions'),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: InkWell(
                onTap: () {
                  _appBloc.logout(context: context);
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
