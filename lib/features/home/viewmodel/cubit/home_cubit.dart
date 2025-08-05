import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeIndexChanged(0));

  void changeIndex(int index) {
    emit(HomeIndexChanged(index));
  }
}
