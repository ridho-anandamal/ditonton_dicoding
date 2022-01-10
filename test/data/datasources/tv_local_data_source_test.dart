import 'package:ditonton/data/datasources/tv_local_data_source.dart';
import 'package:ditonton/common/exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/tv_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TVLocalDataSourceImpl dataSourceImpl;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSourceImpl = TVLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('save watchlist', () {
    test('should return success message when insert to database is success',
        () async {
      // arrange
      when(mockDatabaseHelper.insertWatchlistTV(testTVTable))
          .thenAnswer((_) async => 1);
      // act
      final result = await dataSourceImpl.insertWatchlist(testTVTable);
      // assert
      expect(result, 'Added to Watchlist');
    });

    test('should throw DatabaseException when insert to database is failed',
        () async {
      // arrange
      when(mockDatabaseHelper.insertWatchlistTV(testTVTable))
          .thenThrow(Exception());
      // act
      final call = dataSourceImpl.insertWatchlist(testTVTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove from database is success',
        () async {
      // arrange
      when(mockDatabaseHelper.removeWatchListTV(testTVTable))
          .thenAnswer((_) async => 1);
      // act
      final result = await dataSourceImpl.removeWatchlist(testTVTable);
      // assert
      expect(result, 'Removed from Watchlist');
    });

    test('should throw DatabaseException when remove from database is failed',
        () async {
      // arrange
      when(mockDatabaseHelper.removeWatchListTV(testTVTable))
          .thenThrow(Exception());
      // act
      final call = dataSourceImpl.removeWatchlist(testTVTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('Get TV Show Detail By Id', () {
    final tId = 1;

    test('should return TV Show Detail Table when data is found', () async {
      // arrange
      when(mockDatabaseHelper.getTVById(tId))
          .thenAnswer((_) async => testTVMap);
      // act
      final result = await dataSourceImpl.getTVById(tId);
      // assert
      expect(result, testTVTable);
    });

    test('should return null when data is not found', () async {
      // arrange
      when(mockDatabaseHelper.getTVById(tId)).thenAnswer((_) async => null);
      // act
      final result = await dataSourceImpl.getTVById(tId);
      // assert
      expect(result, null);
    });
  });

  group('get watchlist TV Shows', () {
    test('should return list of TVShowsTable from database', () async {
      // arrange
      when(mockDatabaseHelper.getWatchlistTVShows())
          .thenAnswer((_) async => [testTVMap]);
      // act
      final result = await dataSourceImpl.getWatchlistTVShows();
      // assert
      expect(result, [testTVTable]);
    });
  });
}
