import 'dart:io';
import 'package:flutter/material.dart';
import 'package:googleapis/classroom/v1.dart' as gc;
import 'package:googleapis/drive/v3.dart' as ga;

class ClassroomManager with ChangeNotifier {
  gc.ClassroomApi classroom;
  ga.DriveApi drive;
  String _courseID='148352686559';
  // ClassroomManager(this.client){
  //    classroom=gc.ClassroomApi(client);
  // }
  List<gc.Announcement> _announcements = [];
  List<gc.CourseWork> _assignments = [];
  List<gc.Course>_courses=[];
  List<gc.Invitation>_invitaions=[];

  List<gc.Announcement> get announcements {
    return _announcements;
  }

  List<gc.CourseWork> get assignments {
    return _assignments.reversed.toList();
  }

  List<gc.Course> get courses {
    return _courses;
  }
  set courseId(courseID){
    _courseID=courseID;
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

  Future<void> fetchCourses() async {
    try{
      final courses = await classroom.courses.list();
    _courses=courses.courses;}
    catch(e){
      throw e;
    }
    notifyListeners();
  }

  Future<void> createAssignment(assignment) async {
    try{
      final work =
        await classroom.courses.courseWork.create(assignment, _courseID);
    _assignments.add(work);
    notifyListeners();
    }
    catch(e){
      throw e;
    }
    
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
  Future<void> getAnnouncements() async {
    try {
      final announcements =
          await classroom.courses.announcements.list(_courseID);
          if(announcements.announcements!=null){
            _announcements = announcements.announcements;
          }
      
    } catch (e) {
      throw e;
    }
  }

  Future<void> addAnnouncement({ @required announce}) async {
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
          await classroom.courses.announcements.create(announce, _courseID);
      _announcements.add(announcement);
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  //assignments
  Future<void> fetchAssignments() async {
    //final assignments=await classroom.courses.courseWork.list(courseId);
    try {
      final assignments = await classroom.courses.courseWork.list(_courseID);
      if(assignments.courseWork!=null){
        _assignments = assignments.courseWork;
      }
      
      notifyListeners();
    } catch (e) {
      print('error :$e');
    }
  }

  Future<List<ga.File>> uploadFiles(folder,List<dynamic> files) async {
    //final course=await classroom.courses.get('148352686559');

    List<ga.File> gfiles = [];
    for (var element in files) {
      final file = File(element.path);
      ga.File fileToUpload = ga.File();
      fileToUpload.parents = [
        folder
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
    Future uploadAssignment(courseId,files)async{
    final response = await classroom.courses.get(_courseID);
    final folder=response.teacherFolder.id;
   // return  uploadFiles(folder, files);
   print(folder);
    
    
  }
  Future<void>deleteAssignment(assId)async{
    try {
     await classroom.courses.courseWork.delete(_courseID, assId);
     _assignments.removeWhere((element) => element.id==assId);
    } catch (e) {
      throw e;
    }
    notifyListeners();
  }
  Future<void>removeAnnouncement(id)async{
    try {
      await classroom.courses.announcements.delete(_courseID,id);
    } catch (e) {
      throw e;
    }
    notifyListeners();
  }
  // invitaions
  Future<void>fetchInvitaions()async{
    try {
      final invitations=await classroom.invitations.list(userId: 'me');
      // if(invitations!=null){
      //   _invitaions=invitations.invitations;
      //   invitations.invitations.forEach((element) {
      //     print(' role :${element.id}');
      //   });
      // }
    print(invitations.invitations);
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }
 List<gc.Invitation> get invitaions{
    return _invitaions;
    
  } 
  Future<void>acceptInvitaion(id)async{
     try {
       await classroom.invitations.accept(id);
     } catch (e) {
       throw e;
     }
     notifyListeners();
  } 

  Future<void> setTeacherFolder()async{
   final student= await classroom.courses.students.get(_courseID, 'me');
    print(student.studentWorkFolder.alternateLink);
  }
  void emptyFields(){
    _announcements=[];
    _assignments=[];
    notifyListeners();
  }
}
