import 'package:uuid/v4.dart';

String generateUUID() {
  return const UuidV4().generate().toString();
}
