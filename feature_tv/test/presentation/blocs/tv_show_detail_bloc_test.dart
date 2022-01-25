import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:feature_tv/feature_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockGetTVShowDetail extends Mock implements GetTVShowDetail {}

void main() {
  late MockGetTVShowDetail mockGetTVShowDetail;
  late DetailTVBloc detailTVBloc;

  setUp(() {
    mockGetTVShowDetail = MockGetTVShowDetail();
    detailTVBloc = DetailTVBloc(getTVShowDetail: mockGetTVShowDetail);
  });

  const tId = 1;

  group('TV Bloc, Get TV Show Detail:', () {
    test('initialState should be Empty', () {
      expect(detailTVBloc.state, DetailTVEmptyState());
    });

    blocTest<DetailTVBloc, DetailTVState>(
      'should emit[Loading, HasData] when data is gotten successfully',
      build: () {
        when(() => mockGetTVShowDetail.execute(tId))
            .thenAnswer((_) async => Right(testTVShowDetail));
        return detailTVBloc;
      },
      act: (bloc) => bloc.add(const FetchNowDetailTV(id: tId)),
      expect: () => [
        DetailTVLoadingState(),
        DetailTVHasDataState(result: testTVShowDetail)
      ],
      verify: (bloc) => verify(() => mockGetTVShowDetail.execute(tId)),
    );

    blocTest<DetailTVBloc, DetailTVState>(
      'should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(() => mockGetTVShowDetail.execute(tId))
            .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return detailTVBloc;
      },
      act: (bloc) => bloc.add(const FetchNowDetailTV(id: tId)),
      expect: () => [
        DetailTVLoadingState(),
        const DetailTVErrorState(message: 'Server Failure'),
      ],
      verify: (bloc) => verify(() => mockGetTVShowDetail.execute(tId)),
    );
  });
}
