import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myapp/blocs/app_bloc.dart';
import 'package:myapp/blocs/bloc_provider.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _State();
}

class _State extends State<FirstScreen> {
  late AppBloc _appBloc;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("First Screen")),
      body: Center(
        child: StreamBuilder(
          stream: _streamController.stream,
          builder: (context, snapshot) {
            bool loading = false;
            String? error;

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

            if (snapshot.hasError) {
              error = snapshot.error as String;
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(labelText: "Username"),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: "Password"),
                      obscureText: true,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed:
                        loading
                            ? null
                            : () {
                              _appBloc.login(
                                context: context,
                                controller: _streamController,
                                username: _usernameController.text,
                                password: _passwordController.text,
                              );
                            },
                    child:
                        loading
                            ? Transform.scale(
                              scale: 0.5,
                              child: CircularProgressIndicator(),
                            )
                            : const Text("Login"),
                  ),
                ),
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(error, style: TextStyle(color: Colors.red)),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
