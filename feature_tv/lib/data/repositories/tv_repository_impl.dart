import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:feature_tv/data/datasources/tv_local_data_source.dart';
import 'package:feature_tv/data/datasources/tv_remote_data_source.dart';
import 'package:feature_tv/data/models/tv_table.dart';
import 'package:feature_tv/domain/entities/tv.dart';
import 'package:feature_tv/domain/entities/tv_detail.dart';
import 'package:feature_tv/domain/repositories/tv_repository.dart';

class TVRepositoryImpl implements TVRepository {
  final TVRemoteDataSource remoteDataSource;
  final TVLocalDataSource localDataSource;

  TVRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<TV>>> getOnTheAirTVShows() async {
    try {
      final result = await remoteDataSource.getOnTheAirTVShows();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure('Error Server'));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<TV>>> getPopularTVShows() async {
    try {
      final result = await remoteDataSource.getPopularTVShows();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure('Error Server'));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<TV>>> getTopRatedTVShows() async {
    try {
      final result = await remoteDataSource.getTopRatedTVShows();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure('Error Server'));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, TVDetail>> getTVShowDetail(id) async {
    try {
      final result = await remoteDataSource.getTVShowDetail(id);
      return Right(result.toEntity());
    } on ServerException {
      return const Left(ServerFailure('Error Server'));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<TV>>> getTVShowsRecommendation(id) async {
    try {
      final result = await remoteDataSource.getTVShowsRecomendation(id);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure('Error Server'));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<TV>>> searchTVShows(query) async {
    try {
      final result = await remoteDataSource.searchTVShows(query);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure('Error Server'));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, String>> saveWatchlistTV(TVDetail tv) async {
    try {
      final result =
          await localDataSource.insertWatchlist(TVTable.fromEntity(tv));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<Failure, String>> removeWatchlistTV(TVDetail tv) async {
    try {
      final result =
          await localDataSource.removeWatchlist(TVTable.fromEntity(tv));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<bool> isAddedToWatchlistTV(int id) async {
    final result = await localDataSource.getTVById(id);
    return result != null;
  }

  @override
  Future<Either<Failure, List<TV>>> getWatchlistTVShows() async{
    final result = await localDataSource.getWatchlistTVShows();
    return Right(result.map((data) => data.toEntity()).toList());
  }
}
