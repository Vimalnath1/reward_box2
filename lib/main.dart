import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reward_box/bluetooth.dart';
import 'package:reward_box/fitnessgoals.dart';
import 'package:reward_box/lockboxmode.dart';
import 'package:reward_box/multiplegoalthing.dart';
import 'package:reward_box/screentime.dart';
import 'package:reward_box/timerpage.dart';
import 'package:reward_box/utils/user_simple_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:usage_stats/usage_stats.dart';

var stepdata=0;
var caloriedata=0;
var stepsleft="";
var caloriesleft="";
int time=0;
List<int> fitnessprogress=[];
List<int> screentimeprogress=[];
List<int> parentalprogress=[];
List<int> timerprogress=[];
List<String> timerhex=[];
String minutes="";
TimeOfDay lightuptime=TimeOfDay.now();
bool? fitness=false;
bool? screentime=false;
bool? custom=false;
bool? timerbool=false;
late SharedPreferences goalpreferences;
late SharedPreferences screentimepreferences;
late SharedPreferences preferences;
bool lockstatus=false;
bool lockstatusfitness=false;
bool lockstatusscreentime=false;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  screentimepreferences=await SharedPreferences.getInstance();
  goalpreferences=await SharedPreferences.getInstance();
  FlutterBackgroundService().invoke("setAsBackground");
  
  await initializeService();

  /*if (Platform.isAndroid) {
    WidgetsFlutterBinding.ensureInitialized();
    [Permission.location,
      Permission.storage,
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.bluetoothAdvertise
    ].request().then((status) {
  runApp( const MaterialApp(home: MyApp()));
  });
  } else {*/
  //await UserSimplePreferences.init();
  
  runApp(const MaterialApp(home: MyApp()));
      
  //}
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
@override
void initState(){
  super.initState();
    init();
      print("meo");
        
      }
      Future init() async {
      
      if (goalpreferences.getBool("fitness")!=null){
        setState(() {
          fitness=goalpreferences.getBool("fitness");
        });
      
      }
      else{
        setState(() {
          fitness=false;
        });
        
      }
      if (goalpreferences.getBool("screentime")!=null){
      screentime=goalpreferences.getBool("screentime");
      }
      else{
        screentime=false;
      }
      if (goalpreferences.getBool("custom")!=null){
      custom=goalpreferences.getBool("custom");
      }
      else{
        custom=false;
      }
      if (goalpreferences.getBool("timer")!=null){
      timerbool=goalpreferences.getBool("timer");
      }
      else{
        timerbool=false;
      }
      
    }
    
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Reward Box"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
              SizedBox(height: 15,),
              Text("Hello Reward Box Users! We are so excited for you to use our product. On this app, you must connect to your Reward Box via Bluetooth and then choose which mode you want to use. This will track your progress on each mode and will open your box.",
              textAlign: TextAlign.center,
              ),
              ElevatedButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Checklist()));
                
              }, child:Text("Choose Goals")),
              ElevatedButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const BluetoothScreen()));
              }, child: Text("Connect to Device")),
              Visibility(visible: fitness!,child: 
              ElevatedButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const FitnessScreen()));
              }, child:Text("Fitness Mode")),
              ),
              Visibility(visible: timerbool!,child: 
              ElevatedButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const TimerMode()));
              }, child:Text("Timer Mode")),
              ),
              // ElevatedButton(onPressed: () {
              //   Navigator.push(context, MaterialPageRoute(builder: (context)=> const MultipleGoals()));
              // }, child:Text("Multiple Goals and New Main Screen")),
              Visibility(visible: custom!,child: 
              ElevatedButton(onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (context)=>const LockboxScreen()));
              }, child:Text("Parental Mode")),
              ),
              Visibility(visible: screentime!,child: 
              ElevatedButton(onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (context)=>const ScreenTime()));
              }, child:Text("Screen Time Mode")),
              )
          ]
          ),
      ),
    );
  }
}
class Checklist extends StatefulWidget {
  const Checklist({super.key});

  @override
  State<Checklist> createState() => _ChecklistState();
}




class _ChecklistState extends State<Checklist> {


Widget checkbox(bool changingvalue, String title){
  return CheckboxListTile(
    title:Text(title),
    value: changingvalue, 
    onChanged: (bool? value) {
      setState(() {
        changingvalue=value!;
        print(value);
      });
        
      //fitness=value!;
      
    }); 
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Goal Selection"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(children:[ 
            CheckboxListTile(
    title:Text("Fitness"),
    value: fitness, 
    onChanged: (bool? value) {
      setState(() {
        fitness=value!;
        print(value);
        goalpreferences.setBool("fitness", fitness!);
      });
      setState(() {
                  fitness=fitness!;
                });
      
    }
    ),
            CheckboxListTile(
    title:Text("Screentime Goal"),
    value: screentime, 
    onChanged: (bool? value) {
      setState(() {
        screentime=value!;
        print(value);
        goalpreferences.setBool("screentime", screentime!);
      });
    }
    ),
    CheckboxListTile(
    title:Text("Parental Goal"),
    value: custom, 
    onChanged: (bool? value) {
      setState(() {
        custom=value!;
        print(value);
        goalpreferences.setBool("custom", custom!);
      });
    }
    ),
    CheckboxListTile(
    title:Text("Timer Goal"),
    value: timerbool, 
    onChanged: (bool? value) {
      setState(() {
        timerbool=value!;
        print(value);
        goalpreferences.setBool("timer", timerbool!);
      });
    }
    ),
     ElevatedButton(onPressed: () {
      
      
      
       Navigator.push(context, MaterialPageRoute(builder: (context)=> const MyApp()));
     }, child: Text("Submit"))
          ]
        ),
      ),
    );
  }
}
Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  /// OPTIONAL, using custom notification channel id
  

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: false,

      // notificationChannelId: 'my_foreground',
      // initialNotificationTitle: 'AWESOME SERVICE',
      // initialNotificationContent: 'Initializing',
      // foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );

  service.startService();
}
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  // For flutter prior to version 3.0.0
  // We have to register the plugin manually
  goalpreferences=await SharedPreferences.getInstance();
  screentimepreferences=await SharedPreferences.getInstance();
  preferences=await SharedPreferences.getInstance();
  DateTime currentTime=DateTime.now();
  int nexttime=DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(Duration(hours:23,minutes: 55)).millisecondsSinceEpoch;
  int delay=nexttime-currentTime.millisecondsSinceEpoch;
  // int otherdelay=DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(Duration(hours:23,minutes: 22)).millisecondsSinceEpoch-DateTime.now().millisecondsSinceEpoch;
  // print(otherdelay);
  // Timer(Duration(milliseconds:otherdelay), (){
  //   preferences.setString("goal",(81352).toString());
  // });
  // print(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(Duration(hours: 20,minutes: 30)).millisecondsSinceEpoch);
  // print(currentTime.millisecondsSinceEpoch);
  print(delay);
  Timer(Duration(milliseconds:delay), () async { 
    DateTime endDate = DateTime.now();
    DateTime startDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    List<UsageInfo> things=await UsageStats.queryUsageStats(startDate, endDate);

    List<AppInfo> apps = await InstalledApps.getInstalledApps(true, true);
    List<int> times=[];
          String selectedapp="";
          int tin=0;
          // for (var app in apps){
          //       if (appname==app.name){
          //         selectedapp=app.packageName!;
          //       }
          //     }
          for (var thing in things){
            if (int.parse(thing.firstTimeStamp!)>DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).millisecondsSinceEpoch){
            screentimepreferences.setString("${thing.packageName!} FirstTime", thing.firstTimeStamp!);
            screentimepreferences.setString("${thing.packageName!} EndTime", thing.lastTimeStamp!);
            
          times.add(int.parse(thing.totalTimeInForeground!));
          //screentimepreferences.setInt("${thing.packageName!} PreviousTime", 110000);
          screentimepreferences.setInt("${thing.packageName!} PreviousTime", times[times.length-1]);
          print("${thing.packageName!} PreviousTime");
          times=[];
          // print(tin);
          }
          }
Timer(Duration(milliseconds:(nexttime-currentTime.millisecondsSinceEpoch)), () async { 
    DateTime endDate = DateTime.now();
    DateTime startDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    List<UsageInfo> things=await UsageStats.queryUsageStats(startDate, endDate);

    List<AppInfo> apps = await InstalledApps.getInstalledApps(true, true);
    List<int> times=[];
          String selectedapp="";
          int tin=0;
          // for (var app in apps){
          //       if (appname==app.name){
          //         selectedapp=app.packageName!;
          //       }
          //     }
          for (var thing in things){
            if (int.parse(thing.firstTimeStamp!)>DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).millisecondsSinceEpoch){
            screentimepreferences.setString("${thing.packageName!} FirstTime", thing.firstTimeStamp!);
            screentimepreferences.setString("${thing.packageName!} EndTime", thing.lastTimeStamp!);
            
          times.add(int.parse(thing.totalTimeInForeground!));
          //screentimepreferences.setInt("${thing.packageName!} PreviousTime", 110000);
          screentimepreferences.setInt("${thing.packageName!} PreviousTime", times[times.length-1]);
          print("${thing.packageName!} PreviousTime");
          times=[];
          // print(tin);
          }
          }

          //}
    // fitness=true;
    // goalpreferences.setBool("fitness",fitness!);
    // print(fitness);
  });
          //}
    // fitness=true;
    // goalpreferences.setBool("fitness",fitness!);
    // print(fitness);
  });


  /// OPTIONAL when use custom notification


  if (service is AndroidServiceInstance) {
    

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

}
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);

  return true;
}