import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../algorithms/assignment/domain/services/delivery_example_graph.dart';
import '../../../../algorithms/assignment/domain/services/delivery_solution.dart';

const Color _kOrderColor = Color(0xFFE8710A);
const Color _kOptimalColor = Color(0xFF1B8A5A);
const double _kNodeRadius = 26;

/// Reconoce el arrastre solo si el puntero empieza sobre un nodo. En ese caso
/// gana la competencia de gestos al instante (la página no se desplaza); si el
/// puntero cae fuera de un nodo se ignora y la página se desplaza normal.
class _NodeDragRecognizer extends PanGestureRecognizer {
  _NodeDragRecognizer({required this.shouldClaim});

  final bool Function(Offset localPosition) shouldClaim;

  @override
  void addAllowedPointer(PointerDownEvent event) {
    if (!shouldClaim(event.localPosition)) return;
    super.addAllowedPointer(event);
    resolve(GestureDisposition.accepted);
  }
}

/// Grafo bipartito del ejercicio de delivery, ya resuelto: las aristas de la
/// asignación óptima aparecen resaltadas y cualquier nodo se puede arrastrar.
class DeliveryGraphView extends StatefulWidget {
  final DeliverySolution solution;

  const DeliveryGraphView({super.key, required this.solution});

  @override
  State<DeliveryGraphView> createState() => _DeliveryGraphViewState();
}

class _DeliveryGraphViewState extends State<DeliveryGraphView> {
  static const int _n = 4;

  /// Posiciones normalizadas (0..1) de R1..R4 (índices 0..3) y P1..P4 (4..7).
  late List<Offset> _positions;
  Size _size = Size.zero;
  int? _pendingId;
  int? _dragId;
  int? _hoverId;
  bool _showAll = true;

  @override
  void initState() {
    super.initState();
    _positions = _initialPositions();
  }

  List<Offset> _initialPositions() {
    double y(int i) => 0.13 + i * (0.74 / (_n - 1));
    return [
      for (var i = 0; i < _n; i++) Offset(0.14, y(i)),
      for (var j = 0; j < _n; j++) Offset(0.86, y(j)),
    ];
  }

  int? _nodeAt(Offset p) {
    int? found;
    var best = double.infinity;
    for (var k = 0; k < _positions.length; k++) {
      final c = Offset(_positions[k].dx * _size.width, _positions[k].dy * _size.height);
      final d = (c - p).distance;
      if (d <= _kNodeRadius + 8 && d < best) {
        best = d;
        found = k;
      }
    }
    return found;
  }

  bool _claim(Offset p) {
    _pendingId = _nodeAt(p);
    return _pendingId != null;
  }

  void _onStart(DragStartDetails d) {
    setState(() => _dragId = _pendingId);
  }

  void _onUpdate(DragUpdateDetails d) {
    final id = _dragId;
    if (id == null || _size.width <= 0 || _size.height <= 0) return;
    final margin = (_kNodeRadius + 4);
    final mx = margin / _size.width;
    final my = margin / _size.height;
    final cur = _positions[id];
    final next = Offset(
      (cur.dx + d.delta.dx / _size.width).clamp(mx, 1 - mx).toDouble(),
      (cur.dy + d.delta.dy / _size.height).clamp(my, 1 - my).toDouble(),
    );
    setState(() => _positions[id] = next);
  }

  void _onEnd() {
    if (_dragId != null) setState(() => _dragId = null);
  }

  void _reset() {
    setState(() {
      _positions = _initialPositions();
      _dragId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isNarrow = MediaQuery.of(context).size.width < 700;
    final height = isNarrow ? 440.0 : 540.0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Wrap(
              spacing: 18,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _legend(cs.primary, 'Repartidor (Origen)', circle: true),
                _legend(_kOrderColor, 'Pedido (Destino)', circle: true),
                _legend(_kOptimalColor, 'Asignación óptima', line: true),
                _legend(cs.outline, 'Otras combinaciones', line: true, thin: true),
              ],
            ),
          ),
          SizedBox(
            height: height,
            child: LayoutBuilder(
              builder: (context, constraints) {
                _size = Size(constraints.maxWidth, height);
                return MouseRegion(
                  cursor: _dragId != null
                      ? SystemMouseCursors.grabbing
                      : (_hoverId != null
                            ? SystemMouseCursors.grab
                            : SystemMouseCursors.basic),
                  onHover: (e) {
                    final id = _nodeAt(e.localPosition);
                    if (id != _hoverId) setState(() => _hoverId = id);
                  },
                  onExit: (_) {
                    if (_hoverId != null) setState(() => _hoverId = null);
                  },
                  child: RawGestureDetector(
                    behavior: HitTestBehavior.translucent,
                    gestures: {
                      _NodeDragRecognizer:
                          GestureRecognizerFactoryWithHandlers<_NodeDragRecognizer>(
                            () => _NodeDragRecognizer(shouldClaim: _claim),
                            (r) {
                              r
                                ..onStart = _onStart
                                ..onUpdate = _onUpdate
                                ..onEnd = (_) {
                                  _onEnd();
                                }
                                ..onCancel = _onEnd;
                            },
                          ),
                    },
                    child: CustomPaint(
                      size: Size(constraints.maxWidth, height),
                      painter: _DeliveryGraphPainter(
                        positions: List<Offset>.from(_positions),
                        optimalCells: widget.solution.cells,
                        showAll: _showAll,
                        activeId: _dragId ?? _hoverId,
                        originColor: cs.primary,
                        orderColor: _kOrderColor,
                        optimalColor: _kOptimalColor,
                        gridColor: cs.outlineVariant,
                        edgeColor: cs.outline,
                        labelBg: cs.surface,
                        labelFg: cs.onSurface,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(Icons.pan_tool_alt_outlined, size: 18, color: cs.primary),
                Text(
                  'Arrastra cualquier nodo para moverlo.',
                  style: TextStyle(fontSize: 13.5, color: cs.onSurfaceVariant),
                ),
                FilterChip(
                  label: const Text('Mostrar todas las aristas'),
                  selected: _showAll,
                  onSelected: (v) => setState(() => _showAll = v),
                ),
                TextButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.restart_alt_rounded, size: 18),
                  label: const Text('Restablecer posiciones'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _legend(Color color, String text, {bool circle = false, bool line = false, bool thin = false}) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (circle)
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        if (line)
          Container(
            width: 22,
            height: thin ? 2 : 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(fontSize: 13, color: cs.onSurface)),
      ],
    );
  }
}

class _DeliveryGraphPainter extends CustomPainter {
  final List<Offset> positions;
  final Set<(int, int)> optimalCells;
  final bool showAll;
  final int? activeId;
  final Color originColor;
  final Color orderColor;
  final Color optimalColor;
  final Color gridColor;
  final Color edgeColor;
  final Color labelBg;
  final Color labelFg;

  _DeliveryGraphPainter({
    required this.positions,
    required this.optimalCells,
    required this.showAll,
    required this.activeId,
    required this.originColor,
    required this.orderColor,
    required this.optimalColor,
    required this.gridColor,
    required this.edgeColor,
    required this.labelBg,
    required this.labelFg,
  });

  static const int _n = 4;

  Offset _pos(int k, Size size) =>
      Offset(positions[k].dx * size.width, positions[k].dy * size.height);

  void _drawLabel(Canvas canvas, Offset center, String text, {required Color bg, required Color fg, required double fontSize, bool bold = false, Color? border}) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: fg,
          fontSize: fontSize,
          fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final rect = Rect.fromCenter(
      center: center,
      width: tp.width + 12,
      height: tp.height + 6,
    );
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(8));
    canvas.drawRRect(rrect, Paint()..color = bg);
    if (border != null) {
      canvas.drawRRect(
        rrect,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = border,
      );
    }
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Fondo con cuadrícula suave.
    final grid = Paint()
      ..color = gridColor.withValues(alpha: 0.25)
      ..strokeWidth = 1;
    for (var x = 0.0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (var y = 0.0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    // Aristas no óptimas.
    if (showAll) {
      final thin = Paint()
        ..color = edgeColor.withValues(alpha: 0.45)
        ..strokeWidth = 1.3
        ..strokeCap = StrokeCap.round;
      for (var i = 0; i < _n; i++) {
        for (var j = 0; j < _n; j++) {
          if (optimalCells.contains((i, j))) continue;
          canvas.drawLine(_pos(i, size), _pos(_n + j, size), thin);
        }
      }
      for (var i = 0; i < _n; i++) {
        for (var j = 0; j < _n; j++) {
          if (optimalCells.contains((i, j))) continue;
          final a = _pos(i, size);
          final b = _pos(_n + j, size);
          final p = Offset.lerp(a, b, 0.27)!;
          _drawLabel(
            canvas,
            p,
            '${DeliveryExampleGraph.times[i][j]}',
            bg: labelBg.withValues(alpha: 0.9),
            fg: labelFg.withValues(alpha: 0.75),
            fontSize: 11,
          );
        }
      }
    }

    // Aristas óptimas (encima).
    final glow = Paint()
      ..color = optimalColor.withValues(alpha: 0.22)
      ..strokeWidth = 11
      ..strokeCap = StrokeCap.round;
    final strong = Paint()
      ..color = optimalColor
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    for (final cell in optimalCells) {
      final a = _pos(cell.$1, size);
      final b = _pos(_n + cell.$2, size);
      canvas.drawLine(a, b, glow);
      canvas.drawLine(a, b, strong);
    }
    for (final cell in optimalCells) {
      final a = _pos(cell.$1, size);
      final b = _pos(_n + cell.$2, size);
      _drawLabel(
        canvas,
        Offset.lerp(a, b, 0.5)!,
        '${DeliveryExampleGraph.times[cell.$1][cell.$2]} min',
        bg: optimalColor,
        fg: Colors.white,
        fontSize: 12.5,
        bold: true,
        border: Colors.white,
      );
    }

    // Nodos.
    for (var k = 0; k < _n * 2; k++) {
      final isOrigin = k < _n;
      final c = _pos(k, size);
      final active = activeId == k;
      final r = _kNodeRadius + (active ? 3 : 0);
      canvas.drawCircle(
        c + const Offset(0, 3),
        r,
        Paint()..color = Colors.black.withValues(alpha: active ? 0.28 : 0.16),
      );
      canvas.drawCircle(c, r + 3, Paint()..color = optimalColor.withValues(alpha: 0.9));
      canvas.drawCircle(c, r, Paint()..color = isOrigin ? originColor : orderColor);
      final label = isOrigin ? 'R${k + 1}' : 'P${k - _n + 1}';
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, c - Offset(tp.width / 2, tp.height / 2));
    }

    // Etiquetas de columna.
    const headerY = 8.0;
    _drawLabel(canvas, Offset(size.width * 0.14, headerY + 8), 'REPARTIDORES',
        bg: Colors.transparent, fg: originColor, fontSize: 12, bold: true);
    _drawLabel(canvas, Offset(size.width * 0.86, headerY + 8), 'PEDIDOS',
        bg: Colors.transparent, fg: orderColor, fontSize: 12, bold: true);
  }

  @override
  bool shouldRepaint(covariant _DeliveryGraphPainter old) => true;
}
