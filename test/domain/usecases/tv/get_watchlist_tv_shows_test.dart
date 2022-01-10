import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv_shows.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistTVShows usecase;
  late MockTVRepository repository;

  setUp(() {
    repository = MockTVRepository();
    usecase = GetWatchlistTVShows(repository: repository);
  });

  test('should get list of movies from the repository', () async {
    // arrange
    when(repository.getWatchlistTVShows())
        .thenAnswer((_) async => Right(testTVShowsList));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(testTVShowsList));
  });
}
