import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/data/models/tv/tv_model.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/entities/tv/tv_detail.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';

class TVRepositoryImpl implements TVRepository {
  final TVRemoteDataSource remoteDataSource;
  // TODO: Tambah local jika selesai remote

  TVRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<TV>>> getOnTheAirTVShows() async {
    try {
      final result = await remoteDataSource.getOnTheAirTVShows();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure('Error Server'));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<TV>>> getPopularTVShows() async {
    try {
      final result = await remoteDataSource.getPopularTVShows();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure('Error Server'));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<TV>>> getTopRatedTVShows() async {
    try {
      final result = await remoteDataSource.getTopRatedTVShows();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure('Error Server'));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, TVDetail>> getTVShowDetail(id) async {
    try {
      final result = await remoteDataSource.getTVShowDetail(id);
      return Right(result.toEntity());
    } on ServerException {
      return Left(ServerFailure('Error Server'));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<TV>>> getTVShowsRecommendation(id) async {
    try {
      final result = await remoteDataSource.getTVShowsRecomendation(id);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure('Error Server'));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<TV>>> searchTVShows(query) async {
    try {
      final result = await remoteDataSource.searchTVShows(query);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure('Error Server'));
    } on SocketException {
      return Left(ServerFailure('Failed to connect to the network'));
    }
  }

  // TODO: Step 4 -> Buat method lainnya berdasarkan kelas abstrak
}
