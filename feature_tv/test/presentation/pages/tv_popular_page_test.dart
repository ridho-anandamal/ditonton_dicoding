import 'package:bloc_test/bloc_test.dart';
import 'package:feature_tv/presentation/blocs/popular_tv_bloc.dart';
import 'package:feature_tv/presentation/pages/popular_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/dummy_objects.dart';


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

  group('TV Page, Popular TV Page:', () {
    testWidgets('page should nothing when empty', (WidgetTester tester) async {
      when(() => mockPopularTVBloc.state)
          .thenReturn(PopularTVEmptyState());
      await tester.pumpWidget(_makeTestableWidget(const PopularTVPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsNothing);
    });

    testWidgets('page should display center progress bar when loading',
        (WidgetTester tester) async {
      when(() => mockPopularTVBloc.state)
          .thenReturn(PopularTVLoadingState());
      await tester.pumpWidget(_makeTestableWidget(const PopularTVPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('page should display ListView when data is loaded',
        (WidgetTester tester) async {
      when(() => mockPopularTVBloc.state)
          .thenReturn(PopularTVHasDataState(result: testTVShowsList));

      await tester.pumpWidget(_makeTestableWidget(const PopularTVPage()));

      final listViewFinder = find.byType(ListView);
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockPopularTVBloc.state)
          .thenReturn(const PopularTVErrorState(message: 'Error'));

      await tester.pumpWidget(_makeTestableWidget(const PopularTVPage()));

      final textFinder = find.byKey(const Key('error_message'));
      expect(textFinder, findsOneWidget);
    });
  });
}