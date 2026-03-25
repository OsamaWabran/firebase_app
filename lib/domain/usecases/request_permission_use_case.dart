import '../repositories/notification_repository.dart';

class RequestPermissionUseCase {
  const RequestPermissionUseCase(this._repository);

  final NotificationRepository _repository;

  Future<bool> call() {
    return _repository.requestPermission();
  }
}
