// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:feature_tv/presentation/blocs/search_tv_bloc.dart';
import 'package:feature_tv/presentation/pages/search_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/dummy_objects.dart';


class MockSearchTVBloc extends MockBloc<SearchTVEvent, SearchTVState>
    implements SearchTVBloc {}

class SearchTVEventFake extends Fake implements SearchTVEvent {}

class SearchTVStateFake extends Fake implements SearchTVState {}

void main() {
  late MockSearchTVBloc mockSearchTVBloc;

  setUpAll(() {
    registerFallbackValue(SearchTVEventFake());
    registerFallbackValue(SearchTVStateFake());
  });

  setUp(() {
    mockSearchTVBloc = MockSearchTVBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<SearchTVBloc>.value(
      value: mockSearchTVBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('TV Page, Search TV Page:', () {
    testWidgets('page should nothing when empty', (WidgetTester tester) async {
      when(() => mockSearchTVBloc.state).thenReturn(SearchTVEmptyState());
      await tester.pumpWidget(_makeTestableWidget(SearchTVPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsNothing);
    });

    testWidgets('page should display center progress bar when loading',
        (WidgetTester tester) async {
      when(() => mockSearchTVBloc.state)
          .thenReturn(SearchTVLoadingState());
      await tester.pumpWidget(_makeTestableWidget(SearchTVPage()));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('page should display ListView when data is loaded',
        (WidgetTester tester) async {
      when(() => mockSearchTVBloc.state)
          .thenReturn(SearchTVHasDataState(result: testTVShowsList));

      await tester.pumpWidget(_makeTestableWidget(SearchTVPage()));

      final listViewFinder = find.byType(ListView);
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockSearchTVBloc.state)
          .thenReturn(SearchTVErrorState(message: 'Error'));

      await tester.pumpWidget(_makeTestableWidget(SearchTVPage()));

      final textFinder = find.byKey(const Key('error_message'));
      expect(textFinder, findsOneWidget);
    });
  });
}
