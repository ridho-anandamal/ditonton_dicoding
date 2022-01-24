import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv_shows.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv_data/dummy_objects.dart';
import 'tv_watchlist_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTVShows])
void main() {
  late MockGetWatchlistTVShows mockGetWatchlistTVShows;
  late WatchlistTVBloc watchlistTVBloc;

  setUp(() {
    mockGetWatchlistTVShows = MockGetWatchlistTVShows();
    watchlistTVBloc =
        WatchlistTVBloc(getWatchlistTVShows: mockGetWatchlistTVShows);
  });

  group('Watchlist TV Shows', () {
    test('initialState should be Empty', () {
      expect(watchlistTVBloc.state, WatchlistTVEmptyState());
    });

    blocTest<WatchlistTVBloc, WatchlistTVState>(
      'Should emit[Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetWatchlistTVShows.execute())
            .thenAnswer((_) async => Right([testWatchlistTV]));
        return watchlistTVBloc;
      },
      act: (bloc) => bloc.add(FetchNowWatchlistTVShows()),
      expect: () => [
        WatchlistTVLoadingState(),
        WatchlistTVHasDataState(result: [testWatchlistTV])
      ],
      verify: (bloc) => verify(mockGetWatchlistTVShows.execute()),
    );

    blocTest<WatchlistTVBloc, WatchlistTVState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetWatchlistTVShows.execute())
            .thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
        return watchlistTVBloc;
      },
      act: (bloc) => bloc.add(FetchNowWatchlistTVShows()),
      expect: () => [
        WatchlistTVLoadingState(),
        WatchlistTVErrorState(message: "Can't get data"),
      ],
      verify: (bloc) => verify(mockGetWatchlistTVShows.execute()),
    );
  });
}
