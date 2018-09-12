package com.talkingdata.game
{
	import com.talkingdata.game.util.GameFunctionType;

	import flash.external.ExtensionContext;
	import flash.utils.Dictionary;

	public class TalkingDataGA
	{
		public static const functionName:String="GameAnalyticsFunctions";
		internal static var extContext:ExtensionContext;

		public static function onDeactivate():Object{
			try{
			if(extContext==null){
				extContext=ExtensionContext.createExtensionContext("com.talkingdata.game",null);
			}
			return extContext.call(functionName,GameFunctionType.OnPause) ;
			}catch(err:Error){

			}
			return null;
		}
		public static function onStart(appID:String,channel:String):Object{
			try{
				if(extContext==null){
					extContext=ExtensionContext.createExtensionContext("com.talkingdata.game",null);
				}
				return extContext.call(functionName,GameFunctionType.OnResume,appID,channel);
			}catch(err:Error){

			}
			return null;
		}

//		如在官网定制的SDK不包含自定义事件功能， 则删除此方法即可
		public static function onEvent(eventID:String,map:TDCustomEvent):void
		{
			try{
			if(extContext==null){
				extContext=ExtensionContext.createExtensionContext("com.talkingdata.game",null);
			}
			var value:String=map.toTDString();
			extContext.call(functionName,GameFunctionType.CusEvent,eventID,value);
			}catch(err:Error){

			}
		}

		public static function getDeviceID():String{
			try{
			if(extContext==null){
				extContext=ExtensionContext.createExtensionContext("com.talkingdata.game",null);
			}
			return extContext.call(functionName,GameFunctionType.GetDeviceID) as String;
			}catch(err:Error){

			}
			return "";
		}
		public static function setVerboseLogEnabled():void{
			try{
			if(extContext==null){
				extContext=ExtensionContext.createExtensionContext("com.talkingdata.game",null);
			}
			extContext.call(functionName,GameFunctionType.isOpenDebugLog);
			}catch(err:Error){

			}
		}
		public static function setLocation(latitude:Number,longitude:Number):void{
			try{
			if(extContext==null){
				extContext=ExtensionContext.createExtensionContext("com.talkingdata.game",null);
			}
			extContext.call(functionName,GameFunctionType.setlocation,latitude,longitude);
			}catch(err:Error){

			}
		}
		
		public static function setDeviceToken(deviceToken:String):void{
			try{
			if(extContext==null){
				extContext=ExtensionContext.createExtensionContext("com.talkingdata.game",null);
			}
			extContext.call(functionName,GameFunctionType.SetDeviceToken,deviceToken);
			}catch(err:Error){

			}
		}

	}
}
