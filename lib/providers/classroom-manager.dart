import 'package:googleapis/classroom/v1.dart' as gc;
class ClassroomManager{
  static void createCoure(client){
    var classroom = gc.ClassroomApi(client);
      final response=classroom.courses.create(gc.Course.fromJson({
        'ownerId':'me',
        'name':'wrl first',
      }));
      print(response);
  }
}