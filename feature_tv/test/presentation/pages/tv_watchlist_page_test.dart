import 'package:bloc_test/bloc_test.dart';
import 'package:feature_tv/presentation/blocs/watchlist_tv_bloc.dart';
import 'package:feature_tv/presentation/pages/watchlist_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/dummy_objects.dart';


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

  group('TV Page, Watchlist TV Page:', () {
    testWidgets('page should nothing when empty', (WidgetTester tester) async {
      when(() => mockWatchlistTVBloc.state)
          .thenReturn(WatchlistTVEmptyState());
      await tester.pumpWidget(_makeTestableWidget(const WatchlistTVPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsNothing);
    });
    
    testWidgets('page should display center progress bar when loading',
        (WidgetTester tester) async {
      when(() => mockWatchlistTVBloc.state)
          .thenReturn(WatchlistTVLoadingState());
      await tester.pumpWidget(_makeTestableWidget(const WatchlistTVPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('page should display ListView when data is loaded',
        (WidgetTester tester) async {
      when(() => mockWatchlistTVBloc.state)
          .thenReturn(WatchlistTVHasDataState(result: testTVShowsList));

      await tester.pumpWidget(_makeTestableWidget(const WatchlistTVPage()));

      final listViewFinder = find.byType(ListView);
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockWatchlistTVBloc.state)
          .thenReturn(const WatchlistTVErrorState(message: 'Error'));

      await tester.pumpWidget(_makeTestableWidget(const WatchlistTVPage()));

      final textFinder = find.byKey(const Key('error_message'));
      expect(textFinder, findsOneWidget);
    });
  });
}
