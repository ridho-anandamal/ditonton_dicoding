import 'package:feature_tv/domain/repositories/tv_repository.dart';

class GetWatchListStatusTV {
  final TVRepository repository;

  GetWatchListStatusTV({required this.repository});

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlistTV(id);
  }
}
