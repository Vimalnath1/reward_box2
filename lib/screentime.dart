import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:duration/duration.dart';

import 'package:flutter/material.dart';
import 'package:app_usage/app_usage.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:reward_box/fitnessgoals.dart';
import 'package:reward_box/lockboxmode.dart';
import 'package:reward_box/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usage_stats/usage_stats.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

// Future<void> openbox() async {
//   FlutterBluePlus flutterBlue = FlutterBluePlus.instance; 
//   var connecteddevices=await flutterBlue.connectedDevices;
//   for (var device in connecteddevices){
//     if (device.name=="Reward Box"){
//       //Navigator.push(context, MaterialPageRoute(builder: (context)=> const ChatPage()));
//       List<BluetoothService> services = await device.discoverServices();
//       services.forEach((service) async {
//         var characteristics = service.characteristics;
//         if (lockstatus==true){
// for(BluetoothCharacteristic c in characteristics) {
//     await c.write([0x74 , 0x72 , 0x75, 0x65]);
// }
//         }
//         else {
//           for(BluetoothCharacteristic c in characteristics) {
//               await c.write([0x66, 0x61, 0x6C, 0x73, 0x65]);
//           }
//         }
//       });
//     }
//   }
// }
class ScreenTime extends StatefulWidget {
  const ScreenTime({super.key});

  @override
  State<ScreenTime> createState() => _ScreenTimeState();
}
String appname="";
List<String> searchapps=[];
String screengoal="";

class _ScreenTimeState extends State<ScreenTime> {
  List<AppUsageInfo> _infos = [];
  List<UsageInfo> things=[];
  List<Widget> appbuttons=[];
  Map<String, UsageInfo> meow={};
  bool pressed=false;
  late TextEditingController controller;
  // screengoal="";
  bool gotdata=false;
  late SharedPreferences preferences;
  
  //int time=0;
  int tim=0;
  int hours=0;
  int minutes=0;
  @override
  void initState() {
     controller=TextEditingController();
    super.initState();
    init();
  UsageStats.grantUsagePermission();
  }
    Future init() async{
      print(time);
      appname=screentimepreferences.getString("app")!;
      screengoal=screentimepreferences.getString("screengoal")!;
      //setState(()=> this.appname=appname);
      if (appname!=""){
        pressed=true;
      }
    // time=screentimepreferences.getInt("screentime")!;
    // print(time);
  }

  DateTime endDate = DateTime.now();
      DateTime startDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  void getUsageStats() async {
    try {
      
      //DateTime.now().subtract(Duration(hours: 1));//
      print(endDate);
      print(startDate);
      Map<String, UsageInfo> bar = await UsageStats.queryAndAggregateUsageStats(startDate, endDate);
      List<UsageInfo> bare=await UsageStats.queryUsageStats(startDate, endDate);
      List<AppUsageInfo> infoList =await AppUsage().getAppUsage(startDate, endDate);
      setState(() => _infos = infoList);
      setState(() => things = bare);
      setState(() {
        meow=bar;
      });
      // bar.forEach((key, value) {
      //   print("$key ${value.totalTimeInForeground}");
      // });

      
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }
    Future openDialog(var apps)=> showDialog(
  
  context: context, 
  builder: (context)=>AlertDialog(
    title: Text("Set Goal"),
    content:Column(children: [
      TextField(
      autofocus: true,
      decoration:InputDecoration(hintText: "Set goal time in hours"),
      controller: controller,
    ),
    ElevatedButton(onPressed: () {showSearch(context: context, delegate: CustomSearchDelegate());},child: Text("Choose App"),),
      ]
    ), 
    actions: [
     TextButton(onPressed: () {
        {Navigator.of(context).pop(controller.text);}
        controller.clear();

      }, child: Text("Submit")),

    ],
  )
);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Screen Time Mode"),
        centerTitle: true,
      ),
      body:Center(
        child: Column(
          children: [
            SizedBox(height: 15,),
              Text("Press the button below to search for the app and set a timer for your goal.",
              textAlign: TextAlign.center,
              ),
            ElevatedButton(onPressed: () async {
              List<AppInfo> apps = await InstalledApps.getInstalledApps(true, false);
              for (var app in apps){
                searchapps.add((app.name).toString());
              }
              final screengoal=await openDialog(appbuttons);
              screentimepreferences.setString("app",appname);
              screentimepreferences.setString("screengoal",screengoal);
              // setState(()=>screengoal=screengoal!);
              setState(() {
                pressed=true;
              });
        }, child: Text("Set Goal")),
          ElevatedButton(onPressed: ()  {
            //AppSettings.openAppSettings(type:AppSettingsType.display);
            //FlutterBackgroundService().invoke("setAsBackground");
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const FitnessScreen()));
          }, child: Text("Settings")),
        pressed?
        Column(children: [
          Text("App Chosen: $appname"),
          ElevatedButton(onPressed: () async {
            time=0;
            getUsageStats();
            List<AppInfo> apps = await InstalledApps.getInstalledApps(true, true);
          String selectedapp="";
          int tin=0;
          
          for (var app in apps){
                if (appname==app.name){
                  selectedapp=app.packageName!;
                }
              }
          for (var thing in things){
            
          if (thing.packageName==selectedapp){
            tin+=1;
            
            print(thing.firstTimeStamp);
            print(thing.lastTimeStamp);
            //print(thing.lastTimeUsed);
            print(thing.totalTimeInForeground!);
          time+=int.parse(thing.totalTimeInForeground!);
          print(tin);
      //     meow.forEach((key, value) {
      //       if (key==selectedapp){
      //   //print("$key ${value.totalTimeInForeground}");
      //   time+=int.parse(value.totalTimeInForeground!);
      //   }
      //  });
          }
          
          //print(thing.packageName);

        
            }
          //time=(time/tin).round();
          //if (int.parse(screentimepreferences.getString("${selectedapp} FirstTime")!)<startDate.millisecondsSinceEpoch){
            print(time);
            if (screentimepreferences.getInt("${selectedapp} PreviousTime")!=null){
              time-=screentimepreferences.getInt("${selectedapp} PreviousTime")!;
            }
            
            //print(screentimepreferences.getInt("${selectedapp} PreviousTime")!);
            if (time<0){
              time=0;
            }
            //screentimepreferences.setInt("screentime",time);
             print(screentimepreferences.getString("${selectedapp} FirstTime")!);
             print(screentimepreferences.getString("${selectedapp} EndTime")!);
            
          //}
          for (var info in _infos) {
            if (info.packageName==selectedapp){
              print(info.startDate);
              print(info.endDate);
              List<String> gettingtime=info.
              usage.toString().split("");
              print(gettingtime);
              tim+=int.parse(gettingtime[0])*60;
              tim+=int.parse(gettingtime[2]+gettingtime[3]);
              print(tim);

               minutes=(int.parse(screengoal)*60)-((time/60000).floor());
               print(minutes);
              if (minutes>60){
                minutes=minutes-((minutes/60).floor())*60;
              }
              print((time/1000/60));
              if (time/1000/60>1.0){
               hours=int.parse(screengoal)-((time/1000/3600).ceil());
              }
              else{
                hours=int.parse(screengoal)-((time/1000/3600).floor());
              }
               print(hours);
          print(time);
          print(int.parse(screengoal)*60);
              if (time<(int.parse(screengoal)*3600*1000)){
                lockstatusscreentime=true;
              }
              else{
                lockstatusscreentime=false;
              }
              screentimeprogress=[];
              screentimeprogress+=stringtohex("p");
          screentimeprogress+=stringtohex("s");
          screentimeprogress+=stringtohex("(");
          screentimeprogress+=stringtohex(appname);
          screentimeprogress+=stringtohex(",");
          screentimeprogress+=stringtohex(screengoal);
          screentimeprogress+=stringtohex("/");
          if (lockstatusscreentime){
            screentimeprogress+=stringtohex("+");
          }
          else{
            screentimeprogress+=stringtohex("-");
          }
          screentimeprogress+=stringtohex(")");
              openbox();
              setState(() {
                gotdata=true;
              });
              
            } 
          }
          }, child: const Text("Get Screen Time Data")),
            if (gotdata)
              Text("Goal: $screengoal hours"),
            if (hours>=0 && gotdata) 
              Text("Time Remaining: $hours hours and $minutes minutes"),
            if (minutes<0)
              Text("You have exceeded the goal")
          
          ])

        :Text(""),
       ] ),),
      
            
    );
  }
}
class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return[
      IconButton(onPressed: () {
        query="";
      }, icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: () {
        close(context, null);
      }, icon: Icon(Icons.arrow_back));
    
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery=[];
    for (var app in searchapps){
      if (app.toLowerCase().contains(query.toLowerCase())){
        matchQuery.add(app);
      }
    }
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) { 
        var result=matchQuery [index]; 
        return ListTile( 
          title: Text(result),
          
        ); // ListTile
      },
    );
  } 

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery=[];
    for (var app in searchapps){
      if (app.toLowerCase().contains(query.toLowerCase())){
        matchQuery.add(app);
      }
    }
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) { 
        var result=matchQuery [index]; 
        return ListTile( 
          title: Text(result),
          onTap: () {
            appname=result;
            print(appname);
            Navigator.of(context).pop();
          },
        ); // ListTile
      },
    );
  }

}