import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/movie/detail_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/recommendation_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist_status_movie_cubit.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/dummy_objects.dart';

class MockDetailMovieBloc extends MockBloc<DetailMovieEvent, DetailMovieState>
    implements DetailMovieBloc {}

class DetailMovieEventFake extends Fake implements DetailMovieEvent {}

class DetailMovieStateFake extends Fake implements DetailMovieState {}

class MockRecommendationMovieBloc
    extends MockBloc<RecommendationMovieEvent, RecommendationMovieState>
    implements RecommendationMovieBloc {}

class RecommendationMovieEventFake extends Fake
    implements RecommendationMovieEvent {}

class RecommendationMovieStateFake extends Fake
    implements RecommendationMovieState {}

class MockWatchlistStatusMovieCubit extends MockCubit<WatchlistStatusMovieState>
    implements WatchlistStatusMovieCubit {}

class WatchlistStatusMovieStateFake extends Fake
    implements WatchlistStatusMovieState {}

void main() {
  late MockDetailMovieBloc mockDetailMovieBloc;
  late MockRecommendationMovieBloc mockRecommendationMovieBloc;
  late MockWatchlistStatusMovieCubit mockWatchlistStatusMovieCubit;

  setUpAll(() {
    registerFallbackValue(DetailMovieEventFake());
    registerFallbackValue(DetailMovieStateFake());
  });

  setUp(() {
    mockDetailMovieBloc = MockDetailMovieBloc();
    mockRecommendationMovieBloc = MockRecommendationMovieBloc();
    mockWatchlistStatusMovieCubit = MockWatchlistStatusMovieCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DetailMovieBloc>.value(value: mockDetailMovieBloc),
        BlocProvider<RecommendationMovieBloc>.value(
            value: mockRecommendationMovieBloc),
        BlocProvider<WatchlistStatusMovieCubit>.value(
          value: mockWatchlistStatusMovieCubit,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('Detail Movie Page Test:', () {
    testWidgets('Page should nothing when empty', (WidgetTester tester) async {
      when(() => mockDetailMovieBloc.state).thenReturn(DetailMovieEmptyState());
      when(() => mockWatchlistStatusMovieCubit.state).thenReturn(
          WatchlistStatusMovieState(isAddedWatchlist: false, message: ''));
      when(() => mockRecommendationMovieBloc.state)
          .thenReturn(RecommendationMovieEmptyState());

      await tester.pumpWidget(
          _makeTestableWidget(MovieDetailPage(id: testMovieDetail.id)));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsNothing);
    });

    testWidgets('Page should display center progress bar when loading',
        (WidgetTester tester) async {
      when(() => mockDetailMovieBloc.state)
          .thenReturn(DetailMovieLoadingState());
      when(() => mockWatchlistStatusMovieCubit.state).thenReturn(
          WatchlistStatusMovieState(isAddedWatchlist: false, message: ''));
      when(() => mockRecommendationMovieBloc.state)
          .thenReturn(RecommendationMovieLoadingState());

      await tester.pumpWidget(
          _makeTestableWidget(MovieDetailPage(id: testMovieDetail.id)));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('Page should display Detail when data is loaded',
        (WidgetTester tester) async {
      when(() => mockDetailMovieBloc.state)
          .thenReturn(DetailMovieHasDataState(result: testMovieDetail));
      when(() => mockWatchlistStatusMovieCubit.state).thenReturn(
          WatchlistStatusMovieState(isAddedWatchlist: false, message: ''));
      when(() => mockRecommendationMovieBloc.state)
          .thenReturn(RecommendationMovieHasDataState(result: testMovieList));

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(
        id: testMovieDetail.id,
      )));

      final buttonFinder = find.byType(ElevatedButton);
      final listViewFinder = find.byType(ListView);

      expect(buttonFinder, findsOneWidget);
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('Page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockDetailMovieBloc.state)
          .thenReturn(DetailMovieErrorState(message: 'Error'));
      when(() => mockWatchlistStatusMovieCubit.state).thenReturn(
          WatchlistStatusMovieState(isAddedWatchlist: false, message: ''));
      when(() => mockRecommendationMovieBloc.state)
          .thenReturn(RecommendationMovieErrorState(message: 'Error'));

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(
        id: testMovieDetail.id,
      )));

      final textFinder = find.byKey(Key('error_message'));
      expect(textFinder, findsOneWidget);
    });
  });

  group('Check button on Detail Page:', () {
    testWidgets(
        'Watchlist button should display add icon when movie not added to watchlist',
        (tester) async {
      final watchlistButton = find.byType(ElevatedButton);
      final iconButton = find.byIcon(Icons.add);

      when(() => mockDetailMovieBloc.state)
          .thenReturn(DetailMovieHasDataState(result: testMovieDetail));
      when(() => mockWatchlistStatusMovieCubit.state).thenReturn(
          WatchlistStatusMovieState(isAddedWatchlist: false, message: ''));
      when(() => mockRecommendationMovieBloc.state)
          .thenReturn(RecommendationMovieHasDataState(result: testMovieList));

      await tester.pumpWidget(
          _makeTestableWidget(MovieDetailPage(id: testMovieDetail.id)));

      expect(watchlistButton, findsOneWidget);
      expect(iconButton, findsOneWidget);
    });

    testWidgets(
        'Watchlist button should dispay check icon when movie is added to wathclist',
        (tester) async {
      final watchlistButton = find.byType(ElevatedButton);
      final iconButton = find.byIcon(Icons.check);

      when(() => mockDetailMovieBloc.state)
          .thenReturn(DetailMovieHasDataState(result: testMovieDetail));
      when(() => mockWatchlistStatusMovieCubit.state).thenReturn(
          WatchlistStatusMovieState(isAddedWatchlist: true, message: ''));
      when(() => mockRecommendationMovieBloc.state)
          .thenReturn(RecommendationMovieHasDataState(result: testMovieList));

      await tester.pumpWidget(
          _makeTestableWidget(MovieDetailPage(id: testMovieDetail.id)));

      expect(watchlistButton, findsOneWidget);
      expect(iconButton, findsOneWidget);
    });
  });
}
