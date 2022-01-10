import 'package:ditonton/domain/usecases/tv/get_watchlist_status_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchListStatusTV usecase;
  late MockTVRepository repository;

  setUp(() {
    repository = MockTVRepository();
    usecase = GetWatchListStatusTV(repository: repository);
  });

  test('should get watchlist status from repository', () async {
    // arrange
    when(repository.isAddedToWatchlistTV(1))
        .thenAnswer((_) async => true);
    // act
    final result = await usecase.execute(1);
    // assert
    expect(result, true);
  });
}
