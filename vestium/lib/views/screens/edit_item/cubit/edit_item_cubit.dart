import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'edit_item_state.dart';

class EditItemCubit extends Cubit<EditItemState> {
  EditItemCubit() : super(const EditItemState());

  void startCropping() {
    emit(state.copyWith(isCropping: true));
  }

  void stopCropping() {
    emit(state.copyWith(isCropping: false));
  }

  void startRemovingBg() {
    emit(state.copyWith(isRemovingBg: true));
  }

  void cancelRemoveBg() {
    emit(state.copyWith(isRemovingBg: false));
  }

  void updateEraserSize(double size) {
    emit(state.copyWith(eraserSize: size));
  }
}