import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reward_box/bluetooth.dart';
import 'package:reward_box/fitnessgoals.dart';
import 'package:reward_box/lockboxmode.dart';
import 'package:reward_box/screentime.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MultipleGoals extends StatefulWidget {
  const MultipleGoals({super.key});

  @override
  State<MultipleGoals> createState() => _MultipleGoalsState();
}


class _MultipleGoalsState extends State<MultipleGoals> {
  

  // Future openDialog()=> showDialog(
  
  // context: context, 
  // builder: (context)=>AlertDialog(
  //   title: Text("Choose Goal"),
  //   content: Column(children: [
  //     CheckboxListTile(
  //   title:Text("Fitness"),
  //   value: fitness, 
  //   onChanged: (bool? value) {
  //     setState(() {
  //       fitness=value!;
  //       print(value);
  //     });
  //   }
  //     )
      

  //   ]
  //   ),
//     actions: [
//       TextButton(onPressed: () {
        
//         {Navigator.of(context).pop(controller.text);}
//       }, child: Text("Submit")),

//     ],
//   )
// );
// Widget checklist(){
//   return 
// }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Multiple Goals"),
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
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const BluetoothScreen()));
              }, child: Text("Connect to Device")),
              
              
          ]
          ),
      ),
    );
    
  }
}

