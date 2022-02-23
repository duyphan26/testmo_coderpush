import 'package:testmo_coderpush/repository/models/models.dart';

abstract class ManageActionEvent {
  const ManageActionEvent();
}

class ManageActionLikeStarted extends ManageActionEvent {
  final User user;

  ManageActionLikeStarted(this.user);
}

class ManageActionNopeStarted extends ManageActionEvent {
  final User user;

  ManageActionNopeStarted(this.user);
}

class ManageActionSuperLikeStarted extends ManageActionEvent {
  final User user;

  ManageActionSuperLikeStarted(this.user);
}
