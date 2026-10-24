import 'package:flutter_test/flutter_test.dart';
import 'package:izmir_go/core/geo.dart';
import 'package:izmir_go/core/search_text.dart';
import 'package:izmir_go/core/time.dart';

void main() {
  group('fold (mirrors backend)', () {
    final cases = {
      'Halkapınar': 'halkapinar',
      'HALKAPINAR': 'halkapinar',
      'Çiğli Tramvayı İç Hat (Mavi)': 'cigli tramvayi ic hat mavi',
      'Üçkuyular İskele': 'uckuyular iskele',
      'Evka - 3': 'evka 3',
      'ŞEHİT ÖZDEMİR': 'sehit ozdemir',
    };
    for (final MapEntry(key: input, value: expected) in cases.entries) {
      test(input, () => expect(fold(input), expected));
    }
    test('Turkish dotless capital I', () => expect(trLower('IŞIK'), 'ışık'));
  });

  group('time', () {
    test('formats in İzmir time regardless of device zone', () {
      final instant = DateTime.parse('2026-10-28T00:05:00+03:00');
      expect(formatHm(instant), '00:05');
      expect(formatDateTime(instant), '28.10.2026 00:05');
    });
    test('minutes round up', () {
      final a = DateTime.utc(2026, 1, 1, 8);
      expect(minutesBetween(a, a.add(const Duration(seconds: 61))), 2);
      expect(minutesBetween(a, a.subtract(const Duration(minutes: 1))), 0);
    });
    test('iso query string uses +03:00', () {
      expect(isoIzmir(DateTime.utc(2026, 10, 28, 5)), '2026-10-28T08:00:00+03:00');
    });
  });

  test('haversine and coverage', () {
    expect(haversineM(38.4350, 27.1686, 38.433952, 27.171507).round(), inInclusiveRange(270, 290));
    expect(inIzmir(38.42, 27.14), isTrue);
    expect(inIzmir(41, 29), isFalse);
  });
}
