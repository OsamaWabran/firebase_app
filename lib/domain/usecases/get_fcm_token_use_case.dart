import '../repositories/notification_repository.dart';

class GetFcmTokenUseCase {
  const GetFcmTokenUseCase(this._repository);

  final NotificationRepository _repository;

  Future<String?> call() {
    return _repository.getFcmToken();
  }
}
