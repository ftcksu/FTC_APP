import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ftc_application/repositories/firebase_notification_handler.dart';
import 'package:ftc_application/src/models/Event.dart';
import 'package:ftc_application/src/models/Job.dart';
import 'package:ftc_application/src/models/Member.dart';
import 'package:ftc_application/src/models/PushNotificationRequest.dart';
import 'package:ftc_application/src/models/Task.dart';
import 'package:ftc_application/src/models/image_history.dart';
import 'package:ftc_application/src/models/message_of_the_day.dart';
import 'dart:convert';

class FtcApiClient {
  static var baseUrl = "http://157.245.240.12:8080/api/";

  static BaseOptions options = new BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: 5000,
    receiveTimeout: 5000,
  );

  final Dio dio = new Dio(options);

  final storage = new FlutterSecureStorage();
  final FirebaseNotifications firebaseMessaging;
  String userId;
  Map<String, String> auth;

  FtcApiClient({this.firebaseMessaging}) : assert(firebaseMessaging != null);

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }

  Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  Future<String> login(String username, String password) async {
    try {
      Response response = await dio
          .post("login", data: {"username": username, "password": password});

      userId = parseJwt(response.data["token"])["sub"] as String;
      dio.options.headers = {
        'Authorization': 'Bearer ' + response.data["token"],
      };
      firebaseMessaging.setUpFirebase();
      return response.data["token"];
    } catch (e) {
      if (e is DioError) {
        return 'Incorrect username or password';
      } else {
        return 'Oops Something Went Wrong';
      }
    }
  }

  Future<void> reLogIn() async {
    try {
      String username = await storage.read(key: 'username');
      String password = await storage.read(key: 'password');
      Response response = await dio
          .post("login", data: {"username": username, "password": password});

      userId = parseJwt(response.data["token"])["sub"] as String;
      firebaseMessaging.setUpFirebase();

      dio.options.headers = {
        'Authorization': 'Bearer ' + response.data["token"],
      };
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 400) {
          await signOut();
          throw e;
        }
      }
    }
  }

  Future<void> signOut() async {
    await storage.delete(key: 'username');
    await storage.delete(key: 'password');
    await storage.delete(key: 'user_token');
  }

  Future<Member> getCurrentMember() async {
    try {
      Response response = await dio.get("users/$userId");
      Member member = Member.fromJson(response.data['result']);
      if (member.deviceToken == null) {
        String token = await firebaseMessaging.getToken();
        Map<String, dynamic> payload = {"device_token": token};
        updateMember(payload);
      } else {
        String currentToken = await firebaseMessaging.getToken();
        if (member.deviceToken != currentToken) {
          Map<String, dynamic> payload = {"device_token": currentToken};
          firebaseMessaging.subscribe();
          updateMember(payload);
        }
      }
      return member;
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 403) {
          throw e;
        } else if (e.response.statusCode == 404) {
          print('what?');
        }
      }
      return null;
    }
  }

  Future<List<Member>> getMembers(bool hidden) async {
    try {
      Response response =
          await dio.get("users", queryParameters: {"include_hidden": hidden});
      return (response.data['result'] as List)
          .map((i) => Member.fromJson(i))
          .toList();
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 403) {
          throw e;
        }
      }
    }
  }

  Future<List<Job>> getCurrentMemberJobs() async {
    try {
      Response response = await dio.get("users/$userId/jobs");
      return (response.data['result'] as List)
          .map((i) => Job.fromJson(i))
          .toList();
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 403) {
          throw e;
        }
      }
    }
  }

  Future<List<Job>> getMemberJobs(int memberId) async {
    try {
      Response response = await dio.get("users/$memberId/jobs");
      return (response.data['result'] as List)
          .map((i) => Job.fromJson(i))
          .toList();
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 403) {
          throw e;
        }
      }
    }
  }

  // True = only the events the user is the leader of / false = all the users participated
  Future<List<Event>> getCurrentMemberEvents(bool leaderOnly) async {
    try {
      Response response = await dio
          .get("users/$userId/events", queryParameters: {"leader": leaderOnly});
      List<Event> events = (response.data['result'] as List)
          .map((i) => Event.fromJson(i))
          .toList();
      return events;
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 403) {
          throw e;
        }
      }
    }
  }

  Future<List<Event>> getMemberEvents(int memberId, bool leaderOnly) async {
    try {
      Response response = await dio.get("users/$memberId/events",
          queryParameters: {"leader": leaderOnly});
      return (response.data['result'] as List)
          .map((i) => Event.fromJson(i))
          .toList();
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 403) {
          throw e;
        }
      }
    }
  }

  Future<List<Member>> getEventMembers(int eventId) async {
    try {
      Response response = await dio.get("events/$eventId/users");
      return (response.data['result'] as List)
          .map((i) => Member.fromJson(i))
          .toList();
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 403) {
          throw e;
        }
      }
    }
  }

  Future<void> updateMember(Map<String, dynamic> payload) async {
    try {
      await dio.put("users/$userId", data: payload);
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 403) {
          throw e;
        }
      }
    }
  }

  Future<String> getEvent() async {
    try {
      Response response = await dio.get("events/$userId");
      return response.data['result'];
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 403) {
          throw e;
        }
      }
    }
  }

  Future<List<Event>> getEvents() async {
    try {
      Response response = await dio.get("events");
      return (response.data['result'] as List)
          .map((i) => Event.fromJson(i))
          .toList();
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 403) {
          throw e;
        }
      }
    }
  }

  Future<List<Job>> getEventJobs(int eventId) async {
    try {
      Response response = await dio.get("events/$eventId/jobs");
      return (response.data['result'] as List)
          .map((i) => Job.fromJson(i))
          .toList();
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 403) {
          throw e;
        }
      }
    }
  }

  Future<int> addEvent(Map<String, dynamic> payload, bool notification) async {
    try {
      return (await dio.post("events",
              data: payload, queryParameters: {"notify_users": notification}))
          .data['result']['id'];
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 403) {
          throw e;
        }
      }
    }
  }

  Future<void> addCurrentUserToEvent(int eventId) async {
    try {
      await dio
          .post("users/$userId/events", queryParameters: {"event_id": eventId});
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 403) {
          throw e;
        }
      }
    }
  }

  Future<void> addUserToEvent(int eventId, int userId) async {
    try {
      await dio
          .post("events/$eventId/users", queryParameters: {"user_id": userId});
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 403) {
          throw e;
        }
      }
    }
  }

  Future<void> addMembersToEvent(int eventId, List<Member> members) async {
    try {
      List jsonList = List();
      for (Member member in members) {
        jsonList.add(member.id);
      }
      await dio.post("events/$eventId/users", data: jsonList);
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 403) {
          throw e;
        }
      }
    }
  }

  Future<int> updateEvent(int id, Map<String, dynamic> payload) async {
    try {
      return (await dio.put("events/$id", data: payload)).data['status'] as int;
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 403) {
          throw e;
        }
      }
    }
  }

  Future<void> changeEventStatus(int id, bool status) async {
    try {
      await dio.put("events/$id", data: {"finished": status});
    } catch (e) {
      throw e;
    }
  }

  Future<void> removeUserFromEvent(int eventId, int userId) async {
    try {
      await dio.delete("events/$eventId/users",
          queryParameters: {"user_id": userId});
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 403) {
          throw e;
        }
      }
    }
  }

  Future<String> removeCurrentUserFromEvent(int eventId) async {
    try {
      Response response;
      response = await dio.delete("events/$eventId/users",
          queryParameters: {"user_id": userId});
      return response.data['result'];
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 403) {
          throw e;
        }
      }
    }
  }

  Future<Job> getJob(int id) async {
    try {
      Response response = await dio.get("jobs/$id");
      return Job.fromJson(response.data['result']);
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 403) {
          throw e;
        }
      }
    }
  }

  Future<List<Task>> getJobTasks(int jobId) async {
    try {
      Response response = await dio.get("jobs/$jobId/tasks");

      return (response.data['result'] as List)
          .map((i) => Task.fromJson(i))
          .toList();
    } catch (e) {
      throw e;
    }
  }

  Future<String> addJob(Map<String, dynamic> payload) async {
    try {
      Response response = await dio.post("jobs", data: payload);
      return response.data['result'];
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 403) {
          throw e;
        }
      }
    }
  }

  Future<void> addTaskToJob(int jobId, Map<String, dynamic> payload) async {
    try {
      await dio.post("jobs/$jobId/tasks", data: payload);
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 403) {
          throw e;
        }
      }
    }
  }

  Future<void> adminSubmitPoints(
      int memberId, Map<String, dynamic> payload) async {
    try {
      await dio.post("users/$memberId/jobs/admin-submit", data: payload);
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 403) {
          throw e;
        }
      }
    }
  }

  Future<void> deleteJob(int id) async {
    try {
      await dio.delete("events/$id");
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 403) {
          throw e;
        }
      }
    }
  }

  Future<Task> getTask(int id) async {
    try {
      Response response = await dio.get("tasks/$id");
      return Task.fromJson(response.data['result']);
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 403) {
          throw e;
        }
      }
    }
  }

  Future<List<Task>> getTasksWithApprovalStatus(String status) async {
    try {
      Response response =
          await dio.get("tasks", queryParameters: {"approval_status": status});
      return (response.data['result'] as List)
          .map((i) => Task.fromJson(i))
          .toList();
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 403) {
          throw e;
        }
      }
    }
  }

  Future<void> updateTaskEventLeader(
      int eventId, int taskId, String approval) async {
    try {
      await dio.put("events/$eventId/jobs",
          queryParameters: {"approval_status": approval, "task_id": taskId});
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 403) {
          throw e;
        }
      }
    }
  }

  Future<void> updateTask(int id, Map<String, dynamic> payload) async {
    try {
      await dio.put("tasks/$id", data: payload);
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 403) {
          throw e;
        }
      }
    }
  }

  Future<void> adminUpdateTask(int id, Map<String, dynamic> payload) async {
    try {
      await dio.put("tasks/$id/admin-update", data: payload);
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 403) {
          throw e;
        }
      }
    }
  }

  Future<String> deleteTask(int id) async {
    try {
      Response response = await dio.delete("tasks/$id");
      return response.data['result'];
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 403) {
          throw e;
        }
      }
    }
  }

  Future<void> uploadImage(File image) async {
    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(image.path),
      });
      Response response = await dio.post("images/$userId", data: formData);
      return response.data['result'];
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 403) {
          throw e;
        }
      }
    }
  }

  Future<List<ImageHistory>> getPendingImages() async {
    try {
      Response response = await dio.get("images/pending");
      return (response.data['result'] as List)
          .map((i) => ImageHistory.fromJson(i))
          .toList();
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 403) {
          throw e;
        }
      }
    }
  }

  Future<List<ImageHistory>> getMemberImageHistory() async {
    Response response = await dio.get("users/$userId/image-history");

    return (response.data['result'] as List)
        .map((i) => ImageHistory.fromJson(i))
        .toList();
  }

  Future<void> updateImage(int imageId) async {
    try {
      await dio
          .put("users/$userId/image", queryParameters: {"image_id": imageId});
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 403) {
          throw e;
        }
      }
    }
  }

  Future<void> updatePendingImage(int id, String status) async {
    try {
      await dio.put("images/pending/$id",
          queryParameters: {"approval_status": status});
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 403) {
          throw e;
        }
      }
    }
  }

  Future<MessageOfTheDay> getMessageOfTheDay() async {
    try {
      Response response = await dio.get('motd');
      return MessageOfTheDay.fromJson(response.data['result']);
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 403) {
          throw e;
        }
      }
    }
  }

  Future<String> addMessageOfTheDay(Map<String, dynamic> payload) async {
    try {
      Response response = await dio.post('motd', data: payload);
      return response.data['result'];
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 403) {
          throw e;
        }
      }
    }
  }

  Future<void> postTopic(PushNotificationRequest message) async {
    await dio.post('notifications', data: message.postTopicJson());
  }

  Future<void> postMessageToMember(
      int memberId, PushNotificationRequest message) async {
    await dio.post('users/$memberId/notify', data: message.postMessageJson());
  }

  Future<List<Job>> getSelfJobs() async {
    try {
      Response response = await dio.get("jobs/?job_type=SELF");
      return (response.data['result'] as List)
          .map((i) => Job.fromJson(i))
          .toList();
    } catch (e) {
      if (e is DioError) {
        if (e.response.statusCode == 403) {
          throw e;
        }
      }
    }
  }
}
