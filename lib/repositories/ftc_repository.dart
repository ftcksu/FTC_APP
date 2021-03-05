import 'dart:io';

import 'package:ftc_application/repositories/ftc_api_client.dart';
import 'package:ftc_application/src/models/Event.dart';
import 'package:ftc_application/src/models/Job.dart';
import 'package:ftc_application/src/models/Member.dart';
import 'package:ftc_application/src/models/PushNotificationRequest.dart';
import 'package:ftc_application/src/models/Task.dart';
import 'package:ftc_application/src/models/image_history.dart';
import 'package:ftc_application/src/models/message_of_the_day.dart';
import 'package:ftc_application/src/models/route_argument.dart';

class FtcRepository {
  FtcApiClient ftcApiClient;

  static final FtcRepository _inst = FtcRepository._internal();

  FtcRepository._internal();

  factory FtcRepository({FtcApiClient ftcApiClient}) {
    _inst.ftcApiClient = ftcApiClient;
    return _inst;
  }

  static FtcRepository get instance => _inst;

  Future<String> login(String username, String password) async {
    return ftcApiClient.login(username, password);
  }

  Future<void> reLogIn() async {
    try {
      await ftcApiClient.reLogIn();
    } catch (e) {
      throw e;
    }
  }

  Future<RouteArgument> getMemberHomePage() async {
    Member member;
    MessageOfTheDay messageOfTheDay;
    try {
      member = await ftcApiClient.getCurrentMember();
      messageOfTheDay = await ftcApiClient.getMessageOfTheDay();
      member.participatedEvents =
          await ftcApiClient.getCurrentMemberEvents(false);
      member.participatedEvents.removeWhere((event) => event.finished);
    } catch (e) {
      throw e;
    }
    return RouteArgument(argumentsList: [member, messageOfTheDay]);
  }

  Future<List<Member>> getPointsList() async {
    try {
      return await ftcApiClient.getMembers(false);
    } catch (e) {
      throw e;
    }
  }

  Future<RouteArgument> getEvents() async {
    List<Event> events;
    List<int> enlistedEvents;
    try {
      events = await ftcApiClient.getEvents();
      enlistedEvents =
          await ftcApiClient.getCurrentMemberEvents(false).then((value) {
        return value.map((i) => (i.id)).toList();
      });
      events.removeWhere((event) => event.finished == true);
    } catch (e) {
      throw e;
    }
    return RouteArgument(argumentsList: [events, enlistedEvents]);
  }

  Future<RouteArgument> getCurrentMemberOwnedEvents() async {
    Member currentMember;
    List<Event> events;
    try {
      currentMember = await ftcApiClient.getCurrentMember();
      events = await ftcApiClient.getCurrentMemberEvents(true);
    } catch (e) {
      throw e;
    }
    return RouteArgument(
        id: currentMember.id.toString(),
        argumentsList: [currentMember, events]);
  }

  Future<List<Event>> getCurrentMemberEvents() async {
    return await ftcApiClient.getCurrentMemberEvents(false);
  }

  Future<int> addEvent(Map<String, dynamic> payload, bool notification) {
    try {
      return ftcApiClient.addEvent(payload, notification);
    } catch (e) {
      throw e;
    }
  }

  Future<void> changeEventStatus(int eventId, bool status) {
    try {
      return ftcApiClient.changeEventStatus(eventId, status);
    } catch (e) {
      throw e;
    }
  }

  Future<int> updateEvent(int eventId, Map<String, dynamic> payload) {
    try {
      return ftcApiClient.updateEvent(eventId, payload);
    } catch (e) {
      throw e;
    }
  }

  Future<void> joinEvent(int eventId) {
    try {
      return ftcApiClient.addCurrentUserToEvent(eventId);
    } catch (e) {
      throw e;
    }
  }

  Future<void> addMembersToEvent(int eventId, List<Member> members) async {
    try {
      ftcApiClient.addMembersToEvent(eventId, members);
    } catch (e) {
      throw e;
    }
  }

  Future<String> leaveEvent(int eventId) {
    try {
      return ftcApiClient.removeCurrentUserFromEvent(eventId);
    } catch (e) {
      throw e;
    }
  }

  Future<void> removeMemberFromEvent(int eventId, int memberId) {
    try {
      ftcApiClient.removeUserFromEvent(eventId, memberId);
    } catch (e) {
      throw e;
    }
  }

  Future<List<Job>> getSelfJobs() async {
    return await ftcApiClient.getSelfJobs();
  }

  Future<RouteArgument> getMemberSubmissionJobs() async {
    List<Job> memberJobs = await ftcApiClient.getCurrentMemberJobs();
    int selfJobId = 0;
    for (int i = 0; i < memberJobs.length; i++) {
      if (memberJobs[i].jobType == "SELF") {
        selfJobId = memberJobs[i].id;
        memberJobs.removeAt(i);
      }
    }
    return RouteArgument(argumentsList: [memberJobs, selfJobId]);
  }

  Future<List<Job>> getMemberJobs() async {
    return await ftcApiClient.getCurrentMemberJobs();
  }

  Future<List<Task>> getMemberJobTasks(int jobId) async {
    return await ftcApiClient.getJobTasks(jobId);
  }

  Future<List<Task>> getMemberSelfTasks(int memberId) async {
    List<Job> jobs = await ftcApiClient.getMemberJobs(memberId);
    int selfId;
    for (Job job in jobs) {
      if (job.jobType == "SELF") {
        selfId = job.id;
        break;
      }
    }
    return await ftcApiClient.getJobTasks(selfId);
  }

  Future<List<Task>> getEventTasks(int eventId) async {
    List<Job> jobs = await ftcApiClient.getEventJobs(eventId);
    List<Task> eventTasks = [];
    for (Job job in jobs) {
      for (Task task in job.tasks) {
        if (task.approvalStatus == "WAITING") {
          Task addedTask = new Task(
              id: task.id,
              description: task.description,
              assignedMember: job.assignedMember);
          eventTasks.add(addedTask);
        }
      }
    }
    return eventTasks;
  }

  Future<List<Event>> getMemberEvents(int id) async {
    List<Event> events = await ftcApiClient.getMemberEvents(id, false);
    events.removeWhere((event) => event.finished);
    return events;
  }

  Future<List<Member>> getEventMembers(int eventId) async {
    return await ftcApiClient.getEventMembers(eventId);
  }

  Future<List<ImageHistory>> getPendingImages() async {
    return await ftcApiClient.getPendingImages();
  }

  Future<List<ImageHistory>> getMemberImageHistory() async {
    return await ftcApiClient.getMemberImageHistory();
  }

  Future<String> addJob(Map<String, dynamic> payload) async {
    return await ftcApiClient.addJob(payload);
  }

  Future<void> addTaskToJob(int jobId, Map<String, dynamic> payload) async {
    return await ftcApiClient.addTaskToJob(jobId, payload);
  }

  Future<void> adminSubmitPoints(
      int memberId, Map<String, dynamic> payload) async {
    await ftcApiClient.adminSubmitPoints(memberId, payload);
  }

  Future<void> updateTaskEventLeader(
      int eventId, int taskId, String approval) async {
    await ftcApiClient.updateTaskEventLeader(eventId, taskId, approval);
  }

  Future<void> editTask(int taskId, String description, bool userSub) async {
    if (userSub) {
      await ftcApiClient.updateTask(taskId, {"description": description});
    } else {
      await ftcApiClient.updateTask(
          taskId, {"description": description, "approval_status": "WAITING"});
    }
  }

  Future<String> addMessageOfTheDay(Map<String, dynamic> payload) async {
    return await ftcApiClient.addMessageOfTheDay(payload);
  }

  Future<void> updateMember(Map<String, dynamic> payload) async {
    await ftcApiClient.updateMember(payload);
  }

  Future<Member> getCurrentMember() async {
    try {
      return await ftcApiClient.getCurrentMember();
    } catch (e) {
      throw e;
    }
  }

  Future<void> uploadMemberImage(File image) async {
    await ftcApiClient.uploadImage(image);
  }

  Future<void> updatePendingImage(int id, String status) async {
    await ftcApiClient.updatePendingImage(id, status);
  }

  Future<void> updateMemberImage(int imageId) async {
    return await ftcApiClient.updateImage(imageId);
  }

  Future<List<Event>> getAdminEvents() async {
    List<Event> events = await ftcApiClient.getEvents();
    for (int i = 0; i < events.length - 1; i++) {
      List<Job> eventJobs = await ftcApiClient.getEventJobs(events[i].id);
      if (!eventJobs.any((job) => job.readyTasks > 0)) {
        events.removeAt(i);
      }
    }
    return events;
  }

  Future<List<Job>> getEventJobs(int eventId) {
    return ftcApiClient.getEventJobs(eventId);
  }

  Future<void> updateTask(int taskId, Map<String, dynamic> payload) async {
    ftcApiClient.updateTask(taskId, payload);
  }

  Future<void> adminUpdateTask(int taskId, Map<String, dynamic> payload) async {
    ftcApiClient.adminUpdateTask(taskId, payload);
  }

  Future<List<Member>> getMembers(bool hidden) async {
    return await ftcApiClient.getMembers(hidden);
  }

  Future<void> signOut() async {
    await ftcApiClient.signOut();
  }

  Future<void> sendNotification(PushNotificationRequest message) async {
    await ftcApiClient.postTopic(message);
  }

  Future<void> sendMessage(
      int memberId, PushNotificationRequest message) async {
    await ftcApiClient.postMessageToMember(memberId, message);
  }
}
