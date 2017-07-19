package com.talkingdata.game;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;
import com.tendcloud.tenddata.TalkingDataGA;

public class GameAnalyticsExtension implements FREExtension{

	@Override
	public FREContext createContext(String arg0) {
		TalkingDataGA.sPlatformType=TalkingDataGA.PLATFORM_TYPE_AIR;
		GameAnalyticsContext gameAnalyticsContext = new GameAnalyticsContext();
//		gameAnalyticsContext.tdAccount=TDGAAccount.setAccount("12233333");
		return gameAnalyticsContext;
	}

	@Override
	public void dispose() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void initialize() {
		// TODO Auto-generated method stub
		
	}

}
