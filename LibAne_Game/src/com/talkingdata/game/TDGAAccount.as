package com.talkingdata.game
{
	import com.talkingdata.game.util.GameFunctionType;

	public class TDGAAccount
	{
		
		public static var Gender_Unknown:int=0;
		public static var Gender_Male:int=1;
		public static var Gender_Female:int=2;
		
		public static function setAccount(accountID:String):TDGAAccount{
			var account:TDGAAccount=new TDGAAccount();
			account.setAccount(accountID);
			return account;
		}
		
		public static function getTDAccount():TDGAAccount{
			return new TDGAAccount();
		}
		
		//set Account information
		public function setAccount(accountID:String):void{
			try{
			TalkingDataGA.extContext.call(TalkingDataGA.functionName,GameFunctionType.SetAccountID,accountID);
			}catch(err:Error){
				
			}
		}
		public  function setAccountType(countType:int):void{
			try{
			TalkingDataGA.extContext.call(TalkingDataGA.functionName,GameFunctionType.SetAccount_TYPE,countType);
			}catch(err:Error){
				
			}
		}
		public  function setAccountName(countName:String):void{
			try{
			TalkingDataGA.extContext.call(TalkingDataGA.functionName,GameFunctionType.SetAccount_Name,countName);
			}catch(err:Error){
				
			}
		}
		public  function setAccountAge(countAge:int):void{
			try{
			TalkingDataGA.extContext.call(TalkingDataGA.functionName,GameFunctionType.SetAccount_Age,countAge);
			}catch(err:Error){
				
			}
		}
		public  function setAccountLevel(countLevel:int):void{
			try{
			TalkingDataGA.extContext.call(TalkingDataGA.functionName,GameFunctionType.SetAccount_Level,countLevel);
			}catch(err:Error){
				
			}
		}
		public  function setAccountGender(gender:int):void{
			try{
			TalkingDataGA.extContext.call(TalkingDataGA.functionName,GameFunctionType.SetAccount_Gender,gender);
			}catch(err:Error){
				
			}
		}
		public  function setAccountServer(server:String):void{
			try{
			TalkingDataGA.extContext.call(TalkingDataGA.functionName,GameFunctionType.SetAccount_Server,server);
			}catch(err:Error){
				
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