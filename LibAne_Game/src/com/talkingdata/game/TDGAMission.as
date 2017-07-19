package com.talkingdata.game
{
	import com.talkingdata.game.util.GameFunctionType;

	public class TDGAMission
	{
		public static function onMessionBegin(missionID:String):void{
			try{
			TalkingDataGA.extContext.call(TalkingDataGA.functionName,GameFunctionType.MissionBegin,missionID);
			}catch(err:Error){
				
			}
		}
		public static function onMissionCompleted(missionID:String):void{
			try{
			TalkingDataGA.extContext.call(TalkingDataGA.functionName,GameFunctionType.MissionCompleted,missionID);
			}catch(err:Error){
				
			}
		}
		
		public static function onMissionFailed(missionID:String,cause:String):void{
			try{
			TalkingDataGA.extContext.call(TalkingDataGA.functionName,GameFunctionType.MissionFailed,missionID,cause);
			}catch(err:Error){
				
			}
		}
	}
}