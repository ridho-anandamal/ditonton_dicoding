import 'package:dartz/dartz.dart';
import 'package:feature_tv/feature_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockTVRepository extends Mock implements TVRepository {}

void main() {
  late SaveWatchlistTV usecase;
  late MockTVRepository repository;

  setUp(() {
    repository = MockTVRepository();
    usecase = SaveWatchlistTV(repository: repository);
  });

  group('TV Use Cases, Save TV Watchlist:', () {
    test('should save movie to the repository', () async {
      // arrange
      when(() => repository.saveWatchlistTV(testTVShowDetail))
          .thenAnswer((_) async => const Right('Added to Watchlist'));
      // act
      final result = await usecase.execute(testTVShowDetail);
      // assert
      expect(result, const Right('Added to Watchlist'));
    });
  });
}
