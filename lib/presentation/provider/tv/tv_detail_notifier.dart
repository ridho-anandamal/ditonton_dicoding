import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/entities/tv/tv_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_show_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_shows_recommendation.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_status_tv.dart';
import 'package:ditonton/domain/usecases/tv/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/tv/save_watchlist_tv.dart';
import 'package:flutter/cupertino.dart';

class TVDetailNotifier extends ChangeNotifier {
  final GetTVShowDetail getTVShowDetail;
  final GetTVShowsRecommendation getTVShowsRecommendation;
  final SaveWatchlistTV saveWatchlistTV;
  final RemoveWatchlistTV removeWatchlistTV;
  final GetWatchListStatusTV getWatchListStatusTV;

  TVDetailNotifier({
    required this.getTVShowDetail,
    required this.getTVShowsRecommendation,
    required this.saveWatchlistTV,
    required this.removeWatchlistTV,
    required this.getWatchListStatusTV,
  });

  late TVDetail _tvDetail;
  TVDetail get tvDetail => _tvDetail;

  RequestState _tvState = RequestState.Empty;
  RequestState get tvState => _tvState;

  List<TV> _tvRecommendation = [];
  List<TV> get tvRecommendation => _tvRecommendation;

  RequestState _recommendationState = RequestState.Empty;
  RequestState get recommendationState => _recommendationState;

  String _message = '';
  String get message => _message;

  Future<void> fetchTVShowDetail(int id) async {
    _tvState = RequestState.Loading;
    notifyListeners();

    final detailResult = await getTVShowDetail.execute(id);
    final recommendationResult = await getTVShowsRecommendation.execute(id);

    detailResult.fold((failure) {
      _tvState = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (tvDetailData) {
      _tvState = RequestState.Loading;
      _tvDetail = tvDetailData;
      notifyListeners();
      recommendationResult.fold((failure) {
        _recommendationState = RequestState.Error;
        _message = failure.message;
      }, (tvShows) {
        _recommendationState = RequestState.Loaded;
        _tvRecommendation = tvShows;
      });

      _tvState = RequestState.Loaded;
      notifyListeners();
    });
  }

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  bool _isAddedToWatchlist = false;
  bool get isAddedToWatchlist => _isAddedToWatchlist;

  Future<void> addWatchlistTV(TVDetail tv) async{
    final result = await saveWatchlistTV.execute(tv);

    result.fold((failure){
      _watchlistMessage = failure.message;
    }, (successMessage){
      _watchlistMessage = successMessage;
    });

    await loadWatchlistStatus(tv.id);
  }

  Future<void> removeFromWatchlistTV(TVDetail tv) async{
    final result = await removeWatchlistTV.execute(tv);

    result.fold((failure){
      _watchlistMessage = failure.message;
    }, (successMessage){
      _watchlistMessage = successMessage;
    });

    await loadWatchlistStatus(tv.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatusTV.execute(id);
    _isAddedToWatchlist = result;
    notifyListeners();
  }
}
