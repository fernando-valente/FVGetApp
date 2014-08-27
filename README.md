FVGetApp
========

FVGetApp is an open source class to get and set default apps for protocols, MIME 
types and extensions. It's also possible to retrieve a list of apps that can open a 
protocol, MIME type or extension. As an extra it's also possible to use this class to know 
if an app can open a certain file.


Protocols, extensions and MIME types are case insensitive. Whenever dealing with 
protocols you should never include a ":" in the end of the argument(i.e. pass @"http" 
and not @"http:" as an argument). When dealing with file extensions, never include a 
dot in the beginning of the argument(i.e. pass @"png" instead of @".png").


The methods to set the default application for a protocol, MIME type or extension will 
always return a BOOL value indicating if it was possible to change the default 
application. In normal circumstances, it will return a YES value. These methods include:


+(BOOL)setApplication:(NSURL *)appURL forProtocol:(NSString *)protocol;

+(BOOL)setApplication:(NSString *)appDomain forExtension:(NSString 
*)extension;

+(BOOL)setApplication:(NSString *)appDomain forMIMEType:(NSString 
*)MIMEType;

The arguments for the first method are a URL pointing to the location of the bundle(e.g. /applications/
Safari.app). For the other 2 methods, pass the app domain(e.g. com.apple.itunes).

The method for checking if an app can open a file also returns a BOOL value. The first 
argument is the URL for an app bundle and the second one a URL for a file.

+(BOOL)isAppCompatible:(NSURL *)appURL withFile:(NSURL *)fileURL;

The methods for getting the default app for a specific protocol, extension or MIME type 
always return a NSDictionary. The methods that return list of apps always return a NSArray containing 
NSDictionarys. The returned NSDictionary object(s) are created using the 
information obtained from the app's info.plist. For example, to get the copyright information, get the value for NSHumanReadableCopyright. There are two extra keys that are not present on NSBundles. Those are FVGetAppIconProperty and FVGetAppURLProperty. What each one contains is pretty much self explanatory.

To get the default app for a protocol, extension or MIME type, use one of the following 
methods:

+(NSDictionary *)appForProtocol:(NSString *)protocol;

+(NSDictionary *)appForMIMEType:(NSString *)MIMEType;

+(NSDictionary *)appForExtension:(NSString *)extension;

To get a list of apps that can open a certain protocol, extension or MIME type, use one of the following methods:

+(NSArray *)allAppsForProtocol:(NSString *)protocol;

+(NSArray *)allAppsForMIMEType:(NSString *)MIMEType;

+(NSArray *)allAppsForExtension:(NSString *)extension;

