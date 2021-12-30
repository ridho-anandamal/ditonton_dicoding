import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/entities/tv/tv_detail.dart';

abstract class TVRepository{
  Future<Either<Failure, List<TV>>> getOnTheAirTVShows();
  Future<Either<Failure, List<TV>>> getPopularTVShows();
  Future<Either<Failure, List<TV>>> getTopRatedTVShows();
  Future<Either<Failure, TVDetail>> getTVShowDetail(int id);
  Future<Either<Failure, List<TV>>> getTVShowsRecommendation(int id);
  Future<Either<Failure, List<TV>>> searchTVShows(String query);
  // TODO: Step 3 -> Buat Kelas Abstrak yang akan mengimplementasi di data/repository
}