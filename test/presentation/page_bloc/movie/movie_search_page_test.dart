import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/movie/search_movie_bloc.dart';
import 'package:ditonton/presentation/pages/search_movie_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/dummy_objects.dart';

class MockSearchMovieBloc extends MockBloc<SearchMovieEvent, SearchMovieState>
    implements SearchMovieBloc {}

class SearchMovieEventFake extends Fake implements SearchMovieEvent {}

class SearchMovieStateFake extends Fake implements SearchMovieState {}

void main() {
  late MockSearchMovieBloc mockSearchMovieBloc;

  setUpAll(() {
    registerFallbackValue(SearchMovieEventFake());
    registerFallbackValue(SearchMovieStateFake());
  });

  setUp(() {
    mockSearchMovieBloc = MockSearchMovieBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<SearchMovieBloc>.value(
      value: mockSearchMovieBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('Search Movie Page Test:', () {
    testWidgets('Page should nothing when empty', (WidgetTester tester) async {
      when(() => mockSearchMovieBloc.state).thenReturn(SearchMovieEmptyState());
      await tester.pumpWidget(_makeTestableWidget(SearchMoviePage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsNothing);
    });

    testWidgets('Page should display center progress bar when loading',
        (WidgetTester tester) async {
      when(() => mockSearchMovieBloc.state)
          .thenReturn(SearchMovieLoadingState());
      await tester.pumpWidget(_makeTestableWidget(SearchMoviePage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('Page should display ListView when data is loaded',
        (WidgetTester tester) async {
      when(() => mockSearchMovieBloc.state)
          .thenReturn(SearchMovieHasDataState(result: testMovieList));

      await tester.pumpWidget(_makeTestableWidget(SearchMoviePage()));

      final listViewFinder = find.byType(ListView);
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('Page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockSearchMovieBloc.state)
          .thenReturn(SearchMovieErrorState(message: 'Error'));

      await tester.pumpWidget(_makeTestableWidget(SearchMoviePage()));

      final textFinder = find.byKey(Key('error_message'));
      expect(textFinder, findsOneWidget);
    });
  });
}
