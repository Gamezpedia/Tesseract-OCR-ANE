package com.lj.ane.tesseract;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class TesseractANE implements FREExtension {

	public FREContext createContext(String extId) {	
		return new TesseractANEContext();
	}

	@Override
	public void dispose() {
	}

	public void initialize( ) {
	}
}
