import 'package:dartz/dartz.dart';
import 'package:feature_tv/feature_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockTVRepository extends Mock implements TVRepository {}

void main() {
  late GetTVShowDetail usecase;
  late MockTVRepository repository;

  setUp(() {
    repository = MockTVRepository();
    usecase = GetTVShowDetail(repository: repository);
  });

  const tId = 1;

  group('TV Use Cases, Get TV Detail:', () {
    test('should get tv show detail from the repository', () async {
      // arrange
      when(() => repository.getTVShowDetail(tId))
          .thenAnswer((_) async => Right(testTVShowDetail));
      // act
      final result = await usecase.execute(tId);
      // assert
      expect(result, Right(testTVShowDetail));
    });
  });
}
