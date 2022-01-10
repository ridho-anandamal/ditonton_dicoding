import 'dart:convert';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/data/models/tv/tv_detail_model.dart';
import 'package:ditonton/data/models/tv/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late TVRemoteDataSourceImpl dataSourceImpl;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSourceImpl = TVRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get On The Air TV Shows', () {
    final tTVList = TVResponse.fromJson(
            json.decode(readJson('dummy_data/tv_data/on_the_air.json')))
        .tvList;

    test('should return list of TV Show Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv_data/on_the_air.json'), 200));
      // act
      final result = await dataSourceImpl.getOnTheAirTVShows();
      // assert
      expect(result, equals(tTVList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSourceImpl.getOnTheAirTVShows();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Popular TV Shows', () {
    final tTVList = TVResponse.fromJson(
            json.decode(readJson('dummy_data/tv_data/popular.json')))
        .tvList;

    test('should return list of TV Show Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_data/popular.json'), 200));
      // act
      final result = await dataSourceImpl.getPopularTVShows();
      // assert
      expect(result, equals(tTVList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSourceImpl.getPopularTVShows();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Top Rated TV Shows', () {
    final tTVList = TVResponse.fromJson(
            json.decode(readJson('dummy_data/tv_data/top_rated.json')))
        .tvList;

    test('should return list of TV Show Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv_data/top_rated.json'), 200));
      // act
      final result = await dataSourceImpl.getTopRatedTVShows();
      // assert
      expect(result, equals(tTVList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSourceImpl.getTopRatedTVShows();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get TV Show detail', () {
    final tId = 1;
    final tTVDetail = TVDetailResponse.fromJson(
        json.decode(readJson('dummy_data/tv_data/tv_detail.json')));
    
    test('should return TV Show detail when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv_data/tv_detail.json'), 200));
      // act
      final result = await dataSourceImpl.getTVShowDetail(tId);
      // assert
      expect(result, equals(tTVDetail));
    });

    test('should throw Server Execption when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSourceImpl.getTVShowDetail(tId);
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Recomendation TV Shows', () {
    final tTVList = TVResponse.fromJson(
            json.decode(readJson('dummy_data/tv_data/tv_recommendations.json')))
        .tvList;
    final tId = 1;

    test('should return list of TV Show Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv_data/tv_recommendations.json'), 200));
      // act
      final result = await dataSourceImpl.getTVShowsRecomendation(tId);
      // assert
      expect(result, equals(tTVList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSourceImpl.getTVShowsRecomendation(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search TV Shows', () {
    final tTVList = TVResponse.fromJson(
            json.decode(readJson('dummy_data/tv_data/search_titan.json')))
        .tvList;
    final tQuery = 'Titan';

    test('should return list of TV Show Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv_data/search_titan.json'), 200));
      // act
      final result = await dataSourceImpl.searchTVShows(tQuery);
      // assert
      expect(result, equals(tTVList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSourceImpl.searchTVShows(tQuery);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
