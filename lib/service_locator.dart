import 'package:get_it/get_it.dart';

import 'features/absences/data/datasources/absences_local_file_data_source.dart';
import 'features/absences/data/repositories/absence_repository_impl.dart';
import 'features/absences/domain/repositories/absence_repository.dart';
import 'features/absences/domain/usecases/get_absences_usecase.dart';
import 'features/absences/domain/usecases/get_members_usecase.dart';
import 'features/absences/presentation/bloc/absences_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> initializeServiceLocator() async {
  // Bloc
  sl.registerFactory(() => AbsencesBloc(getAbsencesUseCase: sl(), getMembersUseCase: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetAbsencesUseCase(sl()));
  sl.registerLazySingleton(() => GetMembersUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AbsenceRepository>(
    () => AbsenceRepositoryImpl(dataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AbsencesLocalFileDataSource>(
    () => AbsencesLocalFileDataSourceImpl(),
  );
}
