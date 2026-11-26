import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nodos/ui/screens/application_screen.dart';
import 'package:nodos/ui/screens/widgets/assignment/delivery_graph_view.dart';
import 'package:nodos/ui/theme/app_theme.dart';

Future<void> _pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1400, 1000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: const ApplicationScreen(),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  group('ApplicationScreen (pestaña Aplicación)', () {
    testWidgets('el menú lateral muestra solo las 6 pestañas + Equipo, sin '
        '"Editar Grafos" ni "SleepNode"', (tester) async {
      await _pumpApp(tester);

      for (final label in const [
        '1. Introducción',
        '2. Problema',
        '3. Objetivo',
        '4. Marco teórico',
        '5. Aplicación',
        '6. Conclusiones',
        'Equipo',
      ]) {
        expect(find.text(label), findsOneWidget, reason: label);
      }
      expect(find.text('Proyecto'), findsOneWidget);
      expect(find.text('Editar Grafos'), findsNothing);
      expect(find.text('SleepNode'), findsNothing);
    });

    testWidgets('muestra directamente el grafo resuelto, sin botones de '
        'editor', (tester) async {
      await _pumpApp(tester);

      expect(find.byType(DeliveryGraphView), findsOneWidget);
      expect(find.text('Abrir editor vacío'), findsNothing);
      expect(find.text('Abrir la aplicación con el ejercicio'), findsNothing);
      expect(find.text('Z = 15 min'), findsOneWidget);
      expect(find.text('Mostrar todas las aristas'), findsOneWidget);
    });

    testWidgets('un nodo se puede arrastrar sin errores', (tester) async {
      await _pumpApp(tester);

      final canvas = find.descendant(
        of: find.byType(DeliveryGraphView),
        matching: find.byType(CustomPaint),
      );
      expect(canvas, findsWidgets);

      // R1 está en (14 %, 13 %) del lienzo.
      final box = tester.getRect(canvas.first);
      final r1 = Offset(
        box.left + box.width * 0.14,
        box.top + box.height * 0.13,
      );
      final gesture = await tester.startGesture(r1);
      await gesture.moveBy(const Offset(120, 60));
      await tester.pump();
      await gesture.up();
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });
}
