import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/service/hanzi_parser_service.dart';

void main() {
  group('HanziParserService', () {
    setUp(() {
      WidgetsFlutterBinding.ensureInitialized();
    });

    test('getDataFromJson', () async {
      HanziParserService().getDataFromJson();
    });
  });
}
