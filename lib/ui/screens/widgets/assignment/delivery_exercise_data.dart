/// Datos fijos del ejercicio del proyecto final: 4 repartidores × 4 pedidos.
///
/// Filas = repartidores (R1–R4), columnas = pedidos (P1–P4), valores en
/// minutos. Las matrices intermedias corresponden al paso a paso del
/// Método Húngaro y se usan solo para mostrar la teoría en pantalla.
class DeliveryExercise {
  const DeliveryExercise._();

  static const int size = 4;

  /// Matriz de costos original (minutos).
  static const List<List<int>> times = [
    [14, 5, 8, 7],
    [2, 12, 6, 5],
    [7, 8, 3, 9],
    [2, 4, 6, 10],
  ];

  /// Tras restar el mínimo de cada fila (5, 2, 3, 2).
  static const List<List<int>> afterRowReduction = [
    [9, 0, 3, 2],
    [0, 10, 4, 3],
    [4, 5, 0, 6],
    [0, 2, 4, 8],
  ];

  /// Tras restar el mínimo de cada columna (0, 0, 0, 2).
  static const List<List<int>> afterColumnReduction = [
    [9, 0, 3, 0],
    [0, 10, 4, 1],
    [4, 5, 0, 4],
    [0, 2, 4, 6],
  ];

  /// Tras ajustar con el menor valor no cubierto (1).
  static const List<List<int>> afterAdjustment = [
    [10, 0, 4, 0],
    [0, 9, 4, 0],
    [4, 4, 0, 3],
    [0, 1, 4, 5],
  ];

  /// Pedido (índice de columna) asignado a cada repartidor en el óptimo:
  /// R1→P2, R2→P4, R3→P3, R4→P1.
  static const List<int> optimalColumns = [1, 3, 2, 0];

  /// Asignación intuitiva (cada repartidor toma lo más cercano en orden):
  /// R1→P2, R2→P1, R3→P3, R4→P4.
  static const List<int> intuitiveColumns = [1, 0, 2, 3];

  static const int optimalTotal = 15;
  static const int intuitiveTotal = 20;

  /// Celdas (fila, columna) de la asignación óptima.
  static Set<(int, int)> get optimalCells => {
    for (var i = 0; i < optimalColumns.length; i++) (i, optimalColumns[i]),
  };

  /// Suma el costo original de una asignación (un pedido por repartidor).
  static int totalFor(List<int> columns) {
    var total = 0;
    for (var i = 0; i < columns.length; i++) {
      total += times[i][columns[i]];
    }
    return total;
  }
}
