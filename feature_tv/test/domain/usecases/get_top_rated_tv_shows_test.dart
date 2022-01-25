import 'package:dartz/dartz.dart';
import 'package:feature_tv/feature_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTVRepository extends Mock implements TVRepository {}

void main() {
  late GetTopRatedTVShows usecase;
  late MockTVRepository repository;

  setUp(() {
    repository = MockTVRepository();
    usecase = GetTopRatedTVShows(repository: repository);
  });
  final tTV = <TV>[];

  group('TV Use Cases, Get TV Top Rated:', () {
    test(
        'should get list top rated of tv shows from the repository when execute function is called',
        () async {
      // arrange
      when(() => repository.getTopRatedTVShows())
          .thenAnswer((_) async => Right(tTV));
      // act
      final result = await usecase.execute();
      // assert
      expect(result, Right(tTV));
    });
  });
}
