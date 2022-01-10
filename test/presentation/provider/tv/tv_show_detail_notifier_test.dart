import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_show_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_shows_recommendation.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_status_tv.dart';
import 'package:ditonton/domain/usecases/tv/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/tv/save_watchlist_tv.dart';
import 'package:ditonton/presentation/provider/tv/tv_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv_data/dummy_objects.dart';
import 'tv_show_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTVShowDetail,
  GetTVShowsRecommendation,
  GetWatchListStatusTV,
  SaveWatchlistTV,
  RemoveWatchlistTV,
])
void main() {
  late TVDetailNotifier notifier;
  late MockGetTVShowDetail mockGetTVShowDetail;
  late MockGetTVShowsRecommendation mockGetTVShowsRecommendation;
  late MockGetWatchListStatusTV mockGetWatchListStatusTV;
  late MockSaveWatchlistTV mockSaveWatchlistTV;
  late MockRemoveWatchlistTV mockRemoveWatchlistTV;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTVShowDetail = MockGetTVShowDetail();
    mockGetTVShowsRecommendation = MockGetTVShowsRecommendation();
    mockGetWatchListStatusTV = MockGetWatchListStatusTV();
    mockSaveWatchlistTV = MockSaveWatchlistTV();
    mockRemoveWatchlistTV = MockRemoveWatchlistTV();
    notifier = TVDetailNotifier(
        getTVShowDetail: mockGetTVShowDetail,
        getTVShowsRecommendation: mockGetTVShowsRecommendation,
        getWatchListStatusTV: mockGetWatchListStatusTV,
        saveWatchlistTV: mockSaveWatchlistTV,
        removeWatchlistTV: mockRemoveWatchlistTV)
      ..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tId = 1;
  final tTVShow = TV(
    backdropPath: 'backdropPath',
    firstAirDate: DateTime.parse("2010-09-17"),
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

  void _arrangeUsecase() {
    when(mockGetTVShowDetail.execute(tId))
      ..thenAnswer((_) async => Right(testTVShowDetail));
    when(mockGetTVShowsRecommendation.execute(tId))
      ..thenAnswer((_) async => Right(tTVShowsList));
  }

  group('Get TV Show Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await notifier.fetchTVShowDetail(tId);
      // assert
      verify(mockGetTVShowDetail.execute(tId));
      verify(mockGetTVShowsRecommendation.execute(tId));
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      _arrangeUsecase();
      // act
      notifier.fetchTVShowDetail(tId);
      // assert
      expect(notifier.tvState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should change tv show when data is gotten successfully', () async {
      // arrange
      _arrangeUsecase();
      // act
      await notifier.fetchTVShowDetail(tId);
      // assert
      expect(notifier.tvState, RequestState.Loaded);
      expect(notifier.tvDetail, testTVShowDetail);
      expect(listenerCallCount, 3);
    });

    test(
        'should change recommendation tv show when data is gotten successfully',
        () async {
      // arrange
      _arrangeUsecase();
      // act
      await notifier.fetchTVShowDetail(tId);
      // assert
      expect(notifier.tvState, RequestState.Loaded);
      expect(notifier.tvRecommendation, tTVShowsList);
    });
  });

  group('Get TV Show Recommendation', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await notifier.fetchTVShowDetail(tId);
      // assert
      verify(mockGetTVShowsRecommendation.execute(tId));
      expect(notifier.tvRecommendation, tTVShowsList);
    });

    test('should update recommendation state when data is gotten successfully',
        () async {
      // arrange
      _arrangeUsecase();
      // act
      await notifier.fetchTVShowDetail(tId);
      // assert
      expect(notifier.recommendationState, RequestState.Loaded);
      expect(notifier.tvRecommendation, tTVShowsList);
    });

    test('should update error message when request in successful', () async {
      // arrange
      when(mockGetTVShowDetail.execute(tId))
          .thenAnswer((_) async => Right(testTVShowDetail));
      when(mockGetTVShowsRecommendation.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Failed')));
      // act
      await notifier.fetchTVShowDetail(tId);
      // assert
      expect(notifier.recommendationState, RequestState.Error);
      expect(notifier.message, 'Failed');
    });
  });

  group('Watchlist', () {
    test('should get the watchlist status', () async {
      // arrange
      when(mockGetWatchListStatusTV.execute(1)).thenAnswer((_) async => true);
      // act
      await notifier.loadWatchlistStatus(1);
      // assert
      expect(notifier.isAddedToWatchlist, true);
    });

    test('should execute save watchlist when function called', () async {
      // arrange
      when(mockSaveWatchlistTV.execute(testTVShowDetail))
          .thenAnswer((_) async => Right('Success'));
      when(mockGetWatchListStatusTV.execute(testTVShowDetail.id))
          .thenAnswer((_) async => true);
      // act
      await notifier.addWatchlistTV(testTVShowDetail);
      // assert
      verify(mockSaveWatchlistTV.execute(testTVShowDetail));
    });

    test('should update watchlist status when add watchlist success', () async {
      // arrange
      when(mockSaveWatchlistTV.execute(testTVShowDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      when(mockGetWatchListStatusTV.execute(testTVShowDetail.id))
          .thenAnswer((_) async => true);
      // act
      await notifier.addWatchlistTV(testTVShowDetail);
      // assert
      verify(mockGetWatchListStatusTV.execute(testTVShowDetail.id));
      expect(notifier.isAddedToWatchlist, true);
      expect(notifier.watchlistMessage, 'Added to Watchlist');
      expect(listenerCallCount, 1);
    });

    test('should update watchlist message when add watchlist failed', () async {
      // arrange
      when(mockSaveWatchlistTV.execute(testTVShowDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchListStatusTV.execute(testTVShowDetail.id))
          .thenAnswer((_) async => false);
      // act
      await notifier.addWatchlistTV(testTVShowDetail);
      // assert
      expect(notifier.watchlistMessage, 'Failed');
      expect(listenerCallCount, 1);
    });
  });

  group('on Error', () {
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTVShowDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetTVShowsRecommendation.execute(tId))
          .thenAnswer((_) async => Right(tTVShowsList));
      // act
      await notifier.fetchTVShowDetail(tId);
      // assert
      expect(notifier.tvState, RequestState.Error);
      expect(notifier.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
