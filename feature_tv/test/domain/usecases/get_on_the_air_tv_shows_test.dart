import 'package:dartz/dartz.dart';
import 'package:feature_tv/feature_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTVRepository extends Mock implements TVRepository {}

void main() {
  late GetOnTheAirTVShows usecase;
  late MockTVRepository repository;

  setUp(() {
    repository = MockTVRepository();
    usecase = GetOnTheAirTVShows(repository: repository);
  });
  final tTV = <TV>[];

  group('TV Use Cases, Get TV On The Air:', () {
    test(
        'should get list on the air of tv shows from the repository when execute function is called',
        () async {
      // arrange
      when(() => repository.getOnTheAirTVShows())
          .thenAnswer((_) async => Right(tTV));
      // act
      final result = await usecase.execute();
      // assert
      expect(result, Right(tTV));
    });
  });
}
