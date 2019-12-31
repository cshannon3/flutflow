class ProjectData{
  final String name;
  final String githubUrl;
  final String imageUrl;
  final String demoPath;

  ProjectData({this.name, this.githubUrl, this.imageUrl, this.demoPath});

}  
    
List<ProjectData> projects = [
    ProjectData(
                name: "Reddit Clone",
                githubUrl: "https://github.com/cshannon3/reddit_clone_f",
                imageUrl: "https://media.wired.com/photos/5954a1b05578bd7594c46869/master/w_1600,c_limit/reddit-alien-red-st.jpg",
            ),ProjectData(
                name: "Gui Boxes",
                demoPath:"/guiboxes",
                imageUrl:"https://h5p.org/sites/default/files/styles/medium-logo/public/logos/drag-and-drop-icon.png?itok=0dFV3ej6",
            ),ProjectData(
                name: "Paint",
               demoPath:"/paint",
                githubUrl: "https://github.com/cshannon3/flutter_paint",
                imageUrl:
                    "https://www.californiapaints.com/wp-content/uploads/californiapaints-favicon.png",
            ),
            ProjectData(
                name: "Smart Contract App",
                githubUrl: "https://github.com/cshannon3/fund-a-feature",
                imageUrl:
                    "https://cdn-images-1.medium.com/max/770/1*cCM-v2LMlWmhibkqu705Qg.png",
             ),
             ProjectData(
                name: "Fourier Transform",
                demoPath:"/fourier",
                githubUrl: "https://github.com/cshannon3/fund-a-feature",
                imageUrl:
                    "https://res.cloudinary.com/practicaldev/image/fetch/s--AH7lgFXb--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/v1p6fhprekoheceqafw1.png",
            ),
            ProjectData(
                name: "Music Apps",
                githubUrl: "https://github.com/cshannon3/guitar_vis_f",
                imageUrl:
                    "https://continuingstudies.uvic.ca/upload/Arts/Courses/MUS-MusicTheory-Course-Header-min_mobile.jpg",
            ),
            ProjectData(
                name: "API Interface Program",
                githubUrl:
                    "https://github.com/cshannon3/http_apis_and_scrapers_intro",
                imageUrl: "https://www.lucentasolutions.com/images/apinew.jpg",
          )
          ];
          