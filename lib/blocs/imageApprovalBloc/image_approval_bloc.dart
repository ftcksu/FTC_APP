import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:ftc_application/repositories/ftc_repository.dart';
import 'package:ftc_application/src/models/image_history.dart';
import './bloc.dart';

class ImageApprovalBloc extends Bloc<ImageApprovalEvent, ImageApprovalState> {
  final FtcRepository ftcRepository;
  ImageApprovalBloc({@required this.ftcRepository})
      : assert(ftcRepository != null);
  @override
  ImageApprovalState get initialState => InitialImageApprovalState();

  @override
  Stream<ImageApprovalState> mapEventToState(
    ImageApprovalEvent event,
  ) async* {
    if (event is GetPendingImages) {
      yield* _mapGetPendingImages();
    } else if (event is GetUserImageHistory) {
      yield* _mapGetUserImageHistory();
    }
    if (event is UpdateImageStatus) {
      await ftcRepository.updatePendingImage(event.imageId, event.status);
      yield InitialImageApprovalState();
    }

    if (event is MemberImageUpdated) {
      await ftcRepository.updateMemberImage(event.imageId);
      yield InitialImageApprovalState();
    }

    if (event is RefreshPendingImages) {
      yield* _mapGetPendingImages();
    }

    if (event is RefreshImageHistory) {
      yield* _mapGetUserImageHistory();
    }
  }

  Stream<ImageApprovalState> _mapGetPendingImages() async* {
    yield PendingImagesLoading();
    List<ImageHistory> imageHistory = await ftcRepository.getPendingImages();
    yield PendingImagesLoaded(imageHistory: imageHistory);
  }

  Stream<ImageApprovalState> _mapGetUserImageHistory() async* {
    yield MemberImagesHistoryLoading();
    List<ImageHistory> imageHistory =
        await ftcRepository.getMemberImageHistory();
    yield MemberImagesHistoryLoaded(imageHistory: imageHistory);
  }
}
