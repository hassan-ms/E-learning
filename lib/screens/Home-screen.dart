import 'package:elearning4/providers/classroom-manager.dart';
import 'package:elearning4/widgets/app-bar.dart';
import 'package:elearning4/widgets/course-item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app-bar.dart';
import '../constants.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../widgets/bottom-nav-bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool seeAll = false;
  String bottomText='See All';

  bool _isLoading = false;

  @override
  void initState(){
    setState(() {
      _isLoading = true;
    });
     try {
       Future.delayed(Duration.zero, () async {
        await Provider.of<ClassroomManager>(context, listen: false)
            .fetchCourses();
            setState(() {
      _isLoading = false;
    });
      });
    } catch (e) {
      print(e);
      setState(() {
      _isLoading = false;
    });
    }
    

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final courses = Provider.of<ClassroomManager>(context).courses;
    //  List aCourses = seeAll ? courses : courses.take(4).toList();

    // final md = MediaQuery.of(context);
    // final height = md.size.height - md.padding.top - 180;
    // final width = md.size.width;
    // bool _isLandScape = md.orientation == Orientation.landscape;
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TheAppBar(),
            SizedBox(
              height: 30,
            ),
            Container(
              alignment: Alignment.center,
              child: FittedBox(
                  child: Text(
                'welcome Hassan,',
                style: kHeadingextStyle,
              )),
            ),
            SizedBox(height: 6),
            Container(
              alignment: Alignment.center,
              child: Text(
                'be safe be kind be smart',
                style: kSubheadingextStyle.copyWith(
                    fontSize: 15, color: Colors.grey),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Courses',
                    style: kTitleTextStyle.copyWith(
                      fontSize: 22,
                    ),
                  ),
                  FlatButton(
                    child: Text(
                      bottomText,
                      style: kSubtitleTextSyule.copyWith(
                        color: kBlueColor,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        seeAll = !seeAll;
                        seeAll?bottomText='See less':bottomText='See All';
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),
           Expanded(
                child: _isLoading?Center(
              child: CircularProgressIndicator(),
            ):Consumer<ClassroomManager>(builder: (ctx,classroom,_){
                  List bcourses= classroom.courses==null?[]:(seeAll ? classroom.courses : classroom.courses.take(4).toList());
                 return (bcourses.isEmpty ||bcourses==null)?
                 Center(
                  child: Text('no courses found'),
                ):
                  StaggeredGridView.countBuilder(
              crossAxisCount: 2,
              itemBuilder: (context, index) =>
                  CourseItem(bcourses[index], (index + 1) % 4),
              staggeredTileBuilder: (index) => StaggeredTile.fit(1),
              itemCount: bcourses.length,
            );
                },
                )
            ),
          ],
        ),
      ),
    );
  }
}
