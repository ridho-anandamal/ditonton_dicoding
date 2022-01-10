import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/presentation/pages/tv/tv_detail_page.dart';
import 'package:ditonton/presentation/provider/tv/tv_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../dummy_data/tv_data/dummy_objects.dart';
import 'tv_show_detail_page_test.mocks.dart';

@GenerateMocks([TVDetailNotifier])
void main() {
  late MockTVDetailNotifier mockTVDetailNotifier;

  setUp(() {
    mockTVDetailNotifier = MockTVDetailNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TVDetailNotifier>.value(
      value: mockTVDetailNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(mockTVDetailNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockTVDetailNotifier.tvDetail).thenReturn(testTVShowDetail);
    when(mockTVDetailNotifier.recommendationState)
        .thenReturn(RequestState.Loaded);
    when(mockTVDetailNotifier.tvRecommendation).thenReturn(<TV>[]);
    when(mockTVDetailNotifier.isAddedToWatchlist).thenReturn(false);

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(TVDetailPage(
      id: 1,
    )));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    when(mockTVDetailNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockTVDetailNotifier.tvDetail).thenReturn(testTVShowDetail);
    when(mockTVDetailNotifier.recommendationState)
        .thenReturn(RequestState.Loaded);
    when(mockTVDetailNotifier.tvRecommendation).thenReturn(<TV>[]);
    when(mockTVDetailNotifier.isAddedToWatchlist).thenReturn(true);

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(TVDetailPage(
      id: 1,
    )));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(mockTVDetailNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockTVDetailNotifier.tvDetail).thenReturn(testTVShowDetail);
    when(mockTVDetailNotifier.recommendationState)
        .thenReturn(RequestState.Loaded);
    when(mockTVDetailNotifier.tvRecommendation).thenReturn(<TV>[]);
    when(mockTVDetailNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockTVDetailNotifier.watchlistMessage)
        .thenReturn('Added to Watchlist');

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(TVDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    when(mockTVDetailNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockTVDetailNotifier.tvDetail).thenReturn(testTVShowDetail);
    when(mockTVDetailNotifier.recommendationState)
        .thenReturn(RequestState.Loaded);
    when(mockTVDetailNotifier.tvRecommendation).thenReturn(<TV>[]);
    when(mockTVDetailNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockTVDetailNotifier.watchlistMessage).thenReturn('Failed');

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(TVDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
