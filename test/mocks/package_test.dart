import 'package:http/http.dart';

import 'package:mockito/annotations.dart';

// Mocked package objects/classes.

//TO BUILD MOCKS, RUN: dart run build_runner build
@GenerateMocks([
  Client,
])
void main() {}
