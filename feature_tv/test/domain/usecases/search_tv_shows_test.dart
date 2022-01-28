import 'package:dartz/dartz.dart';
import 'package:feature_tv/domain/entities/tv.dart';
import 'package:feature_tv/domain/repositories/tv_repository.dart';
import 'package:feature_tv/domain/usecases/search_tv_shows.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTVRepository extends Mock implements TVRepository {}

void main() {
  late SearchTVShows usecase;
  late MockTVRepository repository;

  setUp(() {
    repository = MockTVRepository();
    usecase = SearchTVShows(repository: repository);
  });

  const tQuery = 'Titan';
  final tTVShows = <TV>[];

  group('TV Use Cases, Get TV Search:', () {
    test('should get list of movies from the repository', () async {
      // arrange
      when(() => repository.searchTVShows(tQuery))
          .thenAnswer((_) async => Right(tTVShows));
      // act
      final result = await usecase.execute(tQuery);
      // assert
      expect(result, Right(tTVShows));
    });
  });
}
