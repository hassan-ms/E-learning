import 'package:elearning4/providers/classroom-manager.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/classroom/v1.dart' as gc;
import 'package:provider/provider.dart';

class InvitationItem extends StatelessWidget {
  final gc.Invitation invitation;
  InvitationItem(this.invitation);
  @override
  Widget build(BuildContext context) {
    return Container(
      child:ListTile(
        title: Text('Invitation'),
        subtitle: Text(invitation.role),
        trailing: FlatButton(onPressed: ()async{
          await Provider.of<ClassroomManager>(context,listen: false).acceptInvitaion(invitation.id);
        }, child: Text('accept',style:TextStyle(color:Colors.blue),)),
      ),
    );
  }
}