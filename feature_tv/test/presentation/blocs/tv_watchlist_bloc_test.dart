import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:feature_tv/domain/usecases/get_watchlist_tv_shows.dart';
import 'package:feature_tv/presentation/blocs/watchlist_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockGetWatchlistTVShows extends Mock implements GetWatchlistTVShows {}

void main() {
  late MockGetWatchlistTVShows mockGetWatchlistTVShows;
  late WatchlistTVBloc watchlistTVBloc;

  setUp(() {
    mockGetWatchlistTVShows = MockGetWatchlistTVShows();
    watchlistTVBloc =
        WatchlistTVBloc(getWatchlistTVShows: mockGetWatchlistTVShows);
  });

  group('TV Bloc, Watchlist TV Shows:', () {
    test('initialState should be Empty', () {
      expect(watchlistTVBloc.state, WatchlistTVEmptyState());
    });

    blocTest<WatchlistTVBloc, WatchlistTVState>(
      'should emit[Loading, HasData] when data is gotten successfully',
      build: () {
        when(() => mockGetWatchlistTVShows.execute())
            .thenAnswer((_) async => Right([testWatchlistTV]));
        return watchlistTVBloc;
      },
      act: (bloc) => bloc.add(FetchNowWatchlistTVShows()),
      expect: () => [
        WatchlistTVLoadingState(),
        WatchlistTVHasDataState(result: [testWatchlistTV])
      ],
      verify: (bloc) => verify(() => mockGetWatchlistTVShows.execute()),
    );

    blocTest<WatchlistTVBloc, WatchlistTVState>(
      'should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(() => mockGetWatchlistTVShows.execute())
            .thenAnswer((_) async => const Left(DatabaseFailure("Can't get data")));
        return watchlistTVBloc;
      },
      act: (bloc) => bloc.add(FetchNowWatchlistTVShows()),
      expect: () => [
        WatchlistTVLoadingState(),
        const WatchlistTVErrorState(message: "Can't get data"),
      ],
      verify: (bloc) => verify(() => mockGetWatchlistTVShows.execute()),
    );
  });
}
