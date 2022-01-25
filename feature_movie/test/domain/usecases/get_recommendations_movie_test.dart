import 'package:dartz/dartz.dart';
import 'package:feature_movie/feature_movie.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late GetMovieRecommendations usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetMovieRecommendations(mockMovieRepository);
  });

  const tId = 1;
  final tMovies = <Movie>[];

  group('Movie Use Cases, Get Movie Recommendation:', () {
    test('should get list of movie recommendations from the repository',
        () async {
      // arrange
      when(() => mockMovieRepository.getMovieRecommendations(tId))
          .thenAnswer((_) async => Right(tMovies));
      // act
      final result = await usecase.execute(tId);
      // assert
      expect(result, Right(tMovies));
    });
  });
}