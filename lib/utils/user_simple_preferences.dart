import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences{
  static SharedPreferences _preferences=_preferences;
  static var _fitnessgoal="";
  static const _steps="";
  static  DateTime timestamp=DateTime(1970,1,1);
  static Future init() async=>
    _preferences= await SharedPreferences.getInstance();
    
  static Future setFitnessGoal(String fitnessgoal) async{
    await _preferences.setString(_fitnessgoal,fitnessgoal);
    print(fitnessgoal);
    print("mao zedong");
  }

  static String? getFitnessGoal() {
    _preferences.getString(_fitnessgoal);
    
  }

  static Future saveSteps(int steps) async{
    DateTime currentTimestamp = DateTime.now();
    print(currentTimestamp);
    
    if (timestamp!=DateTime(currentTimestamp.year, currentTimestamp.month, currentTimestamp.day)){
     
      timestamp=DateTime(currentTimestamp.year, currentTimestamp.month, currentTimestamp.day);
      await _preferences.setInt(_steps, steps);
      
    }
  }
  static int? getsavedSteps()=>_preferences.getInt(_steps);
}