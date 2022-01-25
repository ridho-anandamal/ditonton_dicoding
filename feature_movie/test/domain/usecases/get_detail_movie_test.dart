import 'package:dartz/dartz.dart';
import 'package:feature_movie/feature_movie.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late GetMovieDetail usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetMovieDetail(mockMovieRepository);
  });

  const tId = 1;

  group('Movie Use Cases, Get Movie Detail:', () {
    test('should get movie detail from the repository', () async {
      // arrange
      when(() => mockMovieRepository.getMovieDetail(tId))
          .thenAnswer((_) async => const Right(testMovieDetail));
      // act
      final result = await usecase.execute(tId);
      // assert
      expect(result, const Right(testMovieDetail));
    });
  });
}
