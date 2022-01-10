import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tv/remove_watchlist_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveWatchlistTV usecase;
  late MockTVRepository repository;

  setUp(() {
    repository = MockTVRepository();
    usecase = RemoveWatchlistTV(repository: repository);
  });

  test('should remove watchlist movie from repository', () async {
    // arrange
    when(repository.removeWatchlistTV(testTVShowDetail))
        .thenAnswer((_) async => Right('Removed from Watchlist'));
    // act
    final result = await usecase.execute(testTVShowDetail);
    // assert
    expect(result, Right('Removed from Watchlist'));
  });
}
