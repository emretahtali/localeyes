import 'package:get_it/get_it.dart';
import 'package:imaginecup/core/services/authentication_service.dart';
import 'package:imaginecup/core/services/azure_service.dart';
import 'package:imaginecup/core/services/geocoding_service.dart';
import 'package:imaginecup/core/services/trip_db_service.dart';
import 'package:imaginecup/core/services/user_db_service.dart';
import 'package:imaginecup/features/create_tour/create_tour_viewmodel.dart';
import 'package:imaginecup/features/tour/tour_viewmodel.dart';

final getIt = GetIt.instance;

void setupLocator() {
  //services
  getIt.registerLazySingleton(() => AuthenticationService());
  getIt.registerLazySingleton<UserDbService>(() => UserDbService());
  getIt.registerLazySingleton<TripDbService>(() => TripDbService());
  getIt.registerSingleton<AzureService>(AzureService());
  getIt.registerSingleton<GeocodingService>(GeocodingService());

  //viewmodels

  getIt.registerSingleton<TourViewModel>(TourViewModel());
  getIt.registerSingleton<CreateTourViewmodel>(CreateTourViewmodel());
}
