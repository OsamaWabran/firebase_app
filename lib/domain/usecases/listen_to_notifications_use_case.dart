import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class ListenToNotificationsUseCase {
  const ListenToNotificationsUseCase(this._repository);

  final NotificationRepository _repository;

  Stream<NotificationEntity> call() {
    return _repository.listenToNotifications();
  }
}
