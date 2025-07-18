import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myapp/blocs/app_bloc.dart';
import 'package:flutter/services.dart';
import 'package:myapp/blocs/bloc_provider.dart';

class ThirdScreen extends StatefulWidget {
  const ThirdScreen({super.key});

  @override
  State<ThirdScreen> createState() => _State();
}

class _State extends State<ThirdScreen> {
  late AppBloc _appBloc;

  final TextEditingController _amountController = TextEditingController();
  final StreamController<int> _streamController = StreamController<int>();

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
      appBar: AppBar(title: const Text("Third Screen")),
      body: StreamBuilder(
        stream: _streamController.stream,
        builder: (ctx, snapshot) {
          bool loading = false;

          if (snapshot.hasData) {
            switch (snapshot.data) {
              case 1:
                loading = true;
                break;
              case 2:
                // do nothing when successful
                break;
            }
          }

          return Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        key: const Key("AMOUNT_TEXTFIELD"),
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Amount to Send',
                          border: OutlineInputBorder(),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed:
                            loading
                                ? null
                                : () {
                                  _appBloc.submit(
                                    context: ctx,
                                    amount: double.parse(
                                      _amountController.text,
                                    ),
                                    controller: _streamController,
                                  );
                                },
                        child:
                            loading
                                ? Transform.scale(
                                  scale: 0.5,
                                  child: CircularProgressIndicator(),
                                )
                                : const Text("Submit"),
                      ),
                    ],
                  ),
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
          );
        },
      ),
    );
  }
}
