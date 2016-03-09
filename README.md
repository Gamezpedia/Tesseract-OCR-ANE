# Tesseract OCR ANE
Tesseract OCR Adobe Native Extension for Android &amp; iOS.

Getting Started
=================
**NB**: You'll need trained data files (https://github.com/tesseract-ocr/tessdata) to be located in `tessdata` directory (deployed together with your project or already available on target device) in order Tesseract engine to work.

In order to use Tesseract OCR in your AS3/AIR project:

1. Add ANE to your project.

2. Instatntiate the main ANE class:

    ```
    _ane = TesseractANE.getInstance();
    ```
	
3. Setup recognition params:

    - (required!) absolute path to /tessdata folder, meaning `"/storage/sdcard0/data/"` to be provided if your tess data files are located at `/storage/sdcard0/data/tessdata/` folder:
    
    ```
    _ane.absoluteTessdataPath = "<path>"; 
    ```

    - (optional, `"eng"` by default) set of languages to be used for recognition:
        
    ```
    _ane.language = "eng+rus";
    ```

    - (optional, `"1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"` by default) set of chars to be recognized:
        
    ```
    _ane.charset = "123ABC";
    ```

4. Setup recognition result listener:

    ```
    _ane.addEventListener(TesseractANEEvent.RECOGNIZED, onTextRecognized);
    ...
    protected function onTextRecognized(event:TesseractANEEvent):void {
        trace("end recoignizing " + event.uuid + " > " + event.text);
    }
    ```
	
5. Pass `BitmapData` instance for OCR processing:

    ```
    var uuid : String = _ane.recognize(bitmap.bitmapData));
    ```
	
   The method will return UUID string value that can be used for identification in case you start some recognition processes simultaneousely.
	
6. After the recognition process completes you'll receive `TesseractANEEvent.RECOGNIZED` event, containing recognized text and corresponding process UUID value.

    ```
    trace("end recoignizing " + event.uuid + " > " + event.text);
    ```
	
Usage Tips
=================
* The whole available set of trained data files require a lot of disk space, it's better to deploy files only for languages that you are going to use (see file names).

	
Customization Tips
=================

* Update path variables at the beginning of `buildANE` script for your platform (`.bat` for Win, `.sh` for OSX) before trying to rebuild ANE.
* All the build scripts are processing files only inside the `build` folder and subfolders, so you'll need to copy all updated `*.a`, `*.so` or `*.aar` there yourself after making changes in native projects.
* Due to the big size of resulting ANE file you can change `buildANE` script for your platform (`.bat` for Win, `.sh` for OSX) and `extension.xml` and rebuild ANE just for Android or iOS.

License
=================

Tesseract OCR Adobe Native Extension is distributed under the Apache 2.0 license (see LICENSE.md).

Tesseract OCR iOS and TesseractOCR.framework, maintained by Daniele Galiotto (founder) (http://www.g8production.com), are distributed under the MIT license (see 
https://opensource.org/licenses/MIT).

Tess-two, maintained by Robert Theis (support page https://stackoverflow.com/questions/tagged/tess-two), is
distributed under the Apache 2.0 license (see 
http://www.apache.org/licenses/LICENSE-2.0).

Tesseract, maintained by Google (http://code.google.com/p/tesseract-ocr/), is
distributed under the Apache 2.0 license (see 
http://www.apache.org/licenses/LICENSE-2.0).
