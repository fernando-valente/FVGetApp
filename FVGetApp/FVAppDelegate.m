//
//  FVAppDelegate.m
//  FVGetApp
//
//  Created by Fernando Valente on 9/29/13.
//  Copyright (c) 2013 Fernando Valente. All rights reserved.
//

#import "FVAppDelegate.h"

@implementation FVAppDelegate

-(void)awakeFromNib{
    [protocolField setStringValue:@"HTTP"];
    [self getProtocol:nil];
    [protocolField setStringValue:@""];
    
    [MIMETypeField setStringValue:@"IMAGE/PNG"];
    [self getMIMEType:nil];
    [MIMETypeField setStringValue:@""];
    
    [extensionField setStringValue:@"mp3"];
    [self getExtension:nil];
    [extensionField setStringValue:@""];
}

#pragma Protocols

-(IBAction)getProtocol:(id)sender{
    NSString *protocol = [protocolField stringValue];
    
    if(![NSURL URLWithString:protocol] || [protocol rangeOfString:@":"].length > 0 || [protocol rangeOfString:@"."].length > 0 || [protocol rangeOfString:@"/"].length > 0 || protocol.length == 0){
        NSBeep();
        NSRunAlertPanel(@"Error", @"Please enter a valid protocol name without ':'.", @"OK", nil, nil);
        return;
    }
    
    NSDictionary *dict = [FVGetApp appForProtocol:protocol];
    
    if(!dict){
        NSRunAlertPanel(@"Error", [NSString stringWithFormat:@"There's no application associated with the protocol %@", protocol], @"OK", nil, nil);
        return;
    }
    
    [protocolNameField setStringValue:protocol];
    
    if([dict objectForKey:@"CFBundleGetInfoString"])
        [protocolAppCopyright setStringValue:[dict objectForKey:@"CFBundleGetInfoString"]];
    else
        [protocolAppCopyright setStringValue:@""];
    
    if([dict objectForKey:@"CFBundleDisplayName"])
        [protocolAppName setStringValue:[dict objectForKey:@"CFBundleDisplayName"]];
    else{
        NSString *URL = [[dict objectForKey:FVGetAppURLProperty] path];
        NSString *bundleName = [URL lastPathComponent];
        [protocolAppName setStringValue:bundleName];
    }
    
    [protocolAppVersion setStringValue:[dict objectForKey:@"CFBundleVersion"]];
    [protocolAppDomain setStringValue:[dict objectForKey:@"CFBundleIdentifier"]];
    
    [protocolAppIcon setImage:[dict objectForKey:FVGetAppIconProperty]];
    [protocolAppURL setStringValue:[dict objectForKey:FVGetAppURLProperty]];
    
    allAppsForProtocolArray = [FVGetApp allAppsForProtocol:protocol];
    [allAppsForProtocolTableView reloadData];
}

-(IBAction)changeProtocolApp:(id)sender{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setAllowedFileTypes:[NSArray arrayWithObject:@"app"]];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel runModal];
    
    if(![openPanel URL])
        return;
    
    NSString *protocol = [protocolNameField stringValue];
    
    [FVGetApp setApplication:[openPanel URL] forProtocol:protocol];
    
    NSString *currentlyOnProtocolField = [protocolField stringValue];
    [protocolField setStringValue:[protocolNameField stringValue]];
    [self getProtocol:nil];
    [protocolField setStringValue:currentlyOnProtocolField];
}

-(IBAction)showAllAppsForProtocol:(id)sender{
    CGRect frame = [sender frame];
    frame.origin.y -= 13;
    
    [popoverProtocol showRelativeToRect:frame ofView:sender preferredEdge:NSMinYEdge];
}

#pragma MIMEType

-(IBAction)getMIMEType:(id)sender{
    NSString *MIMEType = [MIMETypeField stringValue];
    
    if(MIMEType.length == 0){
        NSBeep();
        return;
    }
    
    NSDictionary *dict = [FVGetApp appForMIMEType:MIMEType];
    
    if(!dict){
        NSRunAlertPanel(@"Error", [NSString stringWithFormat:@"There's no application associated with the MIME type %@", MIMEType], @"OK", nil, nil);
        return;
    }
    
    [MIMETypeNameField setStringValue:MIMEType];
    
    if([dict objectForKey:@"CFBundleGetInfoString"])
        [MIMETypeAppCopyright setStringValue:[dict objectForKey:@"CFBundleGetInfoString"]];
    else
        [MIMETypeAppCopyright setStringValue:@""];
    
    if([dict objectForKey:@"CFBundleDisplayName"])
        [MIMETypeAppName setStringValue:[dict objectForKey:@"CFBundleDisplayName"]];
    else{
        NSString *URL = [[dict objectForKey:FVGetAppURLProperty] path];
        NSString *bundleName = [URL lastPathComponent];
        [MIMETypeAppName setStringValue:bundleName];
    }
    
    [MIMETypeAppVersion setStringValue:[dict objectForKey:@"CFBundleVersion"]];
    [MIMETypeAppDomain setStringValue:[dict objectForKey:@"CFBundleIdentifier"]];
    
    [MIMETypeAppIcon setImage:[dict objectForKey:FVGetAppIconProperty]];
    [MIMETypeAppURL setStringValue:[dict objectForKey:FVGetAppURLProperty]];
    
    allAppsForMIMETypeArray = [FVGetApp allAppsForMIMEType:MIMEType];
    [allAppsForMIMETypeTableView reloadData];
}

-(IBAction)changeMIMETypeApp:(id)sender{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setAllowedFileTypes:[NSArray arrayWithObject:@"app"]];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel runModal];
    
    if(![openPanel URL])
        return;
    
    NSString *MIMEType = [MIMETypeNameField stringValue];
    
    NSBundle *bundle = [NSBundle bundleWithURL:[openPanel URL]];
    
    [FVGetApp setApplication:[bundle bundleIdentifier] forMIMEType:MIMEType];
    
    NSString *currentlyOnMIMETypeField = [MIMETypeNameField stringValue];
    [MIMETypeField setStringValue:[MIMETypeNameField stringValue]];
    [self getMIMEType:nil];
    [MIMETypeField setStringValue:currentlyOnMIMETypeField];
}

-(IBAction)showAllAppsForMIMEType:(id)sender{
    CGRect frame = [sender frame];
    frame.origin.y -= 13;
    
    [popoverMIMEType showRelativeToRect:frame ofView:sender preferredEdge:NSMinYEdge];
}

#pragma Extensions

-(IBAction)getExtension:(id)sender{
    NSString *extension = [extensionField stringValue];
    
    if([extension rangeOfString:@"."].length > 0|| extension.length == 0){
        NSBeep();
        NSRunAlertPanel(@"Error", @"Please enter a valid extension without '.'.", @"OK", nil, nil);
        return;
    }
    
    NSDictionary *dict = [FVGetApp appForExtension:extension];
    
    if(!dict){
        NSRunAlertPanel(@"Error", [NSString stringWithFormat:@"There's no application associated with the extension %@", extension], @"OK", nil, nil);
        return;
    }
    
    [extensionNameField setStringValue:extension];
    
    if([dict objectForKey:@"CFBundleGetInfoString"])
        [extensionAppCopyright setStringValue:[dict objectForKey:@"CFBundleGetInfoString"]];
    else
        [extensionAppCopyright setStringValue:@""];
    
    if([dict objectForKey:@"CFBundleDisplayName"])
        [extensionAppName setStringValue:[dict objectForKey:@"CFBundleDisplayName"]];
    else{
        NSString *URL = [[dict objectForKey:FVGetAppURLProperty] path];
        NSString *bundleName = [URL lastPathComponent];
        [extensionAppName setStringValue:bundleName];
    }
    
    [extensionAppVersion setStringValue:[dict objectForKey:@"CFBundleVersion"]];
    [extensionAppDomain setStringValue:[dict objectForKey:@"CFBundleIdentifier"]];
    
    [extensionAppIcon setImage:[dict objectForKey:FVGetAppIconProperty]];
    [extensionAppURL setStringValue:[dict objectForKey:FVGetAppURLProperty]];

    allAppsForExtensionArray = [FVGetApp allAppsForExtension:extension];
    [allAppsForExtensionTableView reloadData];
}

-(IBAction)showAllAppsForExtension:(id)sender{
    CGRect frame = [sender frame];
    frame.origin.y -= 13;
    
    [popoverExtension showRelativeToRect:frame ofView:sender preferredEdge:NSMinYEdge];
}

-(IBAction)changeExtensionApp:(id)sender{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setAllowedFileTypes:[NSArray arrayWithObject:@"app"]];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel runModal];
    
    if(![openPanel URL])
        return;
    
    NSString *extension = [extensionNameField stringValue];
    
    NSBundle *bundle = [NSBundle bundleWithURL:[openPanel URL]];
    
    [FVGetApp setApplication:[bundle bundleIdentifier] forExtension:extension];
    
    NSString *currentlyOnExtensionField = [extensionField stringValue];
    [extensionField setStringValue:[extensionNameField stringValue]];
    [self getExtension:nil];
    [extensionField setStringValue:currentlyOnExtensionField];
}

#pragma CompatibilityCheck

-(IBAction)selectFile:(id)sender{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseDirectories:NO];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel runModal];
    
    if(![openPanel URL])
        return;
    
    [resultFieldCheck setStringValue:@""];
    
    filePathCheck = [openPanel URL];
    NSString *str = [[openPanel URL] path];
    [fileFieldCheck setStringValue:[str lastPathComponent]];
    
    NSImage *icon = [[NSWorkspace sharedWorkspace] iconForFile:str];
    [icon setSize:NSMakeSize(512, 512)];
    
    [fileImageViewCheck setImage:icon];
}

-(IBAction)selectApp:(id)sender{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setAllowedFileTypes:[NSArray arrayWithObject:@"app"]];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel setDirectoryURL:[NSURL URLWithString:@"file:///Applications"]];
    [openPanel runModal];
    
    if(![openPanel URL])
        return;
    
    [resultFieldCheck setStringValue:@""];
    
    appPathCheck = [openPanel URL];
    NSString *str = [[openPanel URL] path];
    [appFieldCheck setStringValue:[str lastPathComponent]];
    
    NSImage *icon = [[NSWorkspace sharedWorkspace] iconForFile:str];
    [icon setSize:NSMakeSize(512, 512)];
    
    [appImageViewCheck setImage:icon];
}

-(IBAction)checkCompatibility:(id)sender{
    if(!filePathCheck){
        NSRunAlertPanel(@"Error", @"Please select a file", @"OK", nil, nil);
        NSBeep();
        return;
    }
    
    if(!appPathCheck){
        NSRunAlertPanel(@"Error", @"Please select an app", @"OK", nil, nil);
        NSBeep();
        return;
    }
    
    BOOL canOpen = [FVGetApp isAppCompatible:appPathCheck withFile:filePathCheck];
    
    if(canOpen){
        [resultFieldCheck setTextColor:[NSColor greenColor]];
        [resultFieldCheck setStringValue:@"YES"];
    }
    else{
        [resultFieldCheck setTextColor:[NSColor redColor]];
        [resultFieldCheck setStringValue:@"NO"];
    }
}

#pragma TableViewDatasource

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    if(tableView == allAppsForProtocolTableView){
        return [allAppsForProtocolArray count];
    }
    else if(tableView == allAppsForMIMETypeTableView){
        return [allAppsForMIMETypeArray count];
    }
    return [allAppsForExtensionArray count];
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex{
    if([[aTableColumn dataCell] isKindOfClass:[NSImageCell class]]){
        if(tableView == allAppsForProtocolTableView){
            NSDictionary *dict = [allAppsForProtocolArray objectAtIndex:rowIndex];
            return [dict objectForKey:FVGetAppIconProperty];
        }
        else if(tableView == allAppsForMIMETypeTableView){
            NSDictionary *dict = [allAppsForMIMETypeArray objectAtIndex:rowIndex];
            return [dict objectForKey:FVGetAppIconProperty];
        }
        
        NSDictionary *dict = [allAppsForExtensionArray objectAtIndex:rowIndex];
        return [dict objectForKey:FVGetAppIconProperty];
    }

    if(tableView == allAppsForProtocolTableView){
        NSDictionary *dict = [allAppsForProtocolArray objectAtIndex:rowIndex];
        
        if([dict objectForKey:@"CFBundleDisplayName"])
            return [dict objectForKey:@"CFBundleDisplayName"];
        
        NSString *URL = [[dict objectForKey:FVGetAppURLProperty] path];
        NSString *bundleName = [URL lastPathComponent];
        return bundleName;
    }
    else if(tableView == allAppsForMIMETypeTableView){
        NSDictionary *dict = [allAppsForMIMETypeArray objectAtIndex:rowIndex];
        
        if([dict objectForKey:@"CFBundleDisplayName"])
            return [dict objectForKey:@"CFBundleDisplayName"];
        
        NSString *URL = [[dict objectForKey:FVGetAppURLProperty] path];
        NSString *bundleName = [URL lastPathComponent];
        return bundleName;
    }
    
    NSDictionary *dict = [allAppsForExtensionArray objectAtIndex:rowIndex];
    
    if([dict objectForKey:@"CFBundleDisplayName"])
        return [dict objectForKey:@"CFBundleDisplayName"];
    
    NSString *URL = [[dict objectForKey:FVGetAppURLProperty] path];
    NSString *bundleName = [URL lastPathComponent];
    return bundleName;
}


@end
