import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/presentation/bloc/movie/detail_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([GetMovieDetail])
void main() {
  late MockGetMovieDetail mockGetMovieDetail;
  late DetailMovieBloc detailMovieBloc;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    detailMovieBloc = DetailMovieBloc(getMovieDetail: mockGetMovieDetail);
  });

  final tId = 1;

  group('Get Movie Detail', () {
    test('initialState should be Empty', () {
      expect(detailMovieBloc.state, DetailMovieEmptyState());
    });

    blocTest<DetailMovieBloc, DetailMovieState>(
      'Should emit[Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(testMovieDetail));
        return detailMovieBloc;
      },
      act: (bloc) => bloc.add(FetchNowDetailMovie(id: tId)),
      expect: () => [
        DetailMovieLoadingState(),
        DetailMovieHasDataState(result: testMovieDetail)
      ],
      verify: (bloc) => verify(mockGetMovieDetail.execute(tId)),
    );

    blocTest<DetailMovieBloc, DetailMovieState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return detailMovieBloc;
      },
      act: (bloc) => bloc.add(FetchNowDetailMovie(id: tId)),
      expect: () => [
        DetailMovieLoadingState(),
        DetailMovieErrorState(message: 'Server Failure'),
      ],
      verify: (bloc) => verify(mockGetMovieDetail.execute(tId)),
    );
  });
}
