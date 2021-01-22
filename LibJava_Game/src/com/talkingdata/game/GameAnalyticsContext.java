package com.talkingdata.game;

import java.util.HashMap;
import java.util.Map;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.tendcloud.tenddata.TDGAProfile;

public class GameAnalyticsContext extends FREContext{

	public TDGAProfile tdProfile;
	@Override
	public void dispose() {
		tdProfile=null;
	}

	@Override
	public Map<String, FREFunction> getFunctions() {
		Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();
		functionMap.put("GameAnalyticsFunctions",new GameAnalyticsFunctions(this));

		return functionMap;
	}

}
