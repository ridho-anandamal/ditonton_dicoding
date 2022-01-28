import 'package:bloc_test/bloc_test.dart';
import 'package:feature_tv/presentation/blocs/detail_tv_bloc.dart';
import 'package:feature_tv/presentation/blocs/recommendation_tv_bloc.dart';
import 'package:feature_tv/presentation/blocs/watchlist_status_tv_cubit.dart';
import 'package:feature_tv/presentation/pages/tv_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/dummy_objects.dart';


class MockDetailTVBloc extends MockBloc<DetailTVEvent, DetailTVState>
    implements DetailTVBloc {}

class DetailTVEventFake extends Fake implements DetailTVEvent {}

class DetailTVStateFake extends Fake implements DetailTVState {}

class MockRecommendationTVBloc
    extends MockBloc<RecommendationTVEvent, RecommendationTVState>
    implements RecommendationTVBloc {}

class RecommendationTVEventFake extends Fake implements RecommendationTVEvent {}

class RecommendationTVStateFake extends Fake implements RecommendationTVState {}

class MockWatchlistStatusTVCubit extends MockCubit<WatchlistStatusTVState>
    implements WatchlistStatusTVCubit {}

class WatchlistStatusTVStateFake extends Fake
    implements WatchlistStatusTVState {}

void main() {
  late MockDetailTVBloc mockDetailTVBloc;
  late MockRecommendationTVBloc mockRecommendationTVBloc;
  late MockWatchlistStatusTVCubit mockWatchlistStatusTVCubit;

  setUpAll(() {
    registerFallbackValue(DetailTVEventFake());
    registerFallbackValue(DetailTVStateFake());
  });

  setUp(() {
    mockDetailTVBloc = MockDetailTVBloc();
    mockRecommendationTVBloc = MockRecommendationTVBloc();
    mockWatchlistStatusTVCubit = MockWatchlistStatusTVCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DetailTVBloc>.value(value: mockDetailTVBloc),
        BlocProvider<RecommendationTVBloc>.value(
            value: mockRecommendationTVBloc),
        BlocProvider<WatchlistStatusTVCubit>.value(
          value: mockWatchlistStatusTVCubit,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('TV Page, Detail TV Page:', () {
    testWidgets('page should nothing when empty', (WidgetTester tester) async {
      when(() => mockDetailTVBloc.state).thenReturn(DetailTVEmptyState());
      when(() => mockWatchlistStatusTVCubit.state).thenReturn(
          const WatchlistStatusTVState(isAddedWatchlist: false, message: ''));
      when(() => mockRecommendationTVBloc.state)
          .thenReturn(RecommendationTVEmptyState());

      await tester.pumpWidget(
          _makeTestableWidget(TVDetailPage(id: testTVShowDetail.id)));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsNothing);
    });

    testWidgets('page should display center progress bar when loading',
        (WidgetTester tester) async {
      when(() => mockDetailTVBloc.state).thenReturn(DetailTVLoadingState());
      when(() => mockWatchlistStatusTVCubit.state).thenReturn(
          const WatchlistStatusTVState(isAddedWatchlist: false, message: ''));
      when(() => mockRecommendationTVBloc.state)
          .thenReturn(RecommendationTVLoadingState());

      await tester.pumpWidget(
          _makeTestableWidget(TVDetailPage(id: testTVShowDetail.id)));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('page should display Detail when data is loaded',
        (WidgetTester tester) async {
      when(() => mockDetailTVBloc.state)
          .thenReturn(DetailTVHasDataState(result: testTVShowDetail));
      when(() => mockWatchlistStatusTVCubit.state).thenReturn(
          const WatchlistStatusTVState(isAddedWatchlist: false, message: ''));
      when(() => mockRecommendationTVBloc.state)
          .thenReturn(RecommendationTVHasDataState(result: testTVShowsList));

      await tester.pumpWidget(_makeTestableWidget(TVDetailPage(
        id: testTVShowDetail.id,
      )));

      final buttonFinder = find.byType(ElevatedButton);
      final listViewFinder = find.byType(ListView);

      expect(buttonFinder, findsOneWidget);
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockDetailTVBloc.state)
          .thenReturn(const DetailTVErrorState(message: 'Error'));
      when(() => mockWatchlistStatusTVCubit.state).thenReturn(
          const WatchlistStatusTVState(isAddedWatchlist: false, message: ''));
      when(() => mockRecommendationTVBloc.state)
          .thenReturn(const RecommendationTVErrorState(message: 'Error'));

      await tester.pumpWidget(_makeTestableWidget(TVDetailPage(
        id: testTVShowDetail.id,
      )));

      final textFinder = find.byKey(const Key('error_message'));
      expect(textFinder, findsOneWidget);
    });
  });

  group('TV Page, Detail TV Widgets:', () {
    testWidgets(
        'watchlist button should display add icon when movie not added to watchlist',
        (tester) async {
      final watchlistButton = find.byType(ElevatedButton);
      final iconButton = find.byIcon(Icons.add);

      when(() => mockDetailTVBloc.state)
          .thenReturn(DetailTVHasDataState(result: testTVShowDetail));
      when(() => mockWatchlistStatusTVCubit.state).thenReturn(
          const WatchlistStatusTVState(isAddedWatchlist: false, message: ''));
      when(() => mockRecommendationTVBloc.state)
          .thenReturn(RecommendationTVHasDataState(result: testTVShowsList));

      await tester.pumpWidget(
          _makeTestableWidget(TVDetailPage(id: testTVShowDetail.id)));

      expect(watchlistButton, findsOneWidget);
      expect(iconButton, findsOneWidget);
    });

    testWidgets(
        'watchlist button should dispay check icon when movie is added to wathclist',
        (tester) async {
      final watchlistButton = find.byType(ElevatedButton);
      final iconButton = find.byIcon(Icons.check);

      when(() => mockDetailTVBloc.state)
          .thenReturn(DetailTVHasDataState(result: testTVShowDetail));
      when(() => mockWatchlistStatusTVCubit.state).thenReturn(
          const WatchlistStatusTVState(isAddedWatchlist: true, message: ''));
      when(() => mockRecommendationTVBloc.state)
          .thenReturn(RecommendationTVHasDataState(result: testTVShowsList));

      await tester.pumpWidget(
          _makeTestableWidget(TVDetailPage(id: testTVShowDetail.id)));

      expect(watchlistButton, findsOneWidget);
      expect(iconButton, findsOneWidget);
    });
  });
}
