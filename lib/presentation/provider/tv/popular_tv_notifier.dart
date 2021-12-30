import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tv_shows.dart';
import 'package:flutter/foundation.dart';

class PopularTVShowsNotifier extends ChangeNotifier {
  final GetPopularTVShows getPopularTVShows;

  PopularTVShowsNotifier({required this.getPopularTVShows});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<TV> _tvShows = [];
  List<TV> get tvShows => _tvShows;

  String _message = '';
  String get message => _message;

  Future<void> fetchPopularTVShows() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTVShows.execute();

    result.fold((failure) {
      _message = failure.message;
      _state = RequestState.Error;
      notifyListeners();
    }, (tvShowsData) {
      _tvShows = tvShowsData;
      _state = RequestState.Loaded;
      notifyListeners();
    });
  }
}
