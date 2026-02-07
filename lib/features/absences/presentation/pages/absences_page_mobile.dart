import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/absences_bloc.dart';
import '../widgets/absence_list_widget.dart';
import '../widgets/adsence_error.dart';
import '../widgets/adsence_loading.dart';
import '../widgets/filter_bottom_sheet_widget.dart';

class AbsencesPageMobile extends StatelessWidget {
  const AbsencesPageMobile({super.key});

  @override
  Widget build(BuildContext context) {
    void showFilterSheet(BuildContext context) {
      final state = context.read<AbsencesBloc>().state;
      List<String> currentTypes = [];
      List<String> currentStatuses = [];
      DateTime? startDate;
      DateTime? endDate;

      if (state is AbsencesLoaded) {
        currentTypes = state.filterTypes ?? [];
        currentStatuses = state.filterStatuses ?? [];
        startDate = state.filterStartDate;
        endDate = state.filterEndDate;
      }

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) {
          // Provide the existing BLoC to the sheet
          return BlocProvider.value(
            value: context.read<AbsencesBloc>(),
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
              child: FilterBottomSheet(
                initialTypes: currentTypes,
                initialStatuses: currentStatuses,
                initialStartDate: startDate,
                initialEndDate: endDate,
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Color(0xffF6F7F8),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Absences"),
        actions: [IconButton(icon: const Icon(Icons.filter_list), onPressed: () => showFilterSheet(context))],
      ),
      body: BlocBuilder<AbsencesBloc, AbsencesState>(
          builder: (BuildContext context, AbsencesState state) {
            if (state is AbsencesLoading) {
              return AbsenceLoading();
            }

            if (state is AbsencesError) {
              return AbsenceError();
            }

            if (state is AbsencesLoaded) {
              if (state.absences.isEmpty) {
                return AbsenceError();
              }
              return AbsenceList(state: state);
            }

            return AbsenceLoading();
          },
        ),
    );
  }
}
