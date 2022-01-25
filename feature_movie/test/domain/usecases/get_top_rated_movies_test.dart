import 'package:dartz/dartz.dart';
import 'package:feature_movie/feature_movie.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late GetTopRatedMovies usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetTopRatedMovies(mockMovieRepository);
  });

  final tMovies = <Movie>[];

  group('Movie Use Cases, Get Movie Top Rated:', () {
    test('should get list of movies from repository', () async {
      // arrange
      when(() => mockMovieRepository.getTopRatedMovies())
          .thenAnswer((_) async => Right(tMovies));
      // act
      final result = await usecase.execute();
      // assert
      expect(result, Right(tMovies));
    });
  });
}
