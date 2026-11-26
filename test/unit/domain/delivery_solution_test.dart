import 'package:flutter_test/flutter_test.dart';
import 'package:nodos/algorithms/assignment/domain/services/delivery_solution.dart';

void main() {
  group('DeliverySolution', () {
    test('resuelve el ejercicio con Z = 15 y la asignación óptima', () {
      final solution = DeliverySolution.solve();

      expect(solution.totalMinutes, equals(15));
      expect(solution.pairs.length, equals(4));
      expect(
        solution.pairs.map((p) => '${p.courierLabel}-${p.orderLabel}').toList(),
        equals(['R1-P2', 'R2-P4', 'R3-P3', 'R4-P1']),
      );
      expect(solution.pairs.fold<int>(0, (s, p) => s + p.minutes), equals(15));
    });
  });
}
