import 'package:ditonton/domain/entities/tv/tv_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_status_tv.dart';
import 'package:ditonton/domain/usecases/tv/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/tv/save_watchlist_tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistStatusTVCubit extends Cubit<WatchlistStatusTVState> {
  final GetWatchListStatusTV getWatchListStatusTV;
  final SaveWatchlistTV saveWatchlistTV;
  final RemoveWatchlistTV removeWatchlistTV;

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  WatchlistStatusTVCubit({
    required this.getWatchListStatusTV,
    required this.saveWatchlistTV,
    required this.removeWatchlistTV,
  }) : super(WatchlistStatusTVState(isAddedWatchlist: false, message: ''));

  void loadWatchlistStatus(int id) async {
    final result = await getWatchListStatusTV.execute(id);
    emit(WatchlistStatusTVState(isAddedWatchlist: result, message: ''));
  }

  Future<void> addWatchlistTV(TVDetail tvDetail) async {
    final result = await saveWatchlistTV.execute(tvDetail);
    final resultBool = await getWatchListStatusTV.execute(tvDetail.id);

    result.fold(
      (failure) async {
        emit(WatchlistStatusTVState(
          message: failure.message,
          isAddedWatchlist: resultBool,
        ));
      },
      (successMessage) async {
        emit(WatchlistStatusTVState(
          message: successMessage,
          isAddedWatchlist: resultBool,
        ));
      },
    );
  }

  Future<void> removeFromWatchlistTV(TVDetail tvDetail) async {
    final result = await removeWatchlistTV.execute(tvDetail);
    final resultBool = await getWatchListStatusTV.execute(tvDetail.id);

    result.fold(
      (failure) async {
        emit(WatchlistStatusTVState(
          message: failure.message,
          isAddedWatchlist: resultBool,
        ));
      },
      (successMessage) async {
        emit(WatchlistStatusTVState(
          message: successMessage,
          isAddedWatchlist: resultBool,
        ));
      },
    );
  }
}

class WatchlistStatusTVState extends Equatable {
  final bool isAddedWatchlist;
  final String message;

  WatchlistStatusTVState({
    required this.isAddedWatchlist,
    required this.message,
  });

  @override
  List<Object> get props => [isAddedWatchlist];
}
