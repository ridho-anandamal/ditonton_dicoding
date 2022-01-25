import 'package:dartz/dartz.dart';
import 'package:feature_tv/feature_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockTVRepository extends Mock implements TVRepository {}

void main() {
  late GetWatchlistTVShows usecase;
  late MockTVRepository repository;

  setUp(() {
    repository = MockTVRepository();
    usecase = GetWatchlistTVShows(repository: repository);
  });

  group('TV Use Cases, Get TV Watchlist:', () {
    test('should get list of movies from the repository', () async {
      // arrange
      when(() => repository.getWatchlistTVShows())
          .thenAnswer((_) async => Right(testTVShowsList));
      // act
      final result = await usecase.execute();
      // assert
      expect(result, Right(testTVShowsList));
    });
  });
}
