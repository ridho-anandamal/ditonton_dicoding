import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_on_the_air_tv_shows.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tv_shows.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tv_shows.dart';
import 'package:flutter/cupertino.dart';

class TVListNotifier extends ChangeNotifier {

  var _onTheAirTVShows = <TV>[];
  List<TV> get onTheAirTVShows => _onTheAirTVShows;

  RequestState _onTheAirState = RequestState.Empty;
  RequestState get onTheAirState => _onTheAirState;

  var _popularTVShows = <TV>[];
  List<TV> get popularTVSHows => _popularTVShows;

  RequestState _popularState = RequestState.Empty;
  RequestState get popularState => _popularState;

  var _topRatedTVShows = <TV>[];
  List<TV> get topRatedTVShows => _topRatedTVShows;

  RequestState _topRatedState = RequestState.Empty;
  RequestState get topRatedState => _topRatedState;

  String _message = '';
  String get message => _message;

  TVListNotifier(
      {required this.getOnTheAirTVShows,
      required this.getPopularTVShows,
      required this.getTopRatedTVShows});

  final GetOnTheAirTVShows getOnTheAirTVShows;
  final GetPopularTVShows getPopularTVShows;
  final GetTopRatedTVShows getTopRatedTVShows;

  Future<void> fetchNowOnTheAirTVShows() async {
    _onTheAirState = RequestState.Loading;
    notifyListeners();

    final result = await getOnTheAirTVShows.execute();
    result.fold((failure) {
      _onTheAirState = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (tvShowsData) {
      _onTheAirState = RequestState.Loaded;
      _onTheAirTVShows = tvShowsData;
      notifyListeners();
    });
  }

  Future<void> fetchNowPopularTVShows() async {
    _popularState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTVShows.execute();
    result.fold((failure) {
      _popularState = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (tvShowsData) {
      _popularState = RequestState.Loaded;
      _popularTVShows = tvShowsData;
      notifyListeners();
    });
  }

  Future<void> fetchNowTopRatedTVShows() async {
    _topRatedState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTVShows.execute();
    result.fold((failure) {
      _topRatedState = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (tvShowsData) {
      _topRatedState = RequestState.Loaded;
      _topRatedTVShows = tvShowsData;
      notifyListeners();
    });
  }
}
