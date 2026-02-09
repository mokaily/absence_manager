import 'package:crewmeister_frontend_coding_challenge/core/locatlizations/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/info_card_widget.dart';
import '../bloc/absences_bloc.dart';
import '../widgets/mobile/absence_list_widget.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../widgets/mobile/absence_mobile_loading.dart';
import '../widgets/web/filter/filter_web_widget.dart';

class AbsencesPageWeb extends StatelessWidget {
  const AbsencesPageWeb({super.key});
  static String totalCount = "--";
  static String pendingCount = "--";
  static String activeTodayCount = "--";

  @override
  Widget build(BuildContext context) {
    Widget tableChild = const SizedBox.shrink();
    return Scaffold(
      backgroundColor: const Color(0xffF6F7F8),
      appBar: AppBar(
        title: Center(
          child: SizedBox(
            width: 1920,
            child: Row(
              children: [
                Image.asset(
                  "assets/cats/cat_pow.png",
                  color: Colors.yellow,
                  cacheHeight: 26,
                ),
                SizedBox(width: 24),
                Text(AppStrings.absencesTitle),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          width: 1920,
          alignment: Alignment.topCenter,
          child: BlocBuilder<AbsencesBloc, AbsencesState>(
            builder: (BuildContext context, AbsencesState state) {
              // if (state is AbsencesLoading) {
              //   tableChild = const AbsenceLoading();
              // }
              // if (state is AbsencesError) {
              //   tableChild = const ErrorStateWidget(
              //     imageAsset: "assets/cats/cat_tangled.png",
              //     title: AppStrings.absencesError,
              //     message: AppStrings.absencesErrorDesc,
              //   );
              // }
              if (state is AbsencesLoaded) {
                if (state.absences.isEmpty) {
                  tableChild = const ErrorStateWidget(
                    imageAsset: "assets/cats/cat_in_box.png",
                    title: AppStrings.noAbsencesFound,
                    message: AppStrings.noAbsencesFoundDesc,
                  );
                } else {
                  tableChild = Expanded(child: AbsenceList(state: state));
                }
              }
              if (state is AbsencesLoaded) {
                totalCount = state.unfilteredCount.toString();
                pendingCount = state.pendingCount.toString();
                activeTodayCount = state.activeTodayCount.toString();
              }

              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: InfoCardWidget(
                          title: AppStrings.totalAbsences,
                          subTitle: totalCount,
                          icon: Icons.bar_chart,
                        ),
                      ),
                      Expanded(
                        child: InfoCardWidget(
                          title: "Pending Approval",
                          subTitle: pendingCount,
                          icon: Icons.access_time_filled_sharp,
                        ),
                      ),
                      Expanded(
                        child: InfoCardWidget(
                          title: "Active Today",
                          subTitle: activeTodayCount,
                          icon: Icons.check_box_outlined,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (tableChild is! Expanded)
                          Expanded(child: tableChild)
                        else
                          tableChild,
                        FilterWebWidget(),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
