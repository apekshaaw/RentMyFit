import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardViewModel extends Bloc<DashboardEvent, DashboardState> {
  DashboardViewModel() : super(const DashboardInitial()) {
    on<LoadDashboard>(_onLoadDashboard);
    on<ChangeTab>(_onChangeTab);
  }

  Future<void> _onLoadDashboard(
    LoadDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoaded(currentIndex: 0));
  }

  void _onChangeTab(
    ChangeTab event,
    Emitter<DashboardState> emit,
  ) {
    emit(DashboardLoaded(currentIndex: event.index));
  }
}
