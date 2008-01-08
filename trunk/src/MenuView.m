/* Copyright (c) 2007, Thomas Fors
 * All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

#import "CalculatorApp.h"
#import "CalculatorView.h"
#import "MenuView.h"
#import "MenuAlert.h"
#import "MenuButton.h"

@implementation MenuView

- (void) processKeypress: (int) code {
	if (code >= 0) {
		if ([self _isMenu:code]) {
			// Menu
			[NSThread detachNewThreadSelector:@selector(_showMenuThread:) toTarget:self withObject:[NSNumber numberWithInt:code]];
		} else if ([self _isMacro:code]) {
			// Macro
			[NSThread detachNewThreadSelector:@selector(_playMacroThread:) toTarget:self withObject:[NSNumber numberWithInt:code]];
			[_menuStack removeAllObjects];
		} else if ([self _isFunction:code]) {
			// Function
			[NSThread detachNewThreadSelector:@selector(_performFunctionThread:) toTarget:self withObject:[NSNumber numberWithInt:code]];
			[_menuStack removeAllObjects];
		}
	} else if (code == -1) {
		// Back button
		[_menuStack removeLastObject];
		id menu = [_menuStack lastObject];
		[_menuStack removeLastObject];
		[NSThread detachNewThreadSelector:@selector(_showMenuThread:) toTarget:self withObject:menu];
	} else if (code == -2) {
		// Cancel/NO/OK button
		[_menuStack removeAllObjects];
	} else if (code == -3) {
		// YES button
		[NSThread detachNewThreadSelector:@selector(_performUpdateThread:) toTarget:self withObject:nil];
		[_menuStack removeAllObjects];
	}
}

- (void) alertSheet:(id) sheet buttonClicked:(int) code
{
	[_alert dismiss];
	[_alert release];
	_alert = nil;
	[self processKeypress:code];
}

- (void) _showMenuThread:(id)tag {
    NSAutoreleasePool* p = [[NSAutoreleasePool alloc] init];
	[self performSelectorOnMainThread:@selector(_showMenu:) withObject:tag waitUntilDone:YES];
	[p release];
}

- (void) _playMacroThread:(id)tag {
    NSAutoreleasePool* p = [[NSAutoreleasePool alloc] init];
	[self _playMacro:tag];
	[p release];
}

- (void) _performFunctionThread:(id)tag {
    NSAutoreleasePool* p = [[NSAutoreleasePool alloc] init];
	[self performSelectorOnMainThread:@selector(_performFunction:) withObject:tag waitUntilDone:YES];
	[p release];
}

- (void) _performUpdateThread:(id)tag {
    NSAutoreleasePool* p = [[NSAutoreleasePool alloc] init];
	[self performSelectorOnMainThread:@selector(showProgressSheet) withObject:nil waitUntilDone:NO];
	OTUpdateManager *um = [self getUpdateManager];
	[um performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:YES];
	[self performSelectorOnMainThread:@selector(promptForRestart) withObject:nil waitUntilDone:NO];
	[p release];
}

- (void) _autoUpdateCheckThread:(id)tag {
    NSAutoreleasePool* p = [[NSAutoreleasePool alloc] init];
	[NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:2.0]];
	[self checkForUpdateKeepHidden];
	[p release];
}

- (void) _showStartupMessageThread:(id)tag {
    NSAutoreleasePool* p = [[NSAutoreleasePool alloc] init];
	[NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
	[self performSelectorOnMainThread:@selector(showStartupMessage) withObject:nil waitUntilDone:NO];
	[p release];
}

- (void) _showMenu:(id)tag {	
	NSMutableArray *buttons = [[[NSMutableArray alloc] init] retain];
	
	NSArray *buttonList = [[_menuData objectForKey:[self _tagToName:[tag intValue]]] objectForKey:@"menu"];
	NSEnumerator *enumerator = [buttonList objectEnumerator];
	id buttonName;
	while (buttonName = [self updatePreferenceButtonName:[enumerator nextObject]]) {
		[buttons addObject:[self _buttonWithName:buttonName]];
	}
	
	_alert = [[[MenuAlert alloc] initWithFrame:CGRectMake(0, 0, 320, 480) buttons:buttons title:[self _tagToName:[tag intValue]] delegate:self] retain];
	[_menuStack addObject:[tag retain]];
	[_alert presentSheetInView:self];
	[buttons release];
}

- (void) _playMacro:(id)tag {	
	[_calcView playMacro:[[_menuData objectForKey:[self _tagToName:[tag intValue]]] objectForKey:@"macro"]];
}

- (void) _performFunction:(id)tag {	
	id fn = [self _tagToName:[tag intValue]];
	
	if ( [fn hasPrefix:@"Turn keyclick "] ) {
        [[NSUserDefaults standardUserDefaults] setBool: ([[NSUserDefaults standardUserDefaults] boolForKey:@"keyClick"] ? NO : YES)
												forKey: @"keyClick"
		];
		[[NSUserDefaults standardUserDefaults] synchronize];
	} else if ([fn hasPrefix:@"Turn auto check for updates "]) {
        [[NSUserDefaults standardUserDefaults] setBool: ([[NSUserDefaults standardUserDefaults] boolForKey:@"autoUpdates"] ? NO : YES)
												forKey: @"autoUpdates"
		];
		[[NSUserDefaults standardUserDefaults] synchronize];
	} else if ( [fn isEqualToString:@"About"] ) {
		[UIApp openURL:[NSURL URLWithString:@ABOUTURL]];
	} else if ( [fn isEqualToString:@"Check for updates now"] ) {
		[self checkForUpdate];
	}
}

- (void) checkForUpdateKeepHidden {
	OTUpdateManager *um = [self getUpdateManager];
	if ( [um refreshIsNeeded] ) {
		[um checkForUpdates];
		bool updateAvailable = [um updateIsAvailable];
		[self hideProgressSheet];
		if ( updateAvailable ) {
			[self performSelectorOnMainThread:@selector(promptForUpdate) withObject:nil waitUntilDone:NO];
		}
	}
}

- (void) promptForUpdate {
	if ( _alert ) {
		[_alert dismiss];
		[_alert release];
		_alert = nil;
	}
	_alert = [[[MenuAlert alloc] initYesNoWithFrame:CGRectMake(0, 0, 320, 480) title:@"Update Available" delegate:self] retain];
	[_alert setBodyText:[NSString stringWithFormat:@"An updated version of %@ is available.\nWould you like to install the update now?", @APPNAME]];
	[_alert presentSheetInView:self];
}

- (void) promptNoUpdate {
	if ( _alert ) {
		[_alert dismiss];
		[_alert release];
		_alert = nil;
	}
	_alert = [[[MenuAlert alloc] initOkWithFrame:CGRectMake(0, 0, 320, 480) title:@"No Updates Available" delegate:self] retain];
	[_alert setBodyText:[NSString stringWithFormat:@"You already have the latest version of %@ installed.", @APPNAME]];
	[_alert presentSheetInView:self];
}

- (void) showStartupMessage {
	if ( _alert ) {
		[_alert dismiss];
		[_alert release];
		_alert = nil;
	}
	_alert = [[[MenuAlert alloc] initOkWithFrame:CGRectMake(0, 0, 320, 480) title:@"New Features" delegate:self] retain];
	[_alert setBodyText:[NSString stringWithFormat:@"New features have been added.\nTo access them, tap the HP logo in the upper-right corner.\n\nClick OK to continue.", @APPNAME]];
	[_alert presentSheetInView:self];
}

- (void) checkForUpdate {
	OTUpdateManager *um = [self getUpdateManager];
	[self showProgressSheet];

	[um checkForUpdates];
	bool updateAvailable = [um updateIsAvailable];
	[self hideProgressSheet];
	if ( updateAvailable ) {
		[self performSelectorOnMainThread:@selector(promptForUpdate) withObject:nil waitUntilDone:NO];
	} else {
		[self performSelectorOnMainThread:@selector(promptNoUpdate) withObject:nil waitUntilDone:NO];
	}
}

- (void) promptForRestart {
	if ( _alert ) {
		[_alert dismiss];
		[_alert release];
		_alert = nil;
	}
	_alert = [[[MenuAlert alloc] initOkWithFrame:CGRectMake(0, 0, 320, 480) title:@"Restart Required" delegate:self] retain];
	[_alert setBodyText:[NSString stringWithFormat:@"A new version of %@ has been installed.\nClick the Home button to exit back to the springboard and then tap the icon to re-launch the calculator for the changes to take effect.", @APPNAME]];
	[_alert presentSheetInView:self];
}

- (id) getUpdateManager {
	OTUpdateManager *um = [[OTUpdateManager alloc] initWithPrefFolder: @CFGPATH
	                                                    trustedSource: [NSDictionary dictionaryWithObjectsAndKeys:
							      							  				@"HP Calculators for iPhone",			  @"name",
                                                                            @"http://hpcalc-iphone.googlecode.com/svn/repo/packages.xml",	@"location",
															                @"Thomas Fors",							  @"maintainer",
															                @"tom@fors.net",						  @"contact",
															                @"HPCALC",								  @"category",
															                NULL]
										                  thisPackage: [NSDictionary dictionaryWithObjectsAndKeys:
															                @APPNAME,								  @"name",
															                @"Utilities",							  @"category",
															                @"HP Calculator Emulator",				  @"description",
                                                                            @"http://hpcalc-iphone.googlecode.com/svn/repo/packages.xml",	@"source",
															                @"Thomas Fors",							  @"maintainer",
															                @"tom@fors.net",						  @"contact",
															                NULL]
                          ];
    [um setDelegate:self];
	return um;
}

- (id) updatePreferenceButtonName:(id) name {
	if ([name isEqualToString:@"Turn keyclick %@"]) {
		return [NSString stringWithFormat:name, ([[NSUserDefaults standardUserDefaults] boolForKey:@"keyClick"] ? @"off" : @"on")];
	} else if ([name isEqualToString:@"Turn auto check for updates %@"]) {
		return [NSString stringWithFormat:name, ([[NSUserDefaults standardUserDefaults] boolForKey:@"autoUpdates"] ? @"off" : @"on")];
	}
	return name;
}

- (id) initWithFrame:(CGRect) frame {
	int i;
	frame = CGRectMake(-90, 90, 480, 300);
	self = [super initWithFrame:frame];
	[self setRotationBy:90];

	_menuStack = [[NSMutableArray alloc] init];
	_menuData = [[NSMutableDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"/Applications/%s.app/menu.plist", APPNAME]] retain];
	NSEnumerator *enumerator = [[_menuData copy] keyEnumerator];
	NSString * key;
	while (key = [enumerator nextObject]) {
		if ([key hasSuffix:@"%@"]) {
			id newkey = [NSString stringWithFormat:key, @"on"];
			id obj = [[_menuData objectForKey:key] mutableCopy];
			[_menuData setObject:obj forKey:newkey];
			newkey = [NSString stringWithFormat:key, @"off"];
			obj = [[_menuData objectForKey:key] mutableCopy];
			[_menuData setObject:obj forKey:newkey];
		}
	}

	_tagList = [[NSMutableArray alloc] init];
	[_tagList addObject:@"Main Menu"];
	enumerator = [_menuData keyEnumerator];
	while (key = [enumerator nextObject]) {
		if (! [_tagList containsObject:key] ) {
			[_tagList addObject:key];
		}
	}
	
    _progressBar = [[UIProgressBar alloc] initWithFrame:CGRectMake(60, 34, 360, 20)];
    _progressSheet = [[MenuAlert alloc] init];
    [_progressSheet setTitle:@"Please wait..."];
    [_progressSheet setBodyText:@" "];
    [_progressSheet setDelegate:self];
    // [_progressSheet setAlertSheetStyle:2];
    [_progressSheet addSubview:_progressBar];
    _progressSheetVisible = NO;

	if ( [self _startupMessageIsNeeded] ) {
		[NSThread detachNewThreadSelector:@selector(_showStartupMessageThread:) toTarget:self withObject:nil];
	    [[NSUserDefaults standardUserDefaults] setObject: [NSDate date] forKey: @"startupMessageLastShown"];
	} else {
		if ( [[NSUserDefaults standardUserDefaults] boolForKey:@"autoUpdates"] ) {
			[NSThread detachNewThreadSelector:@selector(_autoUpdateCheckThread:) toTarget:self withObject:nil];
		}
	}

	return self;
}

- (bool) _startupMessageIsNeeded {
    id lastShown = [[NSUserDefaults standardUserDefaults] objectForKey:@"startupMessageLastShown"];
    id messageDate = [NSDate dateWithString:@"2008-01-07 17:12:00 -0600"];
    id now = [NSDate date];

    if (lastShown == nil) {
        return YES;
    }

    if ( [lastShown laterDate:messageDate] == messageDate ) {
        return YES;
    }

    return NO;
}

- (int) _nameToTag:(NSString *) name {
	return [_tagList indexOfObject:name];
}

- (NSString *) _tagToName:(int) tag {
	return [_tagList objectAtIndex:tag];
}

- (MenuButton *) _buttonWithTag:(int) tag {
	return [self _buttonWithName:[self _tagToName:tag]];
}

- (MenuButton *) _buttonWithName:(NSString *) name {
	MenuButton *mb = [[_menuData objectForKey:name] objectForKey:@"button"];
	if (!mb) {
		mb = [[MenuButton alloc] initWithTitle:name];
		[mb setTag:[self _nameToTag:name]];
		[[_menuData objectForKey:name] setObject:mb forKey:@"button"];
	}
	return mb;
}

- (bool) _isMenu:(int) tag {
	return ([[_menuData objectForKey:[self _tagToName:tag]] objectForKey:@"menu"] != nil);
}

- (bool) _isMacro:(int) tag {
	return ([[_menuData objectForKey:[self _tagToName:tag]] objectForKey:@"macro"] != nil);
}

- (bool) _isFunction:(int) tag {
	return ([[_menuData objectForKey:[self _tagToName:tag]] objectForKey:@"function"] != nil);
}

- (void) setCalcView:(CalculatorView *) v {
	_calcView = v;
}
     
- (void) showProgressSheet {
    if ( ! _progressSheetVisible ) {
        _progressSheetVisible = YES;
        [_progressBar setProgress:0.0];
        [_progressSheet presentSheetInView:self];
        [_progressSheet setBlocksInteraction:YES];
    }
}

- (void) hideProgressSheet {
    if ( _progressSheetVisible ) {
		_progressSheetVisible = NO;
        [_progressSheet dismissAnimated:YES];
        [_progressSheet setBlocksInteraction:NO];
    }
}

- (void) updateManager:(id) pm statusChanged:(id) status {
    // [_progressSheet setTitle:status];
	[_progressSheet performSelectorOnMainThread:@selector(setTitle:) withObject:status waitUntilDone:NO];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
}

- (void) updateManager:(id) pm progressChanged:(id) progress {
    [_progressBar setProgress:([progress doubleValue] / 100.0)];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
}

- (void) updateManager:(id) pm startedQueue:(id) q {
}

- (void) updateManager:(id) pm finishedQueueWithResult:(id) result {
    [self hideProgressSheet];
}

@end