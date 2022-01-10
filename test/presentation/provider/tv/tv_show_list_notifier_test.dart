import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_on_the_air_tv_shows.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tv_shows.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tv_shows.dart';
import 'package:ditonton/presentation/provider/tv/tv_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_show_list_notifier_test.mocks.dart';

@GenerateMocks([
  GetOnTheAirTVShows,
  GetPopularTVShows,
  GetTopRatedTVShows,
])
void main() {
  late TVListNotifier notifier;
  late MockGetOnTheAirTVShows mockGetOnTheAirTVShows;
  late MockGetPopularTVShows mockGetPopularTVShows;
  late MockGetTopRatedTVShows mockGetTopRatedTVShows;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetOnTheAirTVShows = MockGetOnTheAirTVShows();
    mockGetPopularTVShows = MockGetPopularTVShows();
    mockGetTopRatedTVShows = MockGetTopRatedTVShows();
    notifier = TVListNotifier(
      getOnTheAirTVShows: mockGetOnTheAirTVShows,
      getPopularTVShows: mockGetPopularTVShows,
      getTopRatedTVShows: mockGetTopRatedTVShows,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tTVShow = TV(
    backdropPath: 'backdropPath',
    firstAirDate: DateTime.parse("2021-05-23"),
    genreIds: [1, 2, 3],
    id: 1,
    name: 'name',
    originCountry: ['en'],
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1.0,
    posterPath: 'posterPath',
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tTVShowsList = <TV>[tTVShow];

  group('on the air tv shows', () {
    test('initialState should be Empty', () {
      expect(notifier.onTheAirState, equals(RequestState.Empty));
    });

    test('should get data from the usecase', () async {
      // arrange
      when(mockGetOnTheAirTVShows.execute())
          .thenAnswer((_) async => Right(tTVShowsList));
      //  act
      notifier.fetchNowOnTheAirTVShows();
      // assert
      verify(mockGetOnTheAirTVShows.execute());
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      when(mockGetOnTheAirTVShows.execute())
          .thenAnswer((_) async => Right(tTVShowsList));
      // act
      notifier.fetchNowOnTheAirTVShows();
      // assert
      expect(notifier.onTheAirState, RequestState.Loading);
    });

    test('should change tv shows when data is gotten successfully', () async {
      // arrange
      when(mockGetOnTheAirTVShows.execute())
          .thenAnswer((_) async => Right(tTVShowsList));
      // act
      await notifier.fetchNowOnTheAirTVShows();
      // assert
      expect(notifier.onTheAirState, RequestState.Loaded);
      expect(notifier.onTheAirTVShows, tTVShowsList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetOnTheAirTVShows.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await notifier.fetchNowOnTheAirTVShows();
      // assert
      expect(notifier.onTheAirState, RequestState.Error);
      expect(notifier.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('popular tv shows', () {
    test('initialState should be Empty', () {
      expect(notifier.popularState, equals(RequestState.Empty));
    });

    test('should get data from the usecase', () async {
      // arrange
      when(mockGetPopularTVShows.execute())
          .thenAnswer((_) async => Right(tTVShowsList));
      //  act
      notifier.fetchNowPopularTVShows();
      // assert
      verify(mockGetPopularTVShows.execute());
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      when(mockGetPopularTVShows.execute())
          .thenAnswer((_) async => Right(tTVShowsList));
      // act
      notifier.fetchNowPopularTVShows();
      // assert
      expect(notifier.popularState, RequestState.Loading);
    });

    test('should change tv shows when data is gotten successfully', () async {
      // arrange
      when(mockGetPopularTVShows.execute())
          .thenAnswer((_) async => Right(tTVShowsList));
      // act
      await notifier.fetchNowPopularTVShows();
      // assert
      expect(notifier.popularState, RequestState.Loaded);
      expect(notifier.popularTVSHows, tTVShowsList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetPopularTVShows.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await notifier.fetchNowPopularTVShows();
      // assert
      expect(notifier.popularState, RequestState.Error);
      expect(notifier.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('top rated tv shows', () {
    test('initialState should be Empty', () {
      expect(notifier.topRatedState, equals(RequestState.Empty));
    });

    test('should get data from the usecase', () async {
      // arrange
      when(mockGetTopRatedTVShows.execute())
          .thenAnswer((_) async => Right(tTVShowsList));
      //  act
      notifier.fetchNowTopRatedTVShows();
      // assert
      verify(mockGetTopRatedTVShows.execute());
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      when(mockGetTopRatedTVShows.execute())
          .thenAnswer((_) async => Right(tTVShowsList));
      // act
      notifier.fetchNowTopRatedTVShows();
      // assert
      expect(notifier.topRatedState, RequestState.Loading);
    });

    test('should change tv shows when data is gotten successfully', () async {
      // arrange
      when(mockGetTopRatedTVShows.execute())
          .thenAnswer((_) async => Right(tTVShowsList));
      // act
      await notifier.fetchNowTopRatedTVShows();
      // assert
      expect(notifier.topRatedState, RequestState.Loaded);
      expect(notifier.topRatedTVShows, tTVShowsList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTopRatedTVShows.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await notifier.fetchNowTopRatedTVShows();
      // assert
      expect(notifier.topRatedState, RequestState.Error);
      expect(notifier.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
