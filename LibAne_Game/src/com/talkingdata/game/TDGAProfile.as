package com.talkingdata.game
{
	import com.talkingdata.game.util.GameFunctionType;

	public class TDGAProfile
	{
		
		public static var Gender_Unknown:int=0;
		public static var Gender_Male:int=1;
		public static var Gender_Female:int=2;
		
		public static function setProfile(profileID:String):TDGAProfile{
			var profile:TDGAProfile=new TDGAProfile();
			profile.setProfile(profileID);
			return profile;
		}
		
		public static function getTDGAProfile():TDGAProfile{
			return new TDGAProfile();
		}
		
		//set Account information
		public function setProfile(profileID:String):void{
			try{
			TalkingDataGA.extContext.call(TalkingDataGA.functionName,GameFunctionType.SetProfileID,profileID);
			}catch(err:Error){
				trace(err)	
			}
		}
		public  function setProfileType(profileType:int):void{
			try{
			TalkingDataGA.extContext.call(TalkingDataGA.functionName,GameFunctionType.SetProfile_TYPE,profileType);
			}catch(err:Error){
				trace(err)	
			}
		}
		public  function setProfileName(profileName:String):void{
			try{
			TalkingDataGA.extContext.call(TalkingDataGA.functionName,GameFunctionType.SetProfile_Name,profileName);
			}catch(err:Error){
				trace(err)	
			}
		}
		public  function setProfileAge(age:int):void{
			try{
			TalkingDataGA.extContext.call(TalkingDataGA.functionName,GameFunctionType.SetProfile_Age,age);
			}catch(err:Error){
				trace(err)	
			}
		}
		public  function setProfileLevel(level:int):void{
			try{
			TalkingDataGA.extContext.call(TalkingDataGA.functionName,GameFunctionType.SetProfile_Level,level);
			}catch(err:Error){
				trace(err)	
			}
		}
		public  function setProfileGender(gender:int):void{
			try{
			TalkingDataGA.extContext.call(TalkingDataGA.functionName,GameFunctionType.SetProfile_Gender,gender);
			}catch(err:Error){
				trace(err)	
			}
		}
		public  function setProfileServer(gameServer:String):void{
			try{
			TalkingDataGA.extContext.call(TalkingDataGA.functionName,GameFunctionType.SetProfile_Server,gameServer);
			}catch(err:Error){
				trace(err)	
			}
		}
		
		//get Account information
//		public function getAccountID():String{
//			return callFunction(GameFunctionType.getAccountID) as String;
//		}
//		public function getAccountAge():int{
//			return callFunction(GameFunctionType.getAccount_Age) as int;
//		}
//		public function getAccountGender():int{
//			return callFunction(GameFunctionType.getAccount_Gender) as int;
//		}
//		public function getAccountID():String{
//			return callFunction(GameFunctionType.getAccountID) as String;
//		}
//		public function getAccountID():String{
//			return callFunction(GameFunctionType.getAccountID) as String;
//		}
//		public function getAccountID():String{
//			return callFunction(GameFunctionType.getAccountID) as String;
//		}
//		public function getAccountID():String{
//			return callFunction(GameFunctionType.getAccountID) as String;
//		}
		

	}
}