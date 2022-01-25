import 'package:dartz/dartz.dart';
import 'package:feature_movie/feature_movie.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late SearchMovies usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = SearchMovies(mockMovieRepository);
  });

  final tMovies = <Movie>[];
  const tQuery = 'Spiderman';

  group('Movie Use Cases, Get Movie Search:', () {
    test('should get list of movies from the repository', () async {
      // arrange
      when(() => mockMovieRepository.searchMovies(tQuery))
          .thenAnswer((_) async => Right(tMovies));
      // act
      final result = await usecase.execute(tQuery);
      // assert
      expect(result, Right(tMovies));
    });
  });
}
