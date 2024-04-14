import 'dart:convert';
import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:async';
import 'dart:io';

List<int> stringtohex(String string) {
  List<int> bytes = [];
  List<int> stringashex=[];
    bytes.addAll(utf8.encode(string));
  bytes.forEach((int ints) {
    stringashex.add(int.parse("0x${ints.toRadixString(16)}"));
  });

  return stringashex;
}
bool? fitness=true;
bool? screentime=false;
bool? custom=true;
bool? timerbool=false;
bool lockstatus=false;
bool lockstatusfitness=false;
bool lockstatusscreentime=false;
void main(){
  List<int> message=[];
  if (custom!){
    message+=stringtohex("c");
  }
  if (fitness!){
    message+=stringtohex("f");
  }
  if (screentime!){
    message+=stringtohex("s");
  }
  if (timerbool!){
    message+=stringtohex("t");
  }
  message+=stringtohex("(");
  if (custom! && lockstatus==true){
    message+=stringtohex("+");
  }
  else if (custom! && lockstatus!=true){
    message+=stringtohex("-");
  }
  if (fitness! && lockstatusfitness==true){
    message+=stringtohex("+");
  }
  else if (fitness! && lockstatusfitness!=true){
    message+=stringtohex("-");
  }
  if (screentime! && lockstatusscreentime==true){
    message+=stringtohex("+");
  }
  else if (screentime! && lockstatusscreentime!=true){
    message+=stringtohex("-");
  }
  message+=stringtohex(")");
  if (fitness!){
          message+=stringtohex("{");
          message+=stringtohex("1234");
        }
print(utf8.decode(message));
}