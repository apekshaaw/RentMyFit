import 'package:equatable/equatable.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {
  final int currentIndex;

  const DashboardInitial({this.currentIndex = 0});

  @override
  List<Object> get props => [currentIndex];
}

class DashboardLoaded extends DashboardState {
  final int currentIndex;

  const DashboardLoaded({required this.currentIndex});

  @override
  List<Object> get props => [currentIndex];
}
