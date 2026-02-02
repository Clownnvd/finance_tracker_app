import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../cubit/monthly_report_cubit.dart';
import '../widgets/monthly_report_view.dart';

class MonthlyReportPage extends StatelessWidget {
  const MonthlyReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MonthlyReportCubit>(
      create: (_) => getIt<MonthlyReportCubit>()..init(),
      child: const MonthlyReportView(),
    );
  }
}
