import 'package:flutter/material.dart';
import 'package:myapp/blocs/app_bloc.dart';
import 'package:myapp/blocs/bloc_provider.dart';
import 'package:myapp/constants/routes.dart';
import 'package:myapp/widgets/first_screen.dart';
import 'package:myapp/widgets/fourth_screen.dart';
import 'package:myapp/widgets/second_screen.dart';
import 'package:myapp/widgets/third_screen.dart';

void main() {
  runApp(const MayaTest());
}

class MayaTest extends StatelessWidget {
  const MayaTest({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: AppBloc(),
      child: MaterialApp(
        theme: ThemeData(fontFamily: "Roboto"),
        debugShowCheckedModeBanner: false,
        title: "Maya Test",
        initialRoute: Routes.firstScreen.value,
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case "/first_screen":
              return MaterialPageRoute(
                builder: (context) => const FirstScreen(),
              );
            case "/second_screen":
              return MaterialPageRoute(
                builder: (context) => const SecondScreen(),
              );
            case "/third_screen":
              return MaterialPageRoute(
                builder: (context) => const ThirdScreen(),
              );
            case "/fourth_screen":
              return MaterialPageRoute(
                builder: (context) => const FourthScreen(),
              );
            case "/":
              // don't generate route on start-up
              return null;
            default:
              return MaterialPageRoute(
                builder:
                    (context) =>
                        const Center(child: Text("Something went wrong")),
              );
          }
        },
      ),
    );
  }
}
