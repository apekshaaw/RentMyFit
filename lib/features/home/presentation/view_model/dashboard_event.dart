import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class LoadDashboard extends DashboardEvent {}

class ChangeTab extends DashboardEvent {
  final int index;

  const ChangeTab(this.index);

  @override
  List<Object> get props => [index];
}
