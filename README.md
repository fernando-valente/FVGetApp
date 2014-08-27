FVGetApp
========

FVGetApp is an open source class to get and set the default apps for protocols, MIME 
types and extensions(e.g. default web browser). It's also possible to retrieve a list of apps that can open a 
protocol, MIME type or extension. FVGetApp can also be used to find out if an app can open a certain file.


Protocols, extensions and MIME types are case insensitive. Whenever passing protocols as arguments, never include a ":" in the end of the argument(e.g. pass @"http" 
and not @"http:"). When dealing with file extensions, never include a 
dot in the beginning of the argument(e.g. pass @"png" instead of @".png").

The methods to set the default application for a protocol, MIME type or extension will 
always return a BOOL value indicating if the operation was successful. In other words, if you try to set Firefox as the default web browser and it returns NO, it means something went wrong. Those methods are:

+(BOOL)setApplication:(NSURL *)appURL forProtocol:(NSString *)protocol;

+(BOOL)setApplication:(NSString *)appDomain forExtension:(NSString 
*)extension;

+(BOOL)setApplication:(NSString *)appDomain forMIMEType:(NSString 
*)MIMEType;

The arguments for the first method are a URL pointing to the location of the app bundle(e.g. /applications/
Safari.app). For the other 2 methods, pass the app domain(e.g. com.apple.itunes).

The method for checking if an app can open a file also returns a BOOL value. The first 
argument should be a URL pointing to where the app bundle is located and the second one a URL for a file.

+(BOOL)isAppCompatible:(NSURL *)appURL withFile:(NSURL *)fileURL;

The methods for getting the default app for protocol, extension or MIME type 
always return a NSDictionary. Methods that return list of apps always return a NSArray containing 
NSDictionarys. The returned NSDictionary object(s) contain the 
information obtained from the app's info.plist. For example, to get the copyright information, get the value for NSHumanReadableCopyright. There are two extra keys that are not present on NSBundles. Those are FVGetAppIconProperty and FVGetAppURLProperty. What each one contains is pretty much self explanatory.

To get the default app for a protocol, extension or MIME type, use one of the following 
methods:

+(NSDictionary *)appForProtocol:(NSString *)protocol;

+(NSDictionary *)appForMIMEType:(NSString *)MIMEType;

+(NSDictionary *)appForExtension:(NSString *)extension;

To get a list of apps that can open a protocol, extension or MIME type, use one of the following methods:

+(NSArray *)allAppsForProtocol:(NSString *)protocol;

+(NSArray *)allAppsForMIMEType:(NSString *)MIMEType;

+(NSArray *)allAppsForExtension:(NSString *)extension;

