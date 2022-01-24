import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistStatusMovieCubit extends Cubit<WatchlistStatusMovieState> {
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  WatchlistStatusMovieCubit({
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(WatchlistStatusMovieState(isAddedWatchlist: false, message: ''));

  void loadWatchlistStatus(int id) async {
    final result = await getWatchListStatus.execute(id);
    emit(WatchlistStatusMovieState(isAddedWatchlist: result, message: ''));
  }

  Future<void> addWatchlistMovie(MovieDetail movie) async {
    final result = await saveWatchlist.execute(movie);
    final resultBool = await getWatchListStatus.execute(movie.id);

    result.fold(
      (failure) async {
        emit(WatchlistStatusMovieState(
          message: failure.message,
          isAddedWatchlist: resultBool,
        ));
      },
      (successMessage) async {
        emit(WatchlistStatusMovieState(
          message: successMessage,
          isAddedWatchlist: resultBool,
        ));
      },
    );
  }

  Future<void> removeFromWatchlistMovie(MovieDetail movie) async {
    final result = await removeWatchlist.execute(movie);
    final resultBool = await getWatchListStatus.execute(movie.id);

    result.fold(
      (failure) async {
        emit(WatchlistStatusMovieState(
          message: failure.message,
          isAddedWatchlist: resultBool,
        ));
      },
      (successMessage) async {
        emit(WatchlistStatusMovieState(
          message: successMessage,
          isAddedWatchlist: resultBool,
        ));
      },
    );
  }
}

class WatchlistStatusMovieState extends Equatable {
  final bool isAddedWatchlist;
  final String message;

  WatchlistStatusMovieState({
    required this.isAddedWatchlist,
    required this.message,
  });

  @override
  List<Object> get props => [isAddedWatchlist];
}
