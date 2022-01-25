import 'package:dartz/dartz.dart';
import 'package:feature_tv/feature_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockTVRepository extends Mock implements TVRepository {}

void main() {
  late RemoveWatchlistTV usecase;
  late MockTVRepository repository;

  setUp(() {
    repository = MockTVRepository();
    usecase = RemoveWatchlistTV(repository: repository);
  });

  group('TV Use Cases, Remove TV Watchlist:', () {
    test('should remove watchlist movie from repository', () async {
      // arrange
      when(() => repository.removeWatchlistTV(testTVShowDetail))
          .thenAnswer((_) async => const Right('Removed from Watchlist'));
      // act
      final result = await usecase.execute(testTVShowDetail);
      // assert
      expect(result, const Right('Removed from Watchlist'));
    });
  });
}
