import 'package:dartz/dartz.dart';
import 'package:feature_movie/feature_movie.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late GetNowPlayingMovies usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetNowPlayingMovies(mockMovieRepository);
  });

  final tMovies = <Movie>[];

  group('Movie Use Cases, Get Movie Now Playing:', () {
    test('should get list of movies from the repository', () async {
      // arrange
      when(() => mockMovieRepository.getNowPlayingMovies())
          .thenAnswer((_) async => Right(tMovies));
      // act
      final result = await usecase.execute();
      // assert
      expect(result, Right(tMovies));
    });
  });
}
