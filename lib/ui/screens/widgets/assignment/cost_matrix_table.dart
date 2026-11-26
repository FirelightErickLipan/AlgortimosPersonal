import 'package:flutter/material.dart';

/// Tabla de solo lectura para mostrar una matriz de costos Repartidor × Pedido.
class CostMatrixTable extends StatelessWidget {
  final List<List<int>> values;
  final String rowPrefix;
  final String columnPrefix;
  final bool showMinutes;
  final Set<(int, int)> highlighted;
  final double maxWidth;

  const CostMatrixTable({
    super.key,
    required this.values,
    this.rowPrefix = 'R',
    this.columnPrefix = 'P',
    this.showMinutes = false,
    this.highlighted = const {},
    this.maxWidth = 520,
  });

  Widget _cell(
    BuildContext context,
    String text, {
    bool header = false,
    bool marked = false,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      color: marked
          ? cs.primaryContainer
          : header
          ? cs.surfaceContainerHighest
          : null,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: header || marked ? FontWeight.bold : FontWeight.w500,
          color: marked ? cs.onPrimaryContainer : cs.onSurface,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final columns = values.isEmpty ? 0 : values.first.length;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Table(
        border: TableBorder.all(color: cs.outlineVariant),
        columnWidths: const {0: FixedColumnWidth(52)},
        defaultColumnWidth: const FlexColumnWidth(),
        children: [
          TableRow(
            children: [
              _cell(context, '', header: true),
              for (var j = 0; j < columns; j++)
                _cell(context, '$columnPrefix${j + 1}', header: true),
            ],
          ),
          for (var i = 0; i < values.length; i++)
            TableRow(
              children: [
                _cell(context, '$rowPrefix${i + 1}', header: true),
                for (var j = 0; j < columns; j++)
                  _cell(
                    context,
                    showMinutes ? '${values[i][j]} min' : '${values[i][j]}',
                    marked: highlighted.contains((i, j)),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
