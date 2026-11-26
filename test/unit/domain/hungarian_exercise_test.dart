import 'package:flutter_test/flutter_test.dart';
import 'package:nodos/algorithms/assignment/domain/models/assignment_models.dart';
import 'package:nodos/algorithms/assignment/domain/services/assignment_matrix_extractor.dart';
import 'package:nodos/algorithms/assignment/domain/services/assignment_validator.dart';
import 'package:nodos/algorithms/assignment/domain/services/delivery_example_graph.dart';
import 'package:nodos/algorithms/assignment/domain/solvers/hungarian_solver.dart';
import 'package:nodos/domain/models/nodo.dart';
import 'package:nodos/ui/screens/widgets/assignment/delivery_exercise_data.dart';

/// Ejercicio del proyecto final: 4 repartidores × 4 pedidos (minutos).
const _times = <List<double>>[
  [14, 5, 8, 7],
  [2, 12, 6, 5],
  [7, 8, 3, 9],
  [2, 4, 6, 10],
];

TransportationProblemData _buildProblem() {
  final repartidores = [
    for (var i = 0; i < 4; i++)
      Nodo(id: 'R${i + 1}', nombre: 'R${i + 1}', colorValue: 0, x: 0, y: 0),
  ];
  final pedidos = [
    for (var j = 0; j < 4; j++)
      Nodo(id: 'P${j + 1}', nombre: 'P${j + 1}', colorValue: 0, x: 100, y: 0),
  ];
  return TransportationProblemData(
    origins: repartidores,
    destinations: pedidos,
    supplies: const [1, 1, 1, 1],
    demands: const [1, 1, 1, 1],
    costMatrix: _times,
    isBalanced: true,
    totalSupply: 4,
    totalDemand: 4,
  );
}

/// Mínimo por fuerza bruta sobre las 24 permutaciones.
double _bruteForceMinimum() {
  var best = double.infinity;
  void permute(List<int> cols, int k) {
    if (k == cols.length) {
      var total = 0.0;
      for (var i = 0; i < cols.length; i++) {
        total += _times[i][cols[i]];
      }
      if (total < best) best = total;
      return;
    }
    for (var i = k; i < cols.length; i++) {
      final swapped = [...cols];
      final tmp = swapped[k];
      swapped[k] = swapped[i];
      swapped[i] = tmp;
      permute(swapped, k + 1);
    }
  }

  permute([0, 1, 2, 3], 0);
  return best;
}

void main() {
  group('Ejercicio final - Repartidores × Pedidos (Método Húngaro)', () {
    test('el solver da Z = 15 con R1→P2, R2→P4, R3→P3, R4→P1', () {
      final result = HungarianAssignmentSolver().solve(
        problem: _buildProblem(),
        method: TransportationMethod.hungarian,
        goal: OptimizationGoal.minimize,
      );

      expect(result.totalCost, equals(15.0));

      // Columna asignada a cada repartidor (celda con cantidad 1).
      final assigned = [
        for (var i = 0; i < 4; i++)
          result.allocationMatrix[i].indexWhere((q) => q > 0),
      ];
      expect(assigned, equals([1, 3, 2, 0]));
    });

    test('el grafo precargado en la app es válido y se resuelve con Z = 15', () {
      final grafo = DeliveryExampleGraph.build();
      expect(grafo.nodos.length, equals(8));
      expect(grafo.conexiones.length, equals(16));

      final validation = TransportationValidator.validate(grafo);
      expect(validation.isValid, isTrue, reason: validation.errorMessage);

      final problem = AssignmentMatrixExtractor.extract(grafo, validation);
      for (var i = 0; i < 4; i++) {
        for (var j = 0; j < 4; j++) {
          expect(problem.costMatrix[i][j], _times[i][j]);
        }
      }

      final result = HungarianAssignmentSolver().solve(
        problem: problem,
        method: TransportationMethod.hungarian,
        goal: OptimizationGoal.minimize,
      );
      expect(result.totalCost, equals(15.0));
    });

    test('coincide con la fuerza bruta (24 combinaciones)', () {
      expect(_bruteForceMinimum(), equals(15.0));
    });

    test('la asignación intuitiva cuesta 20 min (25 % más)', () {
      const intuitive = [1, 0, 2, 3]; // R1→P2, R2→P1, R3→P3, R4→P4
      var total = 0.0;
      for (var i = 0; i < intuitive.length; i++) {
        total += _times[i][intuitive[i]];
      }
      expect(total, equals(20.0));
      expect((total - 15.0) / total, closeTo(0.25, 1e-9));
    });

    test('los datos mostrados en la web coinciden con el ejercicio', () {
      for (var i = 0; i < 4; i++) {
        for (var j = 0; j < 4; j++) {
          expect(DeliveryExercise.times[i][j].toDouble(), _times[i][j]);
        }
      }
      expect(
        DeliveryExercise.totalFor(DeliveryExercise.optimalColumns),
        DeliveryExercise.optimalTotal,
      );
      expect(
        DeliveryExercise.totalFor(DeliveryExercise.intuitiveColumns),
        DeliveryExercise.intuitiveTotal,
      );
    });
  });
}
