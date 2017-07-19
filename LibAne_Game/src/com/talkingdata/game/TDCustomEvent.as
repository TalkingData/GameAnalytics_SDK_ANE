package com.talkingdata.game
{
	import flash.system.System;
	
	import mx.states.OverrideBase;
	

	public class TDCustomEvent
	{
		private var valueCount:int=0;
		private var mvalue:String="{";
		public function TDCustomEvent()
		{
			
		}
		public function setEntityString(key:String,value:String):int{
			if(valueCount>9) return 10;
			if(valueCount>0){this.mvalue+=",";}
			this.mvalue=mvalue+"\""+key+"\""+":\""+value+"\"";
			return ++valueCount;
		}
		
		public function setEntityInt(key:String,value:int):int{
			if(valueCount>9) return 10;
			if(valueCount>0){this.mvalue+=",";}
			this.mvalue=mvalue+"\""+key+"\""+":"+value;
			return ++valueCount;
		}
		
		internal function toTDString():String{
			return mvalue+="}";
		}
		
	}
}