import 'package:equatable/equatable.dart';

abstract class ImageApprovalEvent extends Equatable {
  const ImageApprovalEvent();
  @override
  List<Object> get props => [];
}

class GetPendingImages extends ImageApprovalEvent {}

class UpdateImageStatus extends ImageApprovalEvent {
  final int imageId;
  final String status;
  UpdateImageStatus(this.imageId, this.status);
}

class GetUserImageHistory extends ImageApprovalEvent {}

class MemberImageUpdated extends ImageApprovalEvent {
  final int imageId;

  MemberImageUpdated({required this.imageId});
}

class RefreshPendingImages extends ImageApprovalEvent {}

class RefreshImageHistory extends ImageApprovalEvent {}
