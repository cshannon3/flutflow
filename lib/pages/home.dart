

import 'package:flutflow/state_manager.dart';
import 'package:flutter/material.dart';
import 'package:no_brainer/components/animated_list.dart';
import 'package:no_brainer/utils/other.dart';
import 'package:no_brainer/utils/url.dart';




class AnimTest extends StatelessWidget {
  StateManager stateManager;

  AnimTest(this.stateManager);

  List<Widget> languages({List<String> langs}) {
    if (langs == null) langs = ["Dart/Flutter", "C++", "Python", "Ruby"];
    List<Widget> out = [];
    langs.forEach((lang) {
      out.add(MaterialButton(
        color: Colors.blueGrey.withOpacity(0.4),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        onPressed: () {},
        child: Text(
          lang,
          style: TextStyle(color: Colors.white),
        ),
      ));
    });
    return out;
  }

  Widget project(Size s,
      {String imageUrl, String name, String githubUrl, dynamic demoOnPress}) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: .15 * s.width,
          height: .3 * s.height,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              border: Border.all(color: Colors.black, width: 3.0)),
          child: Column(
            children: <Widget>[
              Container(
                width: .15 * s.width,
                child: ClipRRect(
                  borderRadius: new BorderRadius.circular(15.0),
                  child: Image.network(
                    imageUrl,
                    height: .15 * s.height,
                    width: .15 * s.width,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          decoration: TextDecoration.underline,
                        )),
                    Container(
                      height: 30.0,
                      width: 0.15 * s.width,
                      child: Row(
                        children: <Widget>[
                          Container(
                              width: 0.057 * s.width,
                              child: (githubUrl != null)
                                  ? gitHubButton(githubUrl)
                                  : null),
                          Container(
                              width: 0.057 * s.width,
                              child: (demoOnPress != null)
                                  ? demoButton(demoOnPress)
                                  : null),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget gitHubButton(String githubUrl) =>
      matbutton("Github", () => launch(githubUrl));

  Widget demoButton(Function onpress) => matbutton("Demo", onpress);

  Widget matbutton(String name, Function onPress) {
    return MaterialButton(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.blueGrey),
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      onPressed: onPress,
      child: Text(
        name,
        style: TextStyle(
            color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14.0),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Align(
            alignment: Alignment.topLeft,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: //Image.network("http://www.pngall.com/wp-content/uploads/2017/05/World-Map-Free-Download-PNG.png", ),
                    CircleAvatar(
                  radius: 120.0,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage("assets/coverphoto2.jpg"),
                ))),
        Align(
            alignment: Alignment.topCenter,
            child: Padding(
                padding: const EdgeInsets.only(left:8.0, top:30, right:8.0),
                child: //Image.network("http://www.pngall.com/wp-content/uploads/2017/05/World-Map-Free-Download-PNG.png", ),
                    Text(
                  "Welcome, I'm Connor Shannon",
                  style: TextStyle(
                      fontSize: 45.0,
                      color: Colors.white,
                      fontStyle: FontStyle.italic),
                ))),
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Projects",
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            )),
        CustomAnimatedList(
          onStart: true,
          hasToggleButton: false,
          introDirection: DIREC.LTR,
          size: s,
          widgetList: languages(),
          lrtb: LRTBsize(0.1, 0.82, 0.48, 0.53),
        ),
        CustomAnimatedList(
          onStart: true,
          hasToggleButton: false,
          introDirection: DIREC.LTR,
          size: s,
          widgetList: <Widget>[
            project(s,
                name: "Reddit Clone",
                githubUrl: "https://github.com/cshannon3/reddit_clone_f",
                imageUrl:
                    "https://media.wired.com/photos/5954a1b05578bd7594c46869/master/w_1600,c_limit/reddit-alien-red-st.jpg"),
            project(s,
                name: "Gui Boxes",
                demoOnPress: () => stateManager.changeScreen("/guiboxes"),
                imageUrl:
                    "https://h5p.org/sites/default/files/styles/medium-logo/public/logos/drag-and-drop-icon.png?itok=0dFV3ej6"),
            project(s,
                name: "Paint",
                demoOnPress: () => stateManager.changeScreen("/paint"),
                githubUrl: "https://github.com/cshannon3/flutter_paint",
                imageUrl:
                    "https://www.californiapaints.com/wp-content/uploads/californiapaints-favicon.png"),
            project(s,
                name: "Smart Contract App",
                githubUrl: "https://github.com/cshannon3/fund-a-feature",
                imageUrl:
                    "https://cdn-images-1.medium.com/max/770/1*cCM-v2LMlWmhibkqu705Qg.png"),
             project(s,
                name: "Fourier Transform",
                 demoOnPress: () => stateManager.changeScreen("/fourier"),
                githubUrl: "https://github.com/cshannon3/fund-a-feature",
                imageUrl:
                    "https://res.cloudinary.com/practicaldev/image/fetch/s--AH7lgFXb--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/v1p6fhprekoheceqafw1.png"),
            project(s,
                name: "Music Apps",
                githubUrl: "https://github.com/cshannon3/guitar_vis_f",
                imageUrl:
                    "https://continuingstudies.uvic.ca/upload/Arts/Courses/MUS-MusicTheory-Course-Header-min_mobile.jpg"),
            project(s,
                name: "API Interface Program",
                githubUrl:
                    "https://github.com/cshannon3/http_apis_and_scrapers_intro",
                imageUrl: "https://www.lucentasolutions.com/images/apinew.jpg"),
          ],
          lrtb: LRTBsize(0.0, 0.82, 0.53, 0.85),
        
        ),
      ],
    );
  }
}