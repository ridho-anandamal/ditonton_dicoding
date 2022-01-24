import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist_tv_bloc.dart';
import 'package:ditonton/presentation/pages/tv/watchlist_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/tv_data/dummy_objects.dart';

class MockWatchlistTVBloc
    extends MockBloc<WatchlistTVEvent, WatchlistTVState>
    implements WatchlistTVBloc {}

class WatchlistTVEventFake extends Fake implements WatchlistTVEvent {}

class WatchlistTVStateFake extends Fake implements WatchlistTVState {}

void main() {
  late MockWatchlistTVBloc mockWatchlistTVBloc;

  setUpAll(() {
    registerFallbackValue(WatchlistTVEventFake());
    registerFallbackValue(WatchlistTVStateFake());
  });

  setUp(() {
    mockWatchlistTVBloc = MockWatchlistTVBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistTVBloc>.value(
      value: mockWatchlistTVBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('Watchlist TV Page Test:', () {
    testWidgets('Page should nothing when empty', (WidgetTester tester) async {
      when(() => mockWatchlistTVBloc.state)
          .thenReturn(WatchlistTVEmptyState());
      await tester.pumpWidget(_makeTestableWidget(WatchlistTVPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsNothing);
    });
    
    testWidgets('Page should display center progress bar when loading',
        (WidgetTester tester) async {
      when(() => mockWatchlistTVBloc.state)
          .thenReturn(WatchlistTVLoadingState());
      await tester.pumpWidget(_makeTestableWidget(WatchlistTVPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('Page should display ListView when data is loaded',
        (WidgetTester tester) async {
      when(() => mockWatchlistTVBloc.state)
          .thenReturn(WatchlistTVHasDataState(result: testTVShowsList));

      await tester.pumpWidget(_makeTestableWidget(WatchlistTVPage()));

      final listViewFinder = find.byType(ListView);
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('Page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockWatchlistTVBloc.state)
          .thenReturn(WatchlistTVErrorState(message: 'Error'));

      await tester.pumpWidget(_makeTestableWidget(WatchlistTVPage()));

      final textFinder = find.byKey(Key('error_message'));
      expect(textFinder, findsOneWidget);
    });
  });
}
