import 'package:crewmeister_frontend_coding_challenge/features/absences/domain/entities/absence.dart';
import 'package:crewmeister_frontend_coding_challenge/features/absences/domain/repositories/absence_repository.dart';
import 'package:crewmeister_frontend_coding_challenge/features/absences/domain/usecases/get_absences_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../test_constants.dart';
import 'get_absences_usecase_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AbsenceRepository>()])
void main() {
  late GetAbsencesUseCase getAbsencesUseCase;
  late MockAbsenceRepository mockAbsenceRepository;

  setUp(() {
    mockAbsenceRepository = MockAbsenceRepository();
    getAbsencesUseCase = GetAbsencesUseCase(mockAbsenceRepository);
  });

  Future<AbsencesResultModel> prepareActForGetAbsences() async => await getAbsencesUseCase.execute(
    page: TestConstants.tPage,
    pageSize: TestConstants.tPageSize,
    types: TestConstants.tTypes,
    statuses: TestConstants.tStatuses,
    startDate: TestConstants.tDateTime,
    endDate: TestConstants.tDateTime,
  );

  void verifyGetAbsencesUseCase() {
    verify(
      mockAbsenceRepository.getAbsences(
        page: TestConstants.tPage,
        pageSize: TestConstants.tPageSize,
        types: TestConstants.tTypes,
        statuses: TestConstants.tStatuses,
        startDate: TestConstants.tDateTime,
        endDate: TestConstants.tDateTime,
      ),
    ).called(1);

    verifyNoMoreInteractions(mockAbsenceRepository);
  }

  group('GetAbsencesUseCase', () {
    test('Should return AbsencesResultModel from repository', () async {
      // arrange
      final absences = <Absence>[TestConstants.tAbsence, TestConstants.tAbsence];

      when(
        mockAbsenceRepository.getAbsences(
          page: anyNamed('page'),
          pageSize: anyNamed('pageSize'),
          types: anyNamed('types'),
          statuses: anyNamed('statuses'),
          startDate: anyNamed('startDate'),
          endDate: anyNamed('endDate'),
        ),
      ).thenAnswer((_) async => TestConstants.tAbsencesRepositoryResult);

      // act
      final result = await prepareActForGetAbsences();

      // assert
      verifyGetAbsencesUseCase();
      expect(result.absences, absences);
      expect(result.totalCount, TestConstants.tTotalCount);
    });
  });
}
