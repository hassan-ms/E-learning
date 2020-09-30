import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:googleapis/classroom/v1.dart' as gc;
import 'package:googleapis/drive/v3.dart' as ga;

class ClassroomManager with ChangeNotifier {
  gc.ClassroomApi classroom;
  ga.DriveApi drive;
  // ClassroomManager(this.client){
  //    classroom=gc.ClassroomApi(client);
  // }
  List<gc.Announcement> _announcements = [];
  List<gc.CourseWork> _assignments = [];

  List<gc.Announcement> get announcements {
    return _announcements;
  }

  List<gc.CourseWork> get assignments {
    return _assignments;
  }

  Future<void> setClient(authClient) async {
    var client = await authClient;
    classroom = gc.ClassroomApi(client);
    drive = ga.DriveApi(client);
  }

  Future<String> createCoure() async {
    final response = await classroom.courses.create(gc.Course.fromJson({
      'ownerId': 'me',
      'name': 'wrl 3',
      'CourseState': 'ACTIVE',
    }));
    return response.alternateLink;
  }

  Future<void> getCourses() async {
    final coursat = await classroom.courses.list();
    for (var course in coursat.courses) {
      print('${course.name} : ${course.id} : ${course.enrollmentCode}');
    }
  }

  Future<void> createAssignment(assignment, courseId) async {
    final work =
        await classroom.courses.courseWork.create(assignment, courseId);
    _assignments.add(work);
    notifyListeners();
  }

  Future<void> addStudent() async {
    final pf = await classroom.userProfiles.get('me');
    pf.permissions.forEach((perm) {
      print(perm.permission);
    });
    //  final student=await classroom.courses.students.create(gc.Student.fromJson({
    //    'userId':'h.seoody99@gmail.com',
    //    'enrollmentCode':'dauoltg',
    //  }),'149381523211');
    //  print(student.userId);
  }

  // announcements
  Future<void> getAnnouncements(courseId) async {
    try {
      final announcements =
          await classroom.courses.announcements.list(courseId);
      _announcements = announcements.announcements;
    } catch (e) {
      throw e;
    }
  }

  Future<void> addAnnouncement({@required courseId, @required announce}) async {
    try {
      //  final announcement= await classroom.courses.announcements.create(gc.Announcement.fromJson(
      //    {
      //      'text':'hello second',
      //      'materials':[
      //        materials
      //        ]
      //    }
      //  ), courseId);
      final announcement =
          await classroom.courses.announcements.create(announce, courseId);
      _announcements.add(announcement);
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  //assignments
  Future<void> fetchAssignments(courseId) async {
    //final assignments=await classroom.courses.courseWork.list(courseId);
    try {
      final assignments = await classroom.courses.courseWork.list(courseId);
      _assignments = assignments.courseWork;
      notifyListeners();
    } catch (e) {
      print('error :$e');
    }
  }

  Future<List<ga.File>> uploadFiles(List<dynamic> files) async {
    //final course=await classroom.courses.get('148352686559');

    List<ga.File> gfiles = [];
    for (var element in files) {
      final file = File(element.path);
      ga.File fileToUpload = ga.File();
      fileToUpload.parents = [
        '0BzfsOody00jffkVZY2ZaU0FMMnZLRWs1bmhlY2djcTZqc1V5X1J0eEpxbE1aUm9UTmJnLTg'
      ];
      fileToUpload.name = element.name;
      var f = await drive.files.create(fileToUpload,
          uploadMedia: ga.Media(file.openRead(), file.lengthSync()),
          ignoreDefaultVisibility: true);
      gfiles.add(f);
    }
    //   files.forEach((element)async {
    //    final file=File(element.path);
    //    ga.File fileToUpload=ga.File();
    //    fileToUpload.parents=[
    //  '0BzfsOody00jffkVZY2ZaU0FMMnZLRWs1bmhlY2djcTZqc1V5X1J0eEpxbE1aUm9UTmJnLTg'
    //  ];
    //  fileToUpload.name=element.name;
    //   var f=await drive.files.create(fileToUpload,uploadMedia: ga.Media(file.openRead(),file.lengthSync()) );
    //  gfiles.add(f);

    // });

    return gfiles;
  }

  Future<List<gc.StudentSubmission>> getSubmissions(
      courseId, courseWorkId) async {
    List<gc.StudentSubmission> submissions = [];
    try {
      final res = await classroom.courses.courseWork.studentSubmissions
          .list(courseId, courseWorkId);
      submissions = res.studentSubmissions;
    } catch (e) {
      print(e);
    }
    return submissions;
  }

  Future<void> submitAssignment(
      {@required submission,
      @required courseId,
      @required courseWorkId,
      @required submissionID}) async {
    try {
      final response = await classroom.courses.courseWork.studentSubmissions
          .patch(submission, courseId, courseWorkId, submissionID);
          print(response.alternateLink);
          final response2=await classroom.courses.courseWork.studentSubmissions.turnIn(gc.TurnInStudentSubmissionRequest.fromJson({}), courseId, courseWorkId, response.id);
    } catch (e) {
      throw e;
    }
  }
}
