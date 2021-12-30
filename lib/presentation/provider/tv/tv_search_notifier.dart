import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/search_tv_shows.dart';
import 'package:flutter/cupertino.dart';

class TVSearchNotifier extends ChangeNotifier {
  final SearchTVShows searchTVShows;

  TVSearchNotifier({required this.searchTVShows});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<TV> _searchResult = [];
  List<TV> get searchResult => _searchResult;

  String _message = '';
  String get message => _message;

  Future<void> fetchTVSearch(String query) async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await searchTVShows.execute(query);
    result.fold((failure) {
      _message = failure.message;
      _state = RequestState.Error;
      notifyListeners();
    }, (data) {
      _searchResult = data;
      _state = RequestState.Loaded;
      notifyListeners();
    });
  }
}
