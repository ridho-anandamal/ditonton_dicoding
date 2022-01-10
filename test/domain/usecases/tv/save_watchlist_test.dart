import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tv/save_watchlist_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late SaveWatchlistTV usecase;
  late MockTVRepository repository;

  setUp(() {
    repository = MockTVRepository();
    usecase = SaveWatchlistTV(repository: repository);
  });

  test('should save movie to the repository', () async {
    // arrange
    when(repository.saveWatchlistTV(testTVShowDetail))
        .thenAnswer((_) async => Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(testTVShowDetail);
    // assert
    expect(result, Right('Added to Watchlist'));
  });
}
