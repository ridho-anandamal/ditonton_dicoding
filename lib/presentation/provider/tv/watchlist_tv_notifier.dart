import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv_shows.dart';
import 'package:flutter/cupertino.dart';

class WatchlistTVNotifier extends ChangeNotifier {
  var _watchlistTVShows = <TV>[];
  List<TV> get watchlistTVShows => _watchlistTVShows;

  var _watchlistState = RequestState.Empty;
  RequestState get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  WatchlistTVNotifier({required this.getWatchlistTVShows});

  final GetWatchlistTVShows getWatchlistTVShows;

  Future<void> fetchWatchlistTVShows() async {
    _watchlistState = RequestState.Loading;
    notifyListeners();

    final result = await getWatchlistTVShows.execute();
    result.fold((failure) {
      _watchlistState = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (tvShowsData) {
      _watchlistState = RequestState.Loaded;
      _watchlistTVShows = tvShowsData;
      notifyListeners();
    });
  }
}
