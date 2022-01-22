import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/entities/tv/tv_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_show_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_shows_recommendation.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_status_tv.dart';
import 'package:ditonton/domain/usecases/tv/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/tv/save_watchlist_tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailTVBloc extends Bloc<DetailTVEvent, DetailTVState> {
  final GetTVShowDetail getTVShowDetail;
  final GetTVShowsRecommendation getTVShowsRecommendation;
  final GetWatchListStatusTV getWatchListStatusTV;
  final SaveWatchlistTV saveWatchlistTV;
  final RemoveWatchlistTV removeFromWatchlistTV;

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';
  bool isAddedToWatchlist = false;

  DetailTVBloc({
    required this.getTVShowDetail,
    required this.getTVShowsRecommendation,
    required this.getWatchListStatusTV,
    required this.saveWatchlistTV,
    required this.removeFromWatchlistTV,
  }) : super(DetailTVEmptyState()) {
    on<FetchNowDetailTV>((event, emit) async {
      final id = event.id;

      emit(DetailTVLoadingState());
      final resultDetail = await getTVShowDetail.execute(id);
      final resultRecommendation = await getTVShowsRecommendation.execute(id);
      final resultIsAddedToWatchlist = await getWatchListStatusTV.execute(id);

      resultDetail.fold((failure) {
        emit(DetailTVErrorState(message: failure.message));
      }, (dataDetail) {
        resultRecommendation.fold((failure) {
          emit(DetailTVErrorState(message: failure.message));
        }, (dataRecommendation) {
          emit(DetailTVHasDataState(
            resultDetail: dataDetail,
            resultRecommendation: dataRecommendation,
            isAddedToWatchlist: resultIsAddedToWatchlist,
          ));
        });
      });
    });

    on<ActionAddWatchlistTV>((event, emit) async {
      final tv = event.tv;

      final result = await saveWatchlistTV.execute(tv);
      final resultIsAddedToWatchlist =
          await getWatchListStatusTV.execute(tv.id);

      result.fold((failure) {
        emit(WatchlistMessageState(
          message: failure.message,
          isAddedToWatchlist: resultIsAddedToWatchlist,
        ));
      }, (successMessage) {
        emit(WatchlistMessageState(
          message: successMessage,
          isAddedToWatchlist: resultIsAddedToWatchlist,
        ));
      });

      await loadWatchlistStatus(tv.id);
    });

    on<ActionRemoveFromWatchlistTV>((event, emit) async {
      final tv = event.tv;

      final result = await removeFromWatchlistTV.execute(tv);
      final resultIsAddedToWatchlist =
          await getWatchListStatusTV.execute(tv.id);

      result.fold((failure) {
        emit(WatchlistMessageState(
          message: failure.message,
          isAddedToWatchlist: resultIsAddedToWatchlist,
        ));
      }, (successMessage) {
        emit(WatchlistMessageState(
          message: successMessage,
          isAddedToWatchlist: resultIsAddedToWatchlist,
        ));
      });

      await loadWatchlistStatus(tv.id);
    });
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatusTV.execute(id);
    isAddedToWatchlist = result;
  }
}

// State
abstract class DetailTVState extends Equatable {
  const DetailTVState();

  @override
  List<Object> get props => [];
}

class DetailTVEmptyState extends DetailTVState {}

class DetailTVLoadingState extends DetailTVState {}

class DetailTVErrorState extends DetailTVState {
  final String message;

  DetailTVErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class DetailTVHasDataState extends DetailTVState {
  final TVDetail resultDetail;
  final List<TV> resultRecommendation;
  final bool isAddedToWatchlist;

  DetailTVHasDataState({
    required this.resultDetail,
    required this.resultRecommendation,
    required this.isAddedToWatchlist,
  });

  @override
  List<Object> get props => [
        resultDetail,
        resultRecommendation,
        isAddedToWatchlist,
      ];
}

class WatchlistMessageState extends DetailTVState {
  final String message;
  final bool isAddedToWatchlist;

  WatchlistMessageState({
    required this.message,
    required this.isAddedToWatchlist,
  });

  @override
  List<Object> get props => [message];
}

// Event
abstract class DetailTVEvent extends Equatable {
  const DetailTVEvent();

  @override
  List<Object> get props => [];
}

class FetchNowDetailTV extends DetailTVEvent {
  final int id;

  FetchNowDetailTV({required this.id});

  @override
  List<Object> get props => [id];
}

class ActionAddWatchlistTV extends DetailTVEvent {
  final TVDetail tv;

  ActionAddWatchlistTV({required this.tv});

  @override
  List<Object> get props => [tv];
}

class ActionRemoveFromWatchlistTV extends DetailTVEvent {
  final TVDetail tv;

  ActionRemoveFromWatchlistTV({required this.tv});

  @override
  List<Object> get props => [tv];
}
