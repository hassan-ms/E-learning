import 'package:flutter/cupertino.dart';
import 'package:googleapis/classroom/v1.dart' as gc;

class ClassroomManager with ChangeNotifier{
   
   gc.ClassroomApi classroom;
  // ClassroomManager(this.client){
  //    classroom=gc.ClassroomApi(client);
  // }
  List<gc.Announcement> _announcements=[];
  List<gc.CourseWork>_assignments=[];

  List<gc.Announcement> get announcements{
    return _announcements;
    
  }

  List<gc.CourseWork>get assignments{
    return _assignments;
  }
  Future<void> setClient(authClient)async{
     var client = await authClient;
    classroom = gc.ClassroomApi(client);
  }
  
   Future<String> createCoure()async{
      final response=await classroom.courses.create(gc.Course.fromJson({
        'ownerId':'me',
        'name':'wrl 3',
        'CourseState':'ACTIVE',
      }));
      return response.alternateLink;
  }
   Future<void> getCourses()async{
    
    final coursat = await classroom.courses.list();
    for (var course in coursat.courses) {
      print('${course.name} : ${course.id} : ${course.enrollmentCode}');
    }
  }
   void createWork()async{
    
    final work = await classroom.courses.courseWork.create(gc.CourseWork.fromJson({
      'title':'second homework',
      'workType':'ASSIGNMENT',
      'state':'PUBLISHED'
    }),'149381523211');
    print(work.creationTime);
  }
   Future<void> addStudent()async{
     final pf = await classroom.userProfiles.get('me');
     pf.permissions.forEach((perm){
       print(perm.permission);
     });
    //  final student=await classroom.courses.students.create(gc.Student.fromJson({
    //    'userId':'h.seoody99@gmail.com',
    //    'enrollmentCode':'dauoltg',
    //  }),'149381523211');
    //  print(student.userId);
  }
  // announcements 
  Future<void> getAnnouncements(courseId)async{
    try{
      final announcements =await classroom.courses.announcements.list(courseId);
     _announcements= announcements.announcements;
    }
    catch(e){
      throw e;
    }
  }

  Future <void> addAnnouncement(gc.Announcement announce,courseId)async{
    try{
     final announcement= await classroom.courses.announcements.create(gc.Announcement.fromJson({
       'text':announce.text,
       'materials':announce.materials,
       'state':'published',
       'materials':announce.materials,

     }), courseId);
     _announcements.add(announcement);
    }
    catch(e){
      print(e);
    }
    notifyListeners();
  }
  //assignments
  Future<void> fetchAssignments(courseId)async{
    //final assignments=await classroom.courses.courseWork.list(courseId);
    try{
      final assignments=await classroom.courses.courseWork.list(courseId);
      _assignments= assignments.courseWork;
      notifyListeners();
    }
    catch(e){
      print(e);
    }
    
  }
  
  
}