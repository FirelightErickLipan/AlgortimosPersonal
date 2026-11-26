import '../../../../domain/models/atributo.dart';
import '../../../../domain/models/conexion.dart';
import '../../../../domain/models/direccion.dart';
import '../../../../domain/models/grafo.dart';
import '../../../../domain/models/nodo.dart';
import '../policy/assignment_graph_policy.dart';

/// Grafo bipartito del ejercicio final: 4 repartidores (Origen) × 4 pedidos
/// (Destino). Cada arista lleva el tiempo en minutos en `attr_valor`.
///
/// Resultado esperado al optimizar (minimizar): R1→P2, R2→P4, R3→P3,
/// R4→P1 con Z = 15.
class DeliveryExampleGraph {
  const DeliveryExampleGraph._();

  static const List<List<int>> times = [
    [14, 5, 8, 7],
    [2, 12, 6, 5],
    [7, 8, 3, 9],
    [2, 4, 6, 10],
  ];

  static const String costAttributeId = 'attr_valor';

  static Grafo build() {
    final size = times.length;
    final nodos = <String, Nodo>{};
    final conexiones = <String, Conexion>{};

    for (var i = 0; i < size; i++) {
      final id = 'ex_origin_${i + 1}';
      nodos[id] = Nodo(
        id: id,
        nombre: 'R${i + 1}',
        colorValue: AssignmentRoles.originColor,
        x: 120,
        y: 120.0 + i * 110,
        rol: AssignmentRoles.origin,
      );
    }
    for (var j = 0; j < size; j++) {
      final id = 'ex_dest_${j + 1}';
      nodos[id] = Nodo(
        id: id,
        nombre: 'P${j + 1}',
        colorValue: AssignmentRoles.destinationColor,
        x: 480,
        y: 120.0 + j * 110,
        rol: AssignmentRoles.destination,
      );
    }

    for (var i = 0; i < size; i++) {
      for (var j = 0; j < size; j++) {
        final id = 'ex_conn_${i + 1}_${j + 1}';
        conexiones[id] = Conexion(
          id: id,
          nodoOrigenId: 'ex_origin_${i + 1}',
          nodoDestinoId: 'ex_dest_${j + 1}',
          colorValue: AssignmentRoles.originColor,
          direccion: Direccion.unidireccional,
          atributos: [
            AtributoValor(
              atributoId: costAttributeId,
              valor: '${times[i][j]}',
            ),
          ],
        );
      }
    }

    return Grafo(
      nodos: nodos,
      conexiones: conexiones,
      tipoAlgoritmo: 'assignment',
    );
  }
}
