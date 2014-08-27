//
//  FVGetApp.h
//  FVGetApp
//
//  Created by Fernando Valente on 9/29/13.
//  Copyright (c) 2013 Fernando Valente. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const FVGetAppIconProperty;
extern NSString * const FVGetAppURLProperty;

@interface FVGetApp : NSObject

+(NSDictionary *)appForProtocol:(NSString *)protocol;
+(BOOL)setApplication:(NSURL *)appURL forProtocol:(NSString *)protocol;
+(NSArray *)allAppsForProtocol:(NSString *)protocol;

+(NSDictionary *)appForMIMEType:(NSString *)MIMEType;
+(BOOL)setApplication:(NSString *)appDomain forMIMEType:(NSString *)MIMEType;
+(NSArray *)allAppsForMIMEType:(NSString *)MIMEType;

+(NSDictionary *)appForExtension:(NSString *)extension;
+(BOOL)setApplication:(NSString *)appBundle forExtension:(NSString *)extension;
+(NSArray *)allAppsForExtension:(NSString *)extension;

+(BOOL)isAppCompatible:(NSURL *)appURL withFile:(NSURL *)fileURL;

@end
