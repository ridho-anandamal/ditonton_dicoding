import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/data/datasources/tv_local_data_source.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/data/repositories/tv_repository_impl.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/tv/get_on_the_air_tv_shows.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tv_shows.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tv_shows.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_show_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_shows_recommendation.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_status_tv.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv_shows.dart';
import 'package:ditonton/domain/usecases/tv/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/tv/save_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/tv/search_tv_shows.dart';
import 'package:ditonton/presentation/bloc/movie/detail_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/now_playing_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/popular_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/search_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/top_rated_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/detail_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/on_the_air_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/popular_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/search_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/top_rated_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist_tv_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init() {
  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => http.Client());

  // TV Shows Injection
  // use case
  locator.registerLazySingleton(() => GetOnTheAirTVShows(
        repository: locator(),
      ));
  locator.registerLazySingleton(() => GetPopularTVShows(
        repository: locator(),
      ));
  locator.registerLazySingleton(() => GetTopRatedTVShows(
        repository: locator(),
      ));
  locator.registerLazySingleton(() => GetTVShowDetail(
        repository: locator(),
      ));
  locator.registerLazySingleton(() => GetTVShowsRecommendation(
        repository: locator(),
      ));
  locator.registerLazySingleton(() => SearchTVShows(
        repository: locator(),
      ));
  locator.registerLazySingleton(() => SaveWatchlistTV(
        repository: locator(),
      ));
  locator.registerLazySingleton(() => RemoveWatchlistTV(
        repository: locator(),
      ));
  locator.registerLazySingleton(() => GetWatchListStatusTV(
        repository: locator(),
      ));
  locator.registerLazySingleton(() => GetWatchlistTVShows(
        repository: locator(),
      ));

  // repository
  locator.registerLazySingleton<TVRepository>(
    () => TVRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<TVRemoteDataSource>(
      () => TVRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TVLocalDataSource>(
      () => TVLocalDataSourceImpl(databaseHelper: locator()));

  // bloc movie
  locator.registerFactory(
      () => NowPlayingMovieBloc(getNowPlayingMovies: locator()));
  locator.registerFactory(() => PopularMovieBloc(getPopularMovies: locator()));
  locator
      .registerFactory(() => TopRatedMovieBloc(getTopRatedMovies: locator()));
  locator.registerFactory(() => SearchMovieBloc(searchMovies: locator()));
  locator.registerFactory(() => DetailMovieBloc(
        getMovieDetail: locator(),
        getMovieRecommendations: locator(),
        getWatchListStatus: locator(),
        saveWatchlist: locator(),
        removeWatchlist: locator(),
      ));
  locator
      .registerFactory(() => WatchlistMovieBloc(getWatchlistMovies: locator()));

  // bloc tv
  locator.registerFactory(() => OnTheAirTVBloc(getOnTheAirTVShows: locator()));
  locator.registerFactory(() => PopularTVBloc(getPopularTVShows: locator()));
  locator.registerFactory(() => TopRatedTVBloc(getTopRatedTVShows: locator()));
  locator.registerFactory(() => SearchTVBloc(searchTVShows: locator()));
  locator.registerFactory(() => DetailTVBloc(
        getTVShowDetail: locator(),
        getTVShowsRecommendation: locator(),
        getWatchListStatusTV: locator(),
        saveWatchlistTV: locator(),
        removeFromWatchlistTV: locator(),
      ));
  locator
      .registerFactory(() => WatchlistTVBloc(getWatchlistTVShows: locator()));
}
