# Cómo aplicar los cambios (Fase A — proyecto final, Asignación / Método Húngaro)

## Pasos
1. Descomprime este zip y **arrastra el contenido de `cambios_proyecto_final/` sobre la raíz de `algorithm-main`**; acepta "Reemplazar los archivos". Las rutas ya coinciden con las del proyecto.
2. `ARCHIVOS_A_BORRAR.txt` dice "Fase B no aplicada": **no hay nada que borrar**.
3. En la raíz del proyecto:
```bash
flutter pub get
echo "" > .env          # pubspec declara .env como asset; sin él el build web falla
flutter analyze
flutter test test/unit/domain/hungarian_exercise_test.dart test/widget/screens/application_screen_test.dart
flutter run -d chrome
```
4. (Opcional) `flutter build web --release`.

## Archivos NUEVOS
- `lib/algorithms/assignment/domain/services/delivery_example_graph.dart`
- `lib/ui/screens/application_screen.dart`
- `lib/ui/screens/conclusions_screen.dart`
- `lib/ui/screens/objective_screen.dart`
- `lib/ui/screens/problem_screen.dart`
- `lib/ui/screens/widgets/assignment/cost_matrix_table.dart`
- `lib/ui/screens/widgets/assignment/delivery_exercise_data.dart`
- `lib/ui/screens/widgets/assignment/hungarian_theory_section.dart`
- `lib/ui/screens/widgets/project/project_page.dart`
- `test/unit/domain/hungarian_exercise_test.dart`
- `test/widget/screens/application_screen_test.dart`

## Archivos MODIFICADOS
- `lib/algorithms/assignment/ui/assignment_launch_button.dart`
- `lib/algorithms/bst/ui/bst_theory_screen.dart`
- `lib/algorithms/core/algorithm_registry.dart`
- `lib/algorithms/graph_paths/ui/graph_path_theory_screen.dart`
- `lib/main.dart`
- `lib/ui/screens/assignment_algo_screen.dart`
- `lib/ui/screens/contact_screen.dart`
- `lib/ui/screens/graph_editor_screen.dart`
- `lib/ui/screens/johnson_algo_screen.dart`
- `lib/ui/screens/matlab_fuzzy_screen.dart`
- `lib/ui/screens/matlab_lab_screen.dart`
- `lib/ui/screens/northwest_algo_screen.dart`
- `lib/ui/screens/sorting_algo_screen.dart`
- `lib/ui/screens/welcome_explanation_screen.dart`
- `lib/ui/screens/what_are_graphs_screen.dart`
- `lib/ui/screens/widgets/welcome/welcome_footer_section.dart`
- `lib/ui/screens/widgets/welcome/welcome_hero_section.dart`
- `lib/ui/widgets/web_explanation_navbar.dart`
- `test/widget/screens/graph_editor_screen_test.dart`
- `test/widget/screens/sorting_visualizer_screen_test.dart`
- `test/widget/screens/welcome_explanation_widgets_test.dart`
- `web/index.html`
- `web/manifest.json`

## Qué hace el botón de Aplicación
"Abrir la aplicación con el ejercicio" abre el editor con Asignación activo y el grafo ya dibujado (R1–R4 → P1–P4 con los 16 tiempos). Solo falta elegir Minimizar y pulsar Optimizar (Z = 15). "Abrir editor vacío" abre el lienzo limpio. El grafo está en `lib/algorithms/assignment/domain/services/delivery_example_graph.dart`.

## Importante: no pude compilar
En el entorno donde se hizo el trabajo no hay acceso a los servidores de Flutter/pub.dev, así que **no se ejecutó `flutter analyze`, `flutter test` ni `flutter build web`**. Solo se revisó la sintaxis con un parser de Dart y se contrastaron a mano imports, nombres y firmas. Corre `flutter analyze` primero; si aparece algo, es del último cambio y es corto de corregir.

## Diferencias entre el .md y el código real
- Las pantallas ocultas (Johnson, Northwest, BST, Dijkstra/Kruskal, sorting, MATLAB, ¿Qué son los grafos?) y un test usaban los valores viejos de `ExplanationWebPage`. Como la Fase A no borra nada, cambié esas referencias a `ExplanationWebPage.introduccion` (una línea por archivo) para que sigan compilando. Se borran en la Fase B.
- `WelcomeHeroSection` y `WelcomeFooterSection` tenían textos fijos: añadí parámetros opcionales (con los textos antiguos como valor por defecto) para reutilizarlos.
- `AssignmentLaunchButton` (Marco teórico) usaba `pushReplacement`; lo cambié a `push` para que "atrás" desde el editor vuelva a la web.
- El logo del menú sigue diciendo "SleepNode" y el equipo "SleepCode();" (no estaba en el .md).
- **Equipo:** `Marino.webp` existe pero no sé nombre ni correo del tercer integrante, así que no lo agregué en `contact_screen.dart`. Añádelo en `teamMembers` si participa.

## Tests que van a fallar hasta la Fase B
Prueban algoritmos que ya no están en el registro (el .md los marca para borrar): `test/algorithms/graph_paths/*`, `test/widget/graph_paths/*`, `test/widget/bst/bst_navigation_test.dart`, `test/widget/dialogs/algorithm_selection_dialog_test.dart`, y los de Johnson/Northwest que dependan de `selectById`.
Ejecuta los de Asignación y comunes: `flutter test test/unit test/widget/screens/assignment_algo_widgets_test.dart test/widget/assignment`.

## Verificación manual (checklist del .md)
Menú con 6 pestañas + Equipo · cada pestaña se resalta · Aplicación → botón → editor con `[+ Origen | + Destino]` · matriz del ejercicio da Z = 15 (R1–P2, R2–P4, R3–P3, R4–P1) · videos · ancho <1024 (drawer) y ≥1024.
