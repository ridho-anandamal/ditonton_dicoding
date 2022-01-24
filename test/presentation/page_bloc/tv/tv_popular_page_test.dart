import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/tv/popular_tv_bloc.dart';
import 'package:ditonton/presentation/pages/tv/popular_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/tv_data/dummy_objects.dart';

class MockPopularTVBloc
    extends MockBloc<PopularTVEvent, PopularTVState>
    implements PopularTVBloc {}

class PopularTVEventFake extends Fake implements PopularTVEvent {}

class PopularTVStateFake extends Fake implements PopularTVState {}

void main() {
  late MockPopularTVBloc mockPopularTVBloc;

  setUpAll(() {
    registerFallbackValue(PopularTVEventFake());
    registerFallbackValue(PopularTVStateFake());
  });

  setUp(() {
    mockPopularTVBloc = MockPopularTVBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularTVBloc>.value(
      value: mockPopularTVBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('Popular TV Page Test:', () {
    testWidgets('Page should nothing when empty', (WidgetTester tester) async {
      when(() => mockPopularTVBloc.state)
          .thenReturn(PopularTVEmptyState());
      await tester.pumpWidget(_makeTestableWidget(PopularTVPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsNothing);
    });

    testWidgets('Page should display center progress bar when loading',
        (WidgetTester tester) async {
      when(() => mockPopularTVBloc.state)
          .thenReturn(PopularTVLoadingState());
      await tester.pumpWidget(_makeTestableWidget(PopularTVPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('Page should display ListView when data is loaded',
        (WidgetTester tester) async {
      when(() => mockPopularTVBloc.state)
          .thenReturn(PopularTVHasDataState(result: testTVShowsList));

      await tester.pumpWidget(_makeTestableWidget(PopularTVPage()));

      final listViewFinder = find.byType(ListView);
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('Page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockPopularTVBloc.state)
          .thenReturn(PopularTVErrorState(message: 'Error'));

      await tester.pumpWidget(_makeTestableWidget(PopularTVPage()));

      final textFinder = find.byKey(Key('error_message'));
      expect(textFinder, findsOneWidget);
    });
  });
}