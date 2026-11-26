import '../models/assignment_models.dart';
import '../solvers/hungarian_solver.dart';
import 'assignment_matrix_extractor.dart';
import 'assignment_validator.dart';
import 'delivery_example_graph.dart';

/// Pareja repartidor → pedido de la solución, con su tiempo en minutos.
class DeliveryPair {
  final int courier; // índice 0..n-1  (R1 = 0)
  final int order; // índice 0..n-1   (P1 = 0)
  final int minutes;

  const DeliveryPair(this.courier, this.order, this.minutes);

  String get courierLabel => 'R${courier + 1}';
  String get orderLabel => 'P${order + 1}';
}

/// Resuelve el ejercicio de delivery con el solver real del proyecto
/// (el mismo que usa el editor de grafos): grafo → validación → matriz →
/// Método Húngaro.
class DeliverySolution {
  final List<DeliveryPair> pairs;
  final int totalMinutes;

  const DeliverySolution({required this.pairs, required this.totalMinutes});

  Set<(int, int)> get cells => {for (final p in pairs) (p.courier, p.order)};

  static DeliverySolution solve() {
    final grafo = DeliveryExampleGraph.build();
    final validation = TransportationValidator.validate(grafo);
    final problem = AssignmentMatrixExtractor.extract(grafo, validation);
    final result = HungarianAssignmentSolver().solve(
      problem: problem,
      method: TransportationMethod.hungarian,
      goal: OptimizationGoal.minimize,
    );

    final pairs = <DeliveryPair>[];
    for (var i = 0; i < problem.origins.length; i++) {
      for (var j = 0; j < problem.destinations.length; j++) {
        if (result.allocationMatrix[i][j] > 0) {
          // Los nodos se llaman R1..Rn / P1..Pn: el índice sale del nombre.
          final courier = _indexOf(problem.origins[i].nombre ?? '', i);
          final order = _indexOf(problem.destinations[j].nombre ?? '', j);
          pairs.add(
            DeliveryPair(
              courier,
              order,
              DeliveryExampleGraph.times[courier][order],
            ),
          );
        }
      }
    }
    pairs.sort((a, b) => a.courier.compareTo(b.courier));

    return DeliverySolution(
      pairs: pairs,
      totalMinutes: result.totalCost.round(),
    );
  }

  static int _indexOf(String name, int fallback) {
    if (name.length < 2) return fallback;
    final n = int.tryParse(name.substring(1));
    if (n == null || n < 1) return fallback;
    return n - 1;
  }
}
