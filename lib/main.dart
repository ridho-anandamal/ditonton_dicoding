import 'package:core/core.dart';
import 'package:feature_movie/feature_movie.dart';
import 'package:feature_tv/feature_tv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:feature_about/feature_about.dart';
import 'package:ditonton/injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await HttpSSLPinning.init();
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NowPlayingMovieBloc>(
          create: (_) => di.locator<NowPlayingMovieBloc>(),
        ),
        BlocProvider<PopularMovieBloc>(
          create: (_) => di.locator<PopularMovieBloc>(),
        ),
        BlocProvider<TopRatedMovieBloc>(
          create: (_) => di.locator<TopRatedMovieBloc>(),
        ),
        BlocProvider<SearchMovieBloc>(
          create: (_) => di.locator<SearchMovieBloc>(),
        ),
        BlocProvider<DetailMovieBloc>(
          create: (_) => di.locator<DetailMovieBloc>(),
        ),
        BlocProvider<RecommendationMovieBloc>(
          create: (_) => di.locator<RecommendationMovieBloc>(),
        ),
        BlocProvider<WatchlistStatusMovieCubit>(
          create: (_) => di.locator<WatchlistStatusMovieCubit>(),
        ),
        BlocProvider<WatchlistMovieBloc>(
          create: (_) => di.locator<WatchlistMovieBloc>(),
        ),
        BlocProvider<OnTheAirTVBloc>(
          create: (_) => di.locator<OnTheAirTVBloc>(),
        ),
        BlocProvider<PopularTVBloc>(
          create: (_) => di.locator<PopularTVBloc>(),
        ),
        BlocProvider<TopRatedTVBloc>(
          create: (_) => di.locator<TopRatedTVBloc>(),
        ),
        BlocProvider<SearchTVBloc>(
          create: (_) => di.locator<SearchTVBloc>(),
        ),
        BlocProvider<DetailTVBloc>(
          create: (_) => di.locator<DetailTVBloc>(),
        ),
        BlocProvider<RecommendationTVBloc>(
          create: (_) => di.locator<RecommendationTVBloc>(),
        ),
        BlocProvider<WatchlistStatusTVCubit>(
          create: (_) => di.locator<WatchlistStatusTVCubit>(),
        ),
        BlocProvider<WatchlistTVBloc>(
          create: (_) => di.locator<WatchlistTVBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          colorScheme: kColorScheme.copyWith(secondary: kMikadoYellow),
        ),
        home: HomeMoviePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case HomeMoviePage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SearchMoviePage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchMoviePage());
            case WatchlistMoviesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            case HomeTVPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => HomeTVPage());
            case WatchlistTVPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistTVPage());
            case TopRatedTVPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => TopRatedTVPage());
            case PopularTVPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => PopularTVPage());
            case TVDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TVDetailPage(id: id),
                settings: settings,
              );
            case SearchTVPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => SearchTVPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
