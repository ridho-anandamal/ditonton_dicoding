import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/tv/top_rated_tv_bloc.dart';
import 'package:ditonton/presentation/pages/tv/top_rated_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/tv_data/dummy_objects.dart';

class MockTopRatedTVBloc
    extends MockBloc<TopRatedTVEvent, TopRatedTVState>
    implements TopRatedTVBloc {}

class TopRatedTVEventFake extends Fake implements TopRatedTVEvent {}

class TopRatedTVStateFake extends Fake implements TopRatedTVState {}

void main() {
  late MockTopRatedTVBloc mockTopRatedTVBloc;

  setUpAll(() {
    registerFallbackValue(TopRatedTVEventFake());
    registerFallbackValue(TopRatedTVStateFake());
  });

  setUp(() {
    mockTopRatedTVBloc = MockTopRatedTVBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTVBloc>.value(
      value: mockTopRatedTVBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('Top Rated TV Page Test:', () {
    testWidgets('Page should nothing when empty', (WidgetTester tester) async {
      when(() => mockTopRatedTVBloc.state)
          .thenReturn(TopRatedTVEmptyState());
      await tester.pumpWidget(_makeTestableWidget(TopRatedTVPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsNothing);
    });
    
    testWidgets('Page should display center progress bar when loading',
        (WidgetTester tester) async {
      when(() => mockTopRatedTVBloc.state)
          .thenReturn(TopRatedTVLoadingState());
      await tester.pumpWidget(_makeTestableWidget(TopRatedTVPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('Page should display ListView when data is loaded',
        (WidgetTester tester) async {
      when(() => mockTopRatedTVBloc.state)
          .thenReturn(TopRatedTVHasDataState(result: testTVShowsList));

      await tester.pumpWidget(_makeTestableWidget(TopRatedTVPage()));

      final listViewFinder = find.byType(ListView);
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('Page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockTopRatedTVBloc.state)
          .thenReturn(TopRatedTVErrorState(message: 'Error'));

      await tester.pumpWidget(_makeTestableWidget(TopRatedTVPage()));

      final textFinder = find.byKey(Key('error_message'));
      expect(textFinder, findsOneWidget);
    });
  });
}