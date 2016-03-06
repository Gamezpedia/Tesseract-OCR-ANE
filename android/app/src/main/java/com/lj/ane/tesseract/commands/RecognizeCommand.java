package com.lj.ane.tesseract.commands;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Base64;
import android.util.Log;
import android.widget.Toast;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;
import com.googlecode.tesseract.android.TessBaseAPI;

import java.util.UUID;

public class RecognizeCommand implements FREFunction  {
    private final String TAG = "RecognizeCommand";

	private final String STATUS_RECOGNIZED = "status_recognized";
    private final String STATUS_LOG = "status_log";

	public FREObject call(final FREContext ctx, FREObject[] passedArgs) {
//        logStatus(ctx, "RecognizeCommand");

		final String imageData = getPassedString(passedArgs[0]);
        final String language = getPassedString(passedArgs[1]);
        final String charsWhiteList = getPassedString(passedArgs[2]);
        final String absoluteTessdataPath = getPassedString(passedArgs[3]);

        final String uuid = UUID.randomUUID().toString();

        logStatus(ctx, language);
        logStatus(ctx, charsWhiteList);
        logStatus(ctx, absoluteTessdataPath);
        logStatus(ctx, uuid);

        Thread thread = new Thread(new Runnable() {
            public void run() {
                logStatus(ctx, "start recognition");

                Bitmap bitmap = decodeBase64(imageData);

                logStatus(ctx, "bitmap "+bitmap.getWidth() + " " + bitmap.getHeight());

                String text = recognize(bitmap, language, charsWhiteList, absoluteTessdataPath);

                logStatus(ctx, "recognized text = " + text);

                ctx.dispatchStatusEventAsync(STATUS_RECOGNIZED, uuid + " " + text);
            }

            private String recognize( Bitmap bitmap, String language, String charsWhiteList, String absoluteTessdataPath ) {
                TessBaseAPI baseApi = new TessBaseAPI();
//                logStatus(ctx, "TessBaseAPI created");
                baseApi.init(absoluteTessdataPath, language);
//                logStatus(ctx, "TessBaseAPI init");
                baseApi.setVariable("tessedit_char_whitelist", charsWhiteList);
//                logStatus(ctx, "whitelist set");
                baseApi.setImage(bitmap);
//                logStatus(ctx, "bitmap set");
                String recognizedText = baseApi.getUTF8Text();
//                logStatus(ctx, "text received");
                baseApi.end();
//                logStatus(ctx, "TessBaseAPI ended");

                return recognizedText;
            }

            private Bitmap decodeBase64(String input)
            {
                byte[] decodedByte = Base64.decode(input, 0);
                return BitmapFactory.decodeByteArray(decodedByte, 0, decodedByte.length);
            }
        });
        thread.start();

        return getFREObjectFromString(uuid);
	}

    private String getPassedString( FREObject param ) {
        String value =  null;
        try {
            value = param.getAsString();
        } catch (FRETypeMismatchException e) {
            e.printStackTrace();
        } catch (FREInvalidObjectException e) {
            e.printStackTrace();
        } catch (FREWrongThreadException e) {
            e.printStackTrace();
        }

        return value;
    }

    private FREObject getFREObjectFromString( String value ) {
        FREObject freObject = null;

        try {
            freObject = FREObject.newObject(value);
        } catch (FREWrongThreadException e) {
            e.printStackTrace();
        }

        return freObject;
    }

    private void logStatus(final FREContext ctx, String value ) {
        Log.d(TAG, value);

        ctx.dispatchStatusEventAsync(STATUS_LOG, value);
    }
}