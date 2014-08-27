//
//  FVAppDelegate.h
//  FVGetApp
//
//  Created by Fernando Valente on 9/29/13.
//  Copyright (c) 2013 Fernando Valente. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FVGetApp.h"

@interface FVAppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource>{
    //Protocols
    IBOutlet NSTextField *protocolField;
    IBOutlet NSTextField *protocolNameField;
    IBOutlet NSTextField *protocolAppName;
    IBOutlet NSTextField *protocolAppCopyright;
    IBOutlet NSTextField *protocolAppVersion;
    IBOutlet NSTextField *protocolAppURL;
    IBOutlet NSTextField *protocolAppDomain;
    IBOutlet NSImageView *protocolAppIcon;
    IBOutlet NSTableView *allAppsForProtocolTableView;
    IBOutlet NSPopover *popoverProtocol;
    NSArray *allAppsForProtocolArray;
    
    //MIME Type
    IBOutlet NSTextField *MIMETypeField;
    IBOutlet NSTextField *MIMETypeNameField;
    IBOutlet NSTextField *MIMETypeAppName;
    IBOutlet NSTextField *MIMETypeAppCopyright;
    IBOutlet NSTextField *MIMETypeAppVersion;
    IBOutlet NSTextField *MIMETypeAppURL;
    IBOutlet NSTextField *MIMETypeAppDomain;
    IBOutlet NSImageView *MIMETypeAppIcon;
    IBOutlet NSTableView *allAppsForMIMETypeTableView;
    IBOutlet NSPopover *popoverMIMEType;
    NSArray *allAppsForMIMETypeArray;
    
    //Extensions
    IBOutlet NSTextField *extensionField;
    IBOutlet NSTextField *extensionNameField;
    IBOutlet NSTextField *extensionAppName;
    IBOutlet NSTextField *extensionAppCopyright;
    IBOutlet NSTextField *extensionAppVersion;
    IBOutlet NSTextField *extensionAppURL;
    IBOutlet NSTextField *extensionAppDomain;
    IBOutlet NSImageView *extensionAppIcon;
    IBOutlet NSTableView *allAppsForExtensionTableView;
    IBOutlet NSPopover *popoverExtension;
    NSArray *allAppsForExtensionArray;
    
    //File compatibility
    IBOutlet NSTextField *resultFieldCheck;
    IBOutlet NSTextField *fileFieldCheck;
    IBOutlet NSTextField *appFieldCheck;
    IBOutlet NSImageView *fileImageViewCheck;
    IBOutlet NSImageView *appImageViewCheck;
    NSURL *filePathCheck;
    NSURL *appPathCheck;
}

-(IBAction)selectFile:(id)sender;
-(IBAction)selectApp:(id)sender;
-(IBAction)checkCompatibility:(id)sender;

-(IBAction)getProtocol:(id)sender;
-(IBAction)changeProtocolApp:(id)sender;
-(IBAction)showAllAppsForProtocol:(id)sender;

-(IBAction)getMIMEType:(id)sender;
-(IBAction)changeMIMETypeApp:(id)sender;
-(IBAction)showAllAppsForMIMEType:(id)sender;

-(IBAction)getExtension:(id)sender;
-(IBAction)changeExtensionApp:(id)sender;
-(IBAction)showAllAppsForExtension:(id)sender;

@property (assign) IBOutlet NSWindow *window;

@end
