import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_status_tv.dart';
import 'package:ditonton/domain/usecases/tv/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/tv/save_watchlist_tv.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist_status_tv_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv_data/dummy_objects.dart';
import 'tv_watchlist_status_cubit_test.mocks.dart';

@GenerateMocks([
  GetWatchListStatusTV,
  SaveWatchlistTV,
  RemoveWatchlistTV,
])
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

  final tId = 1;

  group('Get Watchlist Status Movie', () {
    blocTest<WatchlistStatusTVCubit, WatchlistStatusTVState>(
      'Should get watchlist true',
      build: () {
        when(mockGetWatchListStatusTV.execute(tId)).thenAnswer((_) async => true);
        return watchlistStatusTVCubit;
      },
      act: (bloc) => bloc.loadWatchlistStatus(tId),
      expect: () => [
        WatchlistStatusTVState(isAddedWatchlist: true, message: ''),
      ],
    );
  });

  group('Save watchlist movie', () {
    blocTest<WatchlistStatusTVCubit, WatchlistStatusTVState>(
      'Should execute save watchlist when function called',
      build: () {
        when(mockSaveWatchlistTV.execute(testTVShowDetail))
            .thenAnswer((_) async => Right('Added to Watchlist'));
        when(mockGetWatchListStatusTV.execute(testTVShowDetail.id))
            .thenAnswer((_) async => true);
        return watchlistStatusTVCubit;
      },
      act: (bloc) => bloc.addWatchlistTV(testTVShowDetail),
      expect: () => [
        WatchlistStatusTVState(
            isAddedWatchlist: true, message: 'Added to Watchlist'),
      ],
    );

    blocTest<WatchlistStatusTVCubit, WatchlistStatusTVState>(
      'Should update watchlist message when add watchlist failed',
      build: () {
        when(mockSaveWatchlistTV.execute(testTVShowDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchListStatusTV.execute(testTVShowDetail.id))
            .thenAnswer((_) async => false);
        return watchlistStatusTVCubit;
      },
      act: (bloc) => bloc.addWatchlistTV(testTVShowDetail),
      expect: () => [
        WatchlistStatusTVState(isAddedWatchlist: false, message: 'Failed'),
      ],
    );
  });

  group('Remove watchlist movie', () {
    blocTest<WatchlistStatusTVCubit, WatchlistStatusTVState>(
      'Should execute remove watchlist when function called',
      build: () {
        when(mockRemoveWatchlistTV.execute(testTVShowDetail))
            .thenAnswer((_) async => Right('Removed'));
        when(mockGetWatchListStatusTV.execute(testTVShowDetail.id))
            .thenAnswer((_) async => true);
        return watchlistStatusTVCubit;
      },
      act: (bloc) => bloc.removeFromWatchlistTV(testTVShowDetail),
      expect: () => [
        WatchlistStatusTVState(isAddedWatchlist: true, message: 'Removed'),
      ],
    );

    blocTest<WatchlistStatusTVCubit, WatchlistStatusTVState>(
      'Should update watchlist message when remove watchlist failed',
      build: () {
        when(mockRemoveWatchlistTV.execute(testTVShowDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchListStatusTV.execute(testTVShowDetail.id))
            .thenAnswer((_) async => false);
        return watchlistStatusTVCubit;
      },
      act: (bloc) => bloc.removeFromWatchlistTV(testTVShowDetail),
      expect: () => [
        WatchlistStatusTVState(isAddedWatchlist: false, message: 'Failed'),
      ],
    );
  });
}
