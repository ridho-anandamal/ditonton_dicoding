import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:feature_tv/feature_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockGetWatchListStatusTV extends Mock implements GetWatchListStatusTV {}

class MockSaveWatchlistTV extends Mock implements SaveWatchlistTV {}

class MockRemoveWatchlistTV extends Mock implements RemoveWatchlistTV {}

void main() {
  late MockGetWatchListStatusTV mockGetWatchListStatusTV;
  late MockSaveWatchlistTV mockSaveWatchlistTV;
  late MockRemoveWatchlistTV mockRemoveWatchlistTV;
  late WatchlistStatusTVCubit watchlistStatusTVCubit;

  setUp(() {
    mockGetWatchListStatusTV = MockGetWatchListStatusTV();
    mockSaveWatchlistTV = MockSaveWatchlistTV();
    mockRemoveWatchlistTV = MockRemoveWatchlistTV();
    watchlistStatusTVCubit = WatchlistStatusTVCubit(
      getWatchListStatusTV: mockGetWatchListStatusTV,
      saveWatchlistTV: mockSaveWatchlistTV,
      removeWatchlistTV: mockRemoveWatchlistTV,
    );
  });

  const tId = 1;

  group('TV Bloc, Get Watchlist Status TV:', () {
    blocTest<WatchlistStatusTVCubit, WatchlistStatusTVState>(
      'should get watchlist true',
      build: () {
        when(() => mockGetWatchListStatusTV.execute(tId)).thenAnswer((_) async => true);
        return watchlistStatusTVCubit;
      },
      act: (bloc) => bloc.loadWatchlistStatus(tId),
      expect: () => [
        const WatchlistStatusTVState(isAddedWatchlist: true, message: ''),
      ],
    );
  });

  group('TV Bloc, Save Watchlist TV:', () {
    blocTest<WatchlistStatusTVCubit, WatchlistStatusTVState>(
      'should execute save watchlist when function called',
      build: () {
        when(() => mockSaveWatchlistTV.execute(testTVShowDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(() => mockGetWatchListStatusTV.execute(testTVShowDetail.id))
            .thenAnswer((_) async => true);
        return watchlistStatusTVCubit;
      },
      act: (bloc) => bloc.addWatchlistTV(testTVShowDetail),
      expect: () => [
        const WatchlistStatusTVState(
            isAddedWatchlist: true, message: 'Added to Watchlist'),
      ],
    );

    blocTest<WatchlistStatusTVCubit, WatchlistStatusTVState>(
      'should update watchlist message when add watchlist failed',
      build: () {
        when(() => mockSaveWatchlistTV.execute(testTVShowDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        when(() => mockGetWatchListStatusTV.execute(testTVShowDetail.id))
            .thenAnswer((_) async => false);
        return watchlistStatusTVCubit;
      },
      act: (bloc) => bloc.addWatchlistTV(testTVShowDetail),
      expect: () => [
        const WatchlistStatusTVState(isAddedWatchlist: false, message: 'Failed'),
      ],
    );
  });

  group('TV Bloc, Remove Watchlist TV:', () {
    blocTest<WatchlistStatusTVCubit, WatchlistStatusTVState>(
      'should execute remove watchlist when function called',
      build: () {
        when(() => mockRemoveWatchlistTV.execute(testTVShowDetail))
            .thenAnswer((_) async => const Right('Removed'));
        when(() => mockGetWatchListStatusTV.execute(testTVShowDetail.id))
            .thenAnswer((_) async => true);
        return watchlistStatusTVCubit;
      },
      act: (bloc) => bloc.removeFromWatchlistTV(testTVShowDetail),
      expect: () => [
        const WatchlistStatusTVState(isAddedWatchlist: true, message: 'Removed'),
      ],
    );

    blocTest<WatchlistStatusTVCubit, WatchlistStatusTVState>(
      'should update watchlist message when remove watchlist failed',
      build: () {
        when(() => mockRemoveWatchlistTV.execute(testTVShowDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        when(() => mockGetWatchListStatusTV.execute(testTVShowDetail.id))
            .thenAnswer((_) async => false);
        return watchlistStatusTVCubit;
      },
      act: (bloc) => bloc.removeFromWatchlistTV(testTVShowDetail),
      expect: () => [
        const WatchlistStatusTVState(isAddedWatchlist: false, message: 'Failed'),
      ],
    );
  });
}
