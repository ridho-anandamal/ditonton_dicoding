import 'package:equatable/equatable.dart';
import 'package:feature_tv/domain/entities/tv_detail.dart';
import 'package:feature_tv/domain/usecases/get_tv_show_detail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailTVBloc extends Bloc<DetailTVEvent, DetailTVState> {
  final GetTVShowDetail getTVShowDetail;

  DetailTVBloc({required this.getTVShowDetail}) : super(DetailTVEmptyState()) {
    on<FetchNowDetailTV>((event, emit) async {
      final id = event.id;

      emit(DetailTVLoadingState());
      final resultDetail = await getTVShowDetail.execute(id);

      resultDetail.fold((failure) {
        emit(DetailTVErrorState(message: failure.message));
      }, (dataDetail) {
        emit(DetailTVHasDataState(result: dataDetail));
      });
    });
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

  const DetailTVErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class DetailTVHasDataState extends DetailTVState {
  final TVDetail result;

  const DetailTVHasDataState({
    required this.result,
  });

  @override
  List<Object> get props => [result];
}

// Event
abstract class DetailTVEvent extends Equatable {
  const DetailTVEvent();

  @override
  List<Object> get props => [];
}

class FetchNowDetailTV extends DetailTVEvent {
  final int id;

  const FetchNowDetailTV({required this.id});

  @override
  List<Object> get props => [id];
}
