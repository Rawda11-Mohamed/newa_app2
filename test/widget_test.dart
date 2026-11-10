import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/main.dart';
import 'package:news_app/providers/app_settings_provider.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('splash opens the news home screen', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppSettingsProvider(),
        child: const MyApp(),
      ),
    );

    expect(find.text('News App'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 900));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('UAE News'), findsOneWidget);
  });

  testWidgets('home search opens the news search screen', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppSettingsProvider(),
        child: const MyApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Search news'));
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('category cards open their news feed', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppSettingsProvider(),
        child: const MyApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pumpAndSettle();

    final business = find.text('Business');
    await tester.ensureVisible(business);
    await tester.tap(business);
    await tester.pumpAndSettle();

    expect(find.text('Business'), findsOneWidget);
  });
}
