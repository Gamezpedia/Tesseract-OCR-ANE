//
//  ANETesseract.m
//  ANETesseract
//
//  Created by Vyacheslav Orlovsky on 2/15/16.
//  Copyright (c) 2016 Vyacheslav Orlovsky. All rights reserved.
//

#import "ANETesseract.h"
#import "FlashRuntimeExtensions.h"
#import "TesseractOCR.h"

#define event_recognized (const uint8_t*)"status_recognized"
#define event_log (const uint8_t*)"status_log"

NSOperationQueue *queue;

UIImage* decodeBase64ToImage(NSString* encodedImageString)
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:encodedImageString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    return [UIImage imageWithData:data];
}

void logStatus(FREContext ctx, NSString* message)
{
    FREDispatchStatusEventAsync(ctx, event_log, (const uint8_t *)[[NSString stringWithFormat:@"%@", message] UTF8String]);
}

NSString* FREObjectToNSString(FREObject value)
{
    uint32_t paramStringLength;
    const uint8_t *paramStringUTF8;
    
    FREGetObjectAsUTF8(value, &paramStringLength, &paramStringUTF8);
    
    return [NSString stringWithUTF8String:(char*)paramStringUTF8];
}

FREObject NSStringToFREObject(NSString* value)
{
    FREObject freObject;
    const char *str = [value UTF8String];
    FRENewObjectFromUTF8((uint32_t)(strlen(str) + 1), (const uint8_t*)str, &freObject);
    
    return freObject;
}

FREObject recognize(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    logStatus(ctx, @"start recognition");
    
    NSString* language = FREObjectToNSString(argv[1]);
    NSString* absoluteDataPath = FREObjectToNSString(argv[3]);
    
//    logStatus(ctx, absoluteDataPath);
    
    // Create RecognitionOperation
    G8RecognitionOperation *operation = [[G8RecognitionOperation alloc] initWithLanguage:language
                                                                        configDictionary:nil
                                                                         configFileNames:nil
                                                                        absoluteDataPath:absoluteDataPath
                                                                              engineMode:G8OCREngineModeTesseractOnly
                                                                  copyFilesFromResources:FALSE];
    
//    logStatus(ctx, @"operation created");
    
//    operation.tesseract.language = @"eng";
    
    NSString* charWhiteList = FREObjectToNSString(argv[2]);
    
    operation.tesseract.charWhitelist = charWhiteList;
    
//    logStatus(ctx, operation.tesseract.absoluteDataPath);
    
    NSString* encodedImageString = FREObjectToNSString(argv[0]);
    
    UIImage *image = decodeBase64ToImage(encodedImageString);
    
    logStatus(ctx, [NSString stringWithFormat:@"bitmap %f %f", image.size.width, image.size.height]);
    
    operation.tesseract.image = image;
    
//    logStatus(ctx, @"image set");
    
    NSString *uuid = [[NSUUID UUID] UUIDString];

    operation.recognitionCompleteBlock = ^(G8Tesseract *recognizedTesseract) {
        logStatus(ctx, [NSString stringWithFormat:@"recognized text = %@", [recognizedTesseract recognizedText]]);
        
        FREDispatchStatusEventAsync(ctx, event_recognized, (const uint8_t *)[[NSString stringWithFormat:@"%@ %@", uuid, [recognizedTesseract recognizedText]] UTF8String]);
    };

    [queue addOperation:operation];
    
//    logStatus(ctx, @"added to queue");

    return NSStringToFREObject(uuid);
}

void LJTesseractANEContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet) {
        
    *numFunctionsToTest = 1;
    FRENamedFunction* func = (FRENamedFunction*)malloc(sizeof(FRENamedFunction) * 1);
    
    func[0].name = (const uint8_t*)"recognize";
    func[0].functionData = NULL;
    func[0].function = &recognize;

    *functionsToSet = func;
    
    queue = [[NSOperationQueue alloc] init];
}

void LJTesseractANEContextFinalizer(FREContext ctx) {
            
    return;
}

void LJTesseractANEInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet,
                             FREContextFinalizer* ctxFinalizerToSet) {
        
    *extDataToSet = NULL;
    *ctxInitializerToSet = &LJTesseractANEContextInitializer;
    *ctxFinalizerToSet = &LJTesseractANEContextFinalizer;
}

void LJTesseractANEFinalizer(void* extData) {
            
    return;
}