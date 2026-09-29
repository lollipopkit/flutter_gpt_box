import 'package:fl_pi_llm_ui/fl_pi_llm_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  late int top, bottom;

  Widget app() => MaterialApp(
    home: Scaffold(
      body: PullActions(
        top: PullAction(icon: Icons.add, label: 'pull', readyLabel: 'release', onTrigger: () => top++),
        bottom: PullAction(
          icon: Icons.history,
          label: 'up',
          readyLabel: 'hold',
          hold: const Duration(seconds: 1),
          onTrigger: () => bottom++,
        ),
        child: ListView(
          physics: PullActions.physics,
          children: [for (var i = 0; i < 40; i++) SizedBox(height: 50, child: Text('$i'))],
        ),
      ),
    ),
  );

  setUp(() => top = bottom = 0);

  testWidgets('pulled down past the threshold, letting go does the top action', (tester) async {
    await tester.pumpWidget(app());
    final g = await tester.startGesture(const Offset(200, 200));
    for (var i = 0; i < 10; i++) {
      await g.moveBy(const Offset(0, 40));
      await tester.pump(const Duration(milliseconds: 16));
    }
    expect(find.text('release'), findsOneWidget);
    expect(top, 0);
    await g.up();
    await tester.pumpAndSettle();
    expect(top, 1);
  });

  testWidgets('a short pull down does nothing', (tester) async {
    await tester.pumpWidget(app());
    await tester.drag(find.byType(ListView), const Offset(0, 40));
    await tester.pumpAndSettle();
    expect(top, 0);
  });

  Future<TestGesture> pullUpPastEnd(WidgetTester tester) async {
    await tester.pumpWidget(app());
    await tester.fling(find.byType(ListView), const Offset(0, -5000), 5000);
    await tester.pumpAndSettle();
    final g = await tester.startGesture(const Offset(200, 500));
    for (var i = 0; i < 12; i++) {
      await g.moveBy(const Offset(0, -40));
      await tester.pump(const Duration(milliseconds: 16));
    }
    return g;
  }

  testWidgets('pulled up past the end and held a second, the bottom action', (tester) async {
    final g = await pullUpPastEnd(tester);
    expect(find.text('hold'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 500));
    expect(bottom, 0);
    await tester.pump(const Duration(milliseconds: 600));
    expect(bottom, 1);
    await g.up();
    await tester.pumpAndSettle();
    expect(bottom, 1);
  });

  testWidgets('let go before the second is up, nothing', (tester) async {
    final g = await pullUpPastEnd(tester);
    await tester.pump(const Duration(milliseconds: 400));
    await g.up();
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2));
    expect(bottom, 0);
  });
}
