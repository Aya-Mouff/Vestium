part of 'edit_item_cubit.dart';

class EditItemState extends Equatable {
  final bool isCropping;
  final bool isRemovingBg;
  final double eraserSize;

  const EditItemState({
    this.isCropping = false,
    this.isRemovingBg = false,
    this.eraserSize = 50.0,
  });

  @override
  List<Object> get props => [isCropping, isRemovingBg, eraserSize];

  EditItemState copyWith({
    bool? isCropping,
    bool? isRemovingBg,
    double? eraserSize,
  }) {
    return EditItemState(
      isCropping: isCropping ?? this.isCropping,
      isRemovingBg: isRemovingBg ?? this.isRemovingBg,
      eraserSize: eraserSize ?? this.eraserSize,
    );
  }
}