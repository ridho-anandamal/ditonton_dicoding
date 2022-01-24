import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_show_detail.dart';
import 'package:ditonton/presentation/bloc/tv/detail_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv_data/dummy_objects.dart';
import 'tv_show_detail_bloc_test.mocks.dart';

@GenerateMocks([GetTVShowDetail])
void main() {
  late MockGetTVShowDetail mockGetTVShowDetail;
  late DetailTVBloc detailTVBloc;

  setUp((){
    mockGetTVShowDetail = MockGetTVShowDetail();
    detailTVBloc = DetailTVBloc(getTVShowDetail: mockGetTVShowDetail);
  });

  final tId = 1;

  group('Get TV Show Detail', () {
    test('initialState should be Empty', () {
      expect(detailTVBloc.state, DetailTVEmptyState());
    });

    blocTest<DetailTVBloc, DetailTVState>(
      'Should emit[Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetTVShowDetail.execute(tId))
            .thenAnswer((_) async => Right(testTVShowDetail));
        return detailTVBloc;
      },
      act: (bloc) => bloc.add(FetchNowDetailTV(id: tId)),
      expect: () => [
        DetailTVLoadingState(),
        DetailTVHasDataState(result: testTVShowDetail)
      ],
      verify: (bloc) => verify(mockGetTVShowDetail.execute(tId)),
    );

    blocTest<DetailTVBloc, DetailTVState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetTVShowDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return detailTVBloc;
      },
      act: (bloc) => bloc.add(FetchNowDetailTV(id: tId)),
      expect: () => [
        DetailTVLoadingState(),
        DetailTVErrorState(message: 'Server Failure'),
      ],
      verify: (bloc) => verify(mockGetTVShowDetail.execute(tId)),
    );
  });
}
