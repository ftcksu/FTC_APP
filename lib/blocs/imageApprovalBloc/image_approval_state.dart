import 'package:equatable/equatable.dart';
import 'package:ftc_application/src/models/image_history.dart';

abstract class ImageApprovalState extends Equatable {
  const ImageApprovalState();
  @override
  List<Object> get props => [];
}

class InitialImageApprovalState extends ImageApprovalState {}

class PendingImagesLoading extends ImageApprovalState {}

class PendingImagesLoaded extends ImageApprovalState {
  final List<ImageHistory> imageHistory;

  PendingImagesLoaded({this.imageHistory}) : assert(imageHistory != null);
}

class MemberImagesHistoryLoading extends ImageApprovalState {}

class MemberImagesHistoryLoaded extends ImageApprovalState {
  final List<ImageHistory> imageHistory;

  MemberImagesHistoryLoaded({this.imageHistory}) : assert(imageHistory != null);
}

class PendingImageUpdating extends ImageApprovalState {}

