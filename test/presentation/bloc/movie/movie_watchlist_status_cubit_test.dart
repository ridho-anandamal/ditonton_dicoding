import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist_status_movie_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'movie_watchlist_status_cubit_test.mocks.dart';

@GenerateMocks([
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;
  late WatchlistStatusMovieCubit watchlistStatusMovieCubit;

  setUp(() {
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    watchlistStatusMovieCubit = WatchlistStatusMovieCubit(
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  final tId = 1;

  group('Get Watchlist Status Movie', () {
    blocTest<WatchlistStatusMovieCubit, WatchlistStatusMovieState>(
      'Should get watchlist true',
      build: () {
        when(mockGetWatchListStatus.execute(tId)).thenAnswer((_) async => true);
        return watchlistStatusMovieCubit;
      },
      act: (bloc) => bloc.loadWatchlistStatus(tId),
      expect: () => [
        WatchlistStatusMovieState(isAddedWatchlist: true, message: ''),
      ],
    );
  });

  group('Save watchlist movie', () {
    blocTest<WatchlistStatusMovieCubit, WatchlistStatusMovieState>(
      'Should execute save watchlist when function called',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Added to Watchlist'));
        when(mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        return watchlistStatusMovieCubit;
      },
      act: (bloc) => bloc.addWatchlistMovie(testMovieDetail),
      expect: () => [
        WatchlistStatusMovieState(
            isAddedWatchlist: true, message: 'Added to Watchlist'),
      ],
    );

    blocTest<WatchlistStatusMovieCubit, WatchlistStatusMovieState>(
      'Should update watchlist message when add watchlist failed',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return watchlistStatusMovieCubit;
      },
      act: (bloc) => bloc.addWatchlistMovie(testMovieDetail),
      expect: () => [
        WatchlistStatusMovieState(isAddedWatchlist: false, message: 'Failed'),
      ],
    );
  });

  group('Remove watchlist movie', () {
    blocTest<WatchlistStatusMovieCubit, WatchlistStatusMovieState>(
      'Should execute remove watchlist when function called',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Removed'));
        when(mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        return watchlistStatusMovieCubit;
      },
      act: (bloc) => bloc.removeFromWatchlistMovie(testMovieDetail),
      expect: () => [
        WatchlistStatusMovieState(isAddedWatchlist: true, message: 'Removed'),
      ],
    );

    blocTest<WatchlistStatusMovieCubit, WatchlistStatusMovieState>(
      'Should update watchlist message when remove watchlist failed',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return watchlistStatusMovieCubit;
      },
      act: (bloc) => bloc.removeFromWatchlistMovie(testMovieDetail),
      expect: () => [
        WatchlistStatusMovieState(isAddedWatchlist: false, message: 'Failed'),
      ],
    );
  });
}
