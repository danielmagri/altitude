import 'package:altitude/common/di/dependency_injection.dart';
import 'package:altitude/feature/friends/domain/usecases/accept_request_usecase.dart';
import 'package:altitude/feature/friends/domain/usecases/cancel_friend_request_usecase.dart';
import 'package:altitude/feature/friends/domain/usecases/decline_request_usecase.dart';
import 'package:altitude/feature/friends/domain/usecases/friend_request_usecase.dart';
import 'package:altitude/feature/friends/domain/usecases/get_pending_friends_usecase.dart';
import 'package:altitude/feature/friends/domain/usecases/remove_friend_usecase.dart';
import 'package:altitude/feature/friends/domain/usecases/search_email_usecase.dart';
import 'package:altitude/feature/friends/presentation/controllers/add_friend_controller.dart';
import 'package:altitude/feature/friends/presentation/controllers/friends_controller.dart';
import 'package:altitude/feature/friends/presentation/controllers/pending_friends_controller.dart';

void setupFriends() {
  // USECASES

  serviceLocator.registerFactory(() => SearchEmailUsecase(
      serviceLocator.get(), serviceLocator.get(), serviceLocator.get()));

  serviceLocator.registerFactory(
      () => RemoveFriendUsecase(serviceLocator.get(), serviceLocator.get()));

  serviceLocator
      .registerFactory(() => GetPendingFriendsUsecase(serviceLocator.get()));

  serviceLocator.registerFactory(() => FriendRequestUsecase(
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get()));

  serviceLocator.registerFactory(() => DeclineRequestUsecase(
      serviceLocator.get(), serviceLocator.get(), serviceLocator.get()));

  serviceLocator.registerFactory(() => CancelFriendRequestUsecase(
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get()));

  serviceLocator.registerFactory(() => AcceptRequestUsecase(
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get()));

  // CONTROLLERS

  serviceLocator.registerLazySingleton(() => PendingFriendsController(
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get(),
      serviceLocator.get()));

  serviceLocator.registerFactory(() => FriendsController(serviceLocator.get(),
      serviceLocator.get(), serviceLocator.get(), serviceLocator.get()));

  serviceLocator.registerFactory(() => AddFriendController(serviceLocator.get(),
      serviceLocator.get(), serviceLocator.get(), serviceLocator.get()));
}
