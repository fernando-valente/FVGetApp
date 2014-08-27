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


Methods for setting the default application for a protocol, MIME type or extension will 
always return a BOOL value indicating if it was possible to change the default 
application. In normal circumstances, it will return a YES value. These methods include:


+(BOOL)setApplication:(NSURL *)appURL forProtocol:(NSString *)protocol;

+(BOOL)setApplication:(NSString *)appDomain forExtension:(NSString 
*)extension;

+(BOOL)setApplication:(NSString *)appDomain forMIMEType:(NSString 
*)MIMEType;

For the first method of the list pass a URL for the app bundle(i.e. /applications/
Safari.app). For the other 2 methods, pass the app domain(i.e. com.apple.itunes).
The method for checking if an app can open a file also returns a BOOL value. The first 
argument must be the URL for an app bundle and the second one an URL for a file.
+(BOOL)isAppCompatible:(NSURL *)appURL withFile:(NSURL *)fileURL;

Methods for getting the default app for a specific protocol, extension or MIME type 
always return a NSDictionary. Methods for getting an app list always return a NSArray of 
NSDictionary. The returned NSDictionary object(s) will always be created using the 
information on the app's info.plist. There are two extra keys which are used to get the 
app icon and the bundle URL:

FVGetAppIconProperty;

FVGetAppURLProperty;

To get the default app for a protocol, extension or MIME type, use one of the following 
methods:

+(NSDictionary *)appForProtocol:(NSString *)protocol;

+(NSDictionary *)appForMIMEType:(NSString *)MIMEType;

+(NSDictionary *)appForExtension:(NSString *)extension;To get a list of apps that can open a certain protocol, extension or MIME type, use one 
of the following methods:

+(NSArray *)allAppsForProtocol:(NSString *)protocol;

+(NSArray *)allAppsForMIMEType:(NSString *)MIMEType;

+(NSArray *)allAppsForExtension:(NSString *)extension;

