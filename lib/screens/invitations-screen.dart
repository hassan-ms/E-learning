import 'package:elearning4/widgets/invitation-item.dart';
import 'package:flutter/material.dart';
import '../widgets/app-bar.dart';
import '../widgets/heading.dart';
import 'package:provider/provider.dart';
import '../providers/classroom-manager.dart';
import '../constants.dart';
class InvitationsScreen extends StatelessWidget {
  Future<void> _refresh(context) async {
    try {
      await Provider.of<ClassroomManager>(context,listen:false).fetchInvitaions();
    } catch (e) {
      displayError(context);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:Column(
          children: [
            TheAppBar(),
            Heading('Invitations'),
            SizedBox(height: 20,),
            Expanded(child:
            FutureBuilder(
            builder: (ctx, snapShot) => snapShot.connectionState ==
                    ConnectionState.waiting
                ? Container(
                    alignment: Alignment.center,
                    //padding: EdgeInsets.only(top: 50),
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refresh(ctx),
                    child: Consumer<ClassroomManager>(
                      builder: (ctx, classroom, _) =>( classroom.invitaions==null)
                          ? Center(
                              child: Text('no invitations found'),
                            )
                          : Container(
                            margin: EdgeInsets.only(top: 10),
                            child: ListView.builder(
                              itemBuilder: (ctx, index) =>InvitationItem(classroom.invitaions[index]),
                              itemCount: classroom.invitaions.length,
                            ),
                          ),
                    )),
            future: _refresh(context),
          ),
             ),
          ],
        ) 
      ),
    );
  }
}