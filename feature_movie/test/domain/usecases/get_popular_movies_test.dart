import 'package:dartz/dartz.dart';
import 'package:feature_movie/feature_movie.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late GetPopularMovies usecase;
  late MockMovieRepository mockMovieRpository;

  setUp(() {
    mockMovieRpository = MockMovieRepository();
    usecase = GetPopularMovies(mockMovieRpository);
  });

  final tMovies = <Movie>[];

  group('Movie Use Cases, Get Movie Popular:', () {
    test(
        'should get list of movies from the repository when execute function is called',
        () async {
      // arrange
      when(() => mockMovieRpository.getPopularMovies())
          .thenAnswer((_) async => Right(tMovies));
      // act
      final result = await usecase.execute();
      // assert
      expect(result, Right(tMovies));
    });
  });
}
