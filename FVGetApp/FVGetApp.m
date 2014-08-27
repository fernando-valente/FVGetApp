//
//  FVGetApp.m
//  FVGetApp
//
//  Created by Fernando Valente on 9/29/13.
//  Copyright (c) 2013 Fernando Valente. All rights reserved.
//

#import "FVGetApp.h"

@implementation FVGetApp

NSString *const FVGetAppIconProperty = @"FVGetAppIconProperty";
NSString *const FVGetAppURLProperty= @"FVGetAppURLProperty";

#pragma Protocols

+(NSDictionary *)appForProtocol:(NSString *)protocol{
    CFURLRef cfPointer = NULL;
    protocol = [protocol stringByAppendingString:@":"];
    NSURL *protocolURL = [NSURL URLWithString:protocol];
    
    OSStatus appExists = LSGetApplicationForURL((__bridge CFURLRef)protocolURL, kLSRolesAll, NULL, &cfPointer);
    
    NSURL *URL = (__bridge NSURL *)cfPointer;
    
    if(appExists == noErr){
        NSBundle *appBundle = [NSBundle bundleWithURL:URL];
        NSMutableDictionary *appDictionary = [NSMutableDictionary dictionaryWithDictionary:[appBundle infoDictionary]];
        
        NSImage *icon = [[NSWorkspace sharedWorkspace] iconForFile:[URL path]];
        [icon setSize:NSMakeSize(512, 512)];
        
        [appDictionary setObject:icon forKey:FVGetAppIconProperty];
        [appDictionary setObject:URL forKey:FVGetAppURLProperty];
        
        return appDictionary;
    }
    
    if(cfPointer)
        CFRelease(cfPointer);
    
    return nil;
}

+(NSArray *)allAppsForProtocol:(NSString *)protocol{
    protocol = [protocol stringByAppendingString:@":"];
    NSURL *protocolURL = [NSURL URLWithString:protocol];
    
    CFArrayRef appExists = LSCopyApplicationURLsForURL((__bridge CFURLRef)protocolURL, kLSRolesAll);
    
    if(!appExists)
        return nil;
    
    NSMutableArray *arr = [NSMutableArray array];
        
    for(int i = 0; i < CFArrayGetCount(appExists); i++){
        NSURL *URL = (__bridge NSURL *)CFArrayGetValueAtIndex(appExists, i);
        
        NSBundle *appBundle = [NSBundle bundleWithURL:URL];
        NSMutableDictionary *appDictionary = [NSMutableDictionary dictionaryWithDictionary:[appBundle infoDictionary]];
        
        NSImage *icon = [[NSWorkspace sharedWorkspace] iconForFile:[URL path]];
        [icon setSize:NSMakeSize(512, 512)];
        
        [appDictionary setObject:icon forKey:FVGetAppIconProperty];
        [appDictionary setObject:URL forKey:FVGetAppURLProperty];
        
        [arr addObject:appDictionary];
    }
    
    CFRelease(appExists);
    
    return arr;
}

+(BOOL)setApplication:(NSURL *)appURL forProtocol:(NSString *)protocol{
    NSBundle *appBundle = [NSBundle bundleWithURL:appURL];
    NSString *identifier = [appBundle bundleIdentifier];
    
    OSStatus err = LSSetDefaultHandlerForURLScheme((__bridge CFStringRef)protocol, (__bridge CFStringRef)identifier);
    
    return (err == noErr);
}

#pragma MIMEType

+(NSDictionary *)appForMIMEType:(NSString *)MIMEType{
    CFURLRef cfPointer = NULL;
    OSStatus appExists = LSCopyApplicationForMIMEType((__bridge CFStringRef)MIMEType, kLSRolesAll, &cfPointer);
    
    NSURL *URL = (__bridge NSURL *)cfPointer;
    
    if(appExists == noErr){
        NSBundle *appBundle = [NSBundle bundleWithURL:URL];
        NSMutableDictionary *appDictionary = [NSMutableDictionary dictionaryWithDictionary:[appBundle infoDictionary]];
        
        NSImage *icon = [[NSWorkspace sharedWorkspace] iconForFile:[URL path]];
        [icon setSize:NSMakeSize(512, 512)];
        
        [appDictionary setObject:icon forKey:FVGetAppIconProperty];
        [appDictionary setObject:URL forKey:FVGetAppURLProperty];
        
        CFRelease(cfPointer);
        
        return appDictionary;
    }
    
    if(cfPointer)
        CFRelease(cfPointer);
    
    return nil;
}

+(NSArray *)allAppsForMIMEType:(NSString *)MIMEType{
    CFStringRef strRef = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)MIMEType, kUTTypeData);
    
    CFArrayRef appExists = LSCopyAllRoleHandlersForContentType(strRef, kLSRolesAll);
    
    if(!appExists)
        return nil;
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for(int i = 0; i < CFArrayGetCount(appExists); i++){
        CFURLRef URLRef = NULL;
        
        LSFindApplicationForInfo(kLSUnknownCreator,  CFArrayGetValueAtIndex(appExists, i), NULL, NULL, &URLRef);
        
        
        NSURL *URL = (__bridge NSURL *)URLRef;

        if(URL){
            NSBundle *appBundle = [NSBundle bundleWithURL:URL];
            NSMutableDictionary *appDictionary = [NSMutableDictionary dictionaryWithDictionary:[appBundle infoDictionary]];
        
            NSImage *icon = [[NSWorkspace sharedWorkspace] iconForFile:[URL path]];
            [icon setSize:NSMakeSize(512, 512)];
            
            [appDictionary setObject:icon forKey:FVGetAppIconProperty];
            [appDictionary setObject:URL forKey:FVGetAppURLProperty];
            
            [arr addObject:appDictionary];
            
            CFRelease(URLRef);
        }
    }
    
    CFRelease(appExists);
    
    return arr;
}

+(BOOL)setApplication:(NSString *)appDomain forMIMEType:(NSString *)MIMEType{
    CFStringRef strRef = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)MIMEType, kUTTypeData);
    
    OSStatus err = LSSetDefaultRoleHandlerForContentType(strRef, kLSRolesAll, (__bridge CFStringRef)appDomain);
    
    return (err == noErr);
}


#pragma FileExtension

+(NSDictionary *)appForExtension:(NSString *)extension{
    CFStringRef strRef = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)extension, kUTTypeData);
    CFStringRef appBundleDomain = LSCopyDefaultRoleHandlerForContentType(strRef, kLSRolesAll);
    
    if(appBundleDomain == NULL)
        return nil;
    
    CFURLRef URLRef = NULL;
    
    LSFindApplicationForInfo(kLSUnknownCreator, appBundleDomain, NULL, NULL, &URLRef);
    
    NSURL *URL = (__bridge NSURL *)URLRef;
    
    if(URL != NULL){
        NSBundle *appBundle = [NSBundle bundleWithURL:URL];
        NSMutableDictionary *appDictionary = [NSMutableDictionary dictionaryWithDictionary:[appBundle infoDictionary]];
        
        NSImage *icon = [[NSWorkspace sharedWorkspace] iconForFile:[URL path]];
        [icon setSize:NSMakeSize(512, 512)];
        
        [appDictionary setObject:icon forKey:FVGetAppIconProperty];
        [appDictionary setObject:URL forKey:FVGetAppURLProperty];
        
        CFRelease(URLRef);
        
        return appDictionary;
    }
    
    return nil;
}

+(NSArray *)allAppsForExtension:(NSString *)extension{
    CFStringRef strRef = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)extension, kUTTypeData);
    
    CFArrayRef appExists = LSCopyAllRoleHandlersForContentType(strRef, kLSRolesAll);
    
    if(!appExists)
        return nil;
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for(int i = 0; i < CFArrayGetCount(appExists); i++){
        CFURLRef URLRef = NULL;
        
        LSFindApplicationForInfo(kLSUnknownCreator,  CFArrayGetValueAtIndex(appExists, i), NULL, NULL, &URLRef);
        
        
        NSURL *URL = (__bridge NSURL *)URLRef;
        
        if(URL){
            NSBundle *appBundle = [NSBundle bundleWithURL:URL];
            NSMutableDictionary *appDictionary = [NSMutableDictionary dictionaryWithDictionary:[appBundle infoDictionary]];
            
            NSImage *icon = [[NSWorkspace sharedWorkspace] iconForFile:[URL path]];
            [icon setSize:NSMakeSize(512, 512)];
            
            [appDictionary setObject:icon forKey:FVGetAppIconProperty];
            [appDictionary setObject:URL forKey:FVGetAppURLProperty];
            
            [arr addObject:appDictionary];
            
            CFRelease(URLRef);
        }
    }
    
    CFRelease(appExists);
    
    return arr;
}

+(BOOL)setApplication:(NSString *)appDomain forExtension:(NSString *)extension{
    CFStringRef strRef = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)extension, kUTTypeData);
   
    OSStatus err = LSSetDefaultRoleHandlerForContentType(strRef, kLSRolesAll, (__bridge CFStringRef)appDomain);
    
    return (err == noErr);
}

#pragma FileCompatibility

+(BOOL)isAppCompatible:(NSURL *)appURL withFile:(NSURL *)fileURL{
    Boolean canAccept;
    
    LSCanURLAcceptURL((__bridge CFURLRef)fileURL, (__bridge CFURLRef)appURL, kLSRolesAll, kLSAcceptDefault, &canAccept);
    
    return canAccept;
}

@end
