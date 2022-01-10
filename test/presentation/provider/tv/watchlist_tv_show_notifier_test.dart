import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv_shows.dart';
import 'package:ditonton/presentation/provider/tv/watchlist_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv_data/dummy_objects.dart';
import 'watchlist_tv_show_notifier_test.mocks.dart';

@GenerateMocks([GetWatchlistTVShows])
void main() {
  late WatchlistTVNotifier notifier;
  late MockGetWatchlistTVShows mockGetWatchlistTVShows;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetWatchlistTVShows = MockGetWatchlistTVShows();
    notifier = WatchlistTVNotifier(getWatchlistTVShows: mockGetWatchlistTVShows)
      ..addListener(() {
        listenerCallCount += 1;
      });
  });

  test('should change tv shows data when data is gotten successfully',
      () async {
    // arrange
    when(mockGetWatchlistTVShows.execute())
        .thenAnswer((_) async => Right([testWatchlistTV]));
    // act
    await notifier.fetchWatchlistTVShows();
    // assert
    expect(notifier.watchlistState, RequestState.Loaded);
    expect(notifier.watchlistTVShows, [testWatchlistTV]);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetWatchlistTVShows.execute())
        .thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
    // act
    await notifier.fetchWatchlistTVShows();
    // assert
    expect(notifier.watchlistState, RequestState.Error);
    expect(notifier.message, "Can't get data");
    expect(listenerCallCount, 2);
  });
}
