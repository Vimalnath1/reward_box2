import 'dart:async';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:reward_box/main.dart';

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}
void sendtrue(){}
Widget devicebutton(String title, BuildContext context){
  return ElevatedButton(onPressed: () async {
    FlutterBluePlus flutterBlue = FlutterBluePlus.instance; 
    var result;
    // FlutterBluePlus.instance.startScan(timeout: const Duration(milliseconds: 100));
    //             FlutterBluePlus.instance.stopScan();
                Timer(Duration(milliseconds: 100), () {
  flutterBlue.startScan(timeout: const Duration(seconds: 1));
});
    result=flutterBlue.scanResults;
    result.listen((results) {
      for (ScanResult devices in results){
        if (devices.device.localName==title){
          devices.device.connect();
          Navigator.push(context, MaterialPageRoute(builder: (context)=> const MyApp()));
        }
      }
      },
      onError: (err) {
        print("Not working");
      }
      );
      
    
    // Stop scanning
    flutterBlue.stopScan();
  var connecteddevices=await flutterBlue.connectedDevices;
  /*for (var device in connecteddevices){
    if (device.name=="Reward Box"){
      //Navigator.push(context, MaterialPageRoute(builder: (context)=> const ChatPage()));
      List<BluetoothService> services = await device.discoverServices();
      services.forEach((service) async {
        var characteristics = service.characteristics;
for(BluetoothCharacteristic c in characteristics) {
    await c.write([0x74 , 0x72 ,0x75, 0x65]);
}

// Writes to a characteristic

      });
    }
  }*/
  }, 
  child: Text(title));
}
List <Widget> devicebuttons=[];
class _BluetoothScreenState extends State<BluetoothScreen> {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  
  var result;
  var devicelist=Set();
  bool thing=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bluetooth"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [ 
              ElevatedButton( child: Text("Turn on Bluetooth"), onPressed: () {
                  flutterBlue.turnOn();
                  
                }, 
              ),
              ElevatedButton( child: Text("Scan for Devices"), onPressed: () {
                setState(() {
                  devicelist=Set();
                });
              
                // FlutterBluePlus.instance.startScan(timeout: const Duration(milliseconds: 100));
                // FlutterBluePlus.instance.stopScan();
                // Timer(Duration(milliseconds: 100), () {
  flutterBlue.startScan(timeout: const Duration(seconds: 1));
// });
                
                //print(flutterBlue.);
                result=flutterBlue.scanResults;

                result.listen((results) {
                  for (ScanResult devices in results){
                    print(devices.device.name);
                    devicelist.add(devices.device.name);
                  }
                 },
                 onError: (err) {
                   print("Not working");
                 }
                 );
                 print(devicelist);
                 
                // Stop scanning
                
                
              },
              ),
              ElevatedButton(onPressed: () {
                setState(() {
                  devicebuttons=[];
                  thing=false;
                });
                print(devicelist);
                for (var devicename in devicelist){
                  devicename=devicename.trim();
                  if (devicename!=""){
                  devicebuttons.add(devicebutton(devicename,context));
                  }
                  print("wahoo");
                  if (devicebuttons.isNotEmpty){
                  setState(() {
                  thing=true;
                });}
                }}, child: Text("Show Devices")),
              thing?

              GridView.count(shrinkWrap:true,crossAxisCount: devicebuttons.length, children: List.generate(devicebuttons.length, (index){
                return devicebuttons.elementAt(index);
              })
              )
                :Text("Press the scan button"),
              
            
          ],
        ),
      ),
    
    );
  }
}