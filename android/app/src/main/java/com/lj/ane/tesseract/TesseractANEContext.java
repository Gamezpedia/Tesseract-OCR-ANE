package com.lj.ane.tesseract;

import java.util.HashMap;
import java.util.Map;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.lj.ane.tesseract.commands.RecognizeCommand;

public class TesseractANEContext extends FREContext {

	public TesseractANEContext() {
		super();
	}

	@Override
	public void dispose() {
		// TODO Auto-generated method stub
	}

	@Override
	public Map<String, FREFunction> getFunctions() {
		Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();
		functionMap.put("recognize", new RecognizeCommand() );

		return functionMap;
	}
}
