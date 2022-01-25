import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:feature_tv/domain/entities/tv.dart';
import 'package:feature_tv/domain/repositories/tv_repository.dart';

class GetTVShowsRecommendation{
  final TVRepository repository;

  GetTVShowsRecommendation({required this.repository});

  Future<Either<Failure, List<TV>>> execute(int id){
    return repository.getTVShowsRecommendation(id);
  }
}