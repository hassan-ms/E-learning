import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/app-bar.dart';
class AddMaterials extends StatefulWidget {
  @override
  _AddMaterialsState createState() => _AddMaterialsState();
}

class _AddMaterialsState extends State<AddMaterials> {
  String _title;
  List<File>_files;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          TheAppBar(),
          Text("Course Materials",
                  style: kSubheadingextStyle.copyWith(
                      fontWeight: FontWeight.bold),textAlign:TextAlign.center,),
          Form(
            child: Column(
              children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'title',
                      
                    ),
                    onChanged: (val){
                      _title=val;
                    },
                    validator:(val){
                      if(val.isEmpty){
                        return 'title can\'t be embty';
                      }
                      return null;
                    },

                  ),
                  Text('Files :'),
                  Row(
                    children: <Widget>[
                      Text('no files is selected please '),
                      FlatButton(onPressed: ()async{
                       final  file =await FilePicker.platform.pickFiles();
                       if(file !=null){
                         print('path: ');
                         print(file.count);
                       }
                      }, child: Text('select file',style:TextStyle(color:Colors.blue),)),
                      
                    ],
                  )

                ],
          ))
        ],
      ),
    );
  }
}