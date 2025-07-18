import 'package:mockito/annotations.dart';
import 'package:myapp/blocs/app_bloc.dart';

// Mocked blocs.

//TO BUILD MOCKS, RUN: dart run build_runner build
@GenerateMocks([
  AppBloc,
])
void main() {}
