import 'package:ditonton/domain/entities/tv/tv_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_status_tv.dart';
import 'package:ditonton/domain/usecases/tv/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/tv/save_watchlist_tv.dart';
import 'package:flutter/cupertino.dart';

class TVWatchlistOperationNotifier extends ChangeNotifier{
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  SaveWatchlistTV saveWatchlistTV;
  RemoveWatchlistTV removeWatchlistTV;
  GetWatchListStatusTV getWatchListStatusTV;

  TVWatchlistOperationNotifier({required this.saveWatchlistTV, required this.removeWatchlistTV, required this.getWatchListStatusTV,});

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