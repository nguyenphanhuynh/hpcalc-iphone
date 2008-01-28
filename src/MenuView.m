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
#import "MenuButton.h"

@implementation MenuView

- (int) numberOfRowsInTable:(id) table {
	NSArray *buttonList = [[_menuData objectForKey:[self _tagToName:[[_navBar topItem] tag]]] objectForKey:@"menu"];
	return [buttonList count];
}

- (void) tableRowSelected:(NSNotification *) n {
	NSArray *buttonList = [[_menuData objectForKey:[self _tagToName:[[_navBar topItem] tag]]] objectForKey:@"menu"];
	
	if (([[n object] selectedRow] >= 0) && ([[n object] selectedRow] < INT_MAX)) {
		if ( [[NSUserDefaults standardUserDefaults] boolForKey:@"keyClick"] ) {
			AudioServicesPlaySystemSound(1105);
		}
		[self processKeypress:[self _nameToTag:[buttonList objectAtIndex:[[n object] selectedRow]]]];
	}
}

- (UITableCell *) table:(UITable *) table cellForRow:(int) row column:(int) col {
	id cell = [[[UIImageAndTextTableCell alloc] init] autorelease];

	NSArray *buttonList = [[_menuData objectForKey:[self _tagToName:[[_navBar topItem] tag]]] objectForKey:@"menu"];
	[cell setTitle:[self updatePreferenceButtonName:[buttonList objectAtIndex:row]]];
	if ([self _isMenu:[self _nameToTag:[buttonList objectAtIndex:row]]]) {
		[cell setShowDisclosure:YES];
	}
	
	return cell;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
	// NSLog(@"%@", NSStringFromSelector(aSelector));
	return [super respondsToSelector:aSelector];
}	

- (void) processKeypress: (int) code {
	if (code >= 0) {
		if ([self _isMenu:code]) {
			// Menu
			[NSThread detachNewThreadSelector:@selector(_showMenuThread:) toTarget:self withObject:[NSNumber numberWithInt:code]];
		} else if ([self _isMacro:code]) {
			// Macro
			[NSThread detachNewThreadSelector:@selector(_playMacroThread:) toTarget:self withObject:[NSNumber numberWithInt:code]];
			[_navBar setNavigationItems:nil];
			[_transView transition:2 toView:_view];
			[self setEnabled:NO];
		} else if ([self _isFunction:code]) {
			// Function
			[NSThread detachNewThreadSelector:@selector(_performFunctionThread:) toTarget:self withObject:[NSNumber numberWithInt:code]];
			// [_navBar setNavigationItems:nil];
			// [_transView transition:2 toView:_view];
			// [self setEnabled:NO];
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
	[_table[_activeTable] reloadData];
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
	UINavigationItem *navItem;

	navItem = [[UINavigationItem alloc] initWithTitle:[self _tagToName:[tag intValue]]];
	[navItem setTag:[tag intValue]];

	if ([tag intValue] == 0) {
		[_navBar setNavigationItems:nil];
		[_navBar pushNavigationItem:navItem];
		[_table[_activeTable] selectRow:-1 byExtendingSelection:NO];
		[_table[_activeTable] reloadData];
		[_transView transition:1 toView:_tableView];
	} else {
		_activeTable = ((_activeTable+1) % 2);
		[_navBar pushNavigationItem:navItem];
		[_table[_activeTable] selectRow:-1 byExtendingSelection:NO];
		[_table[_activeTable] reloadData];
		[_innerTransView transition:1 toView:_table[_activeTable]];
	}	
}

- (void) navigationBar:(UINavigationBar *) bar poppedItem:(UINavigationItem *) item {
	if ( [[NSUserDefaults standardUserDefaults] boolForKey:@"keyClick"] ) {
		AudioServicesPlaySystemSound(1105);
	}
	
	_activeTable = ((_activeTable+1) % 2);
	[_table[_activeTable] selectRow:-1 byExtendingSelection:NO];
	[_table[_activeTable] reloadData];
	[_innerTransView transition:2 toView:_table[_activeTable]];
}

- (void) navigationBar:(UINavigationBar *) bar buttonClicked:(int) button {
	if (button == 0) {
		if ( [[NSUserDefaults standardUserDefaults] boolForKey:@"keyClick"] ) {
			AudioServicesPlaySystemSound(1105);
		}
		[_transView transition:2 toView:_view];
		[self setEnabled:NO];
	}
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
	_alert = [[[UIAlertSheet alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] retain];
	[_alert setAlertSheetStyle:2];
	[_alert setDelegate:self];
	[_alert setTitle:@"Update Available"];
	[_alert setBodyText:[NSString stringWithFormat:@"An updated version of %@ is available.\nWould you like to install the update now?", @APPNAME]];
	[_alert addButtonWithTitle:@"Yes"];
	[[[_alert buttons] lastObject] setTag:-3];
	[_alert addButtonWithTitle:@"No"];
	[[[_alert buttons] lastObject] setTag:-2];
	[_alert setNumberOfRows:1];
	
	[_alert presentSheetInView:self];
}

- (void) promptNoUpdate {
	if ( _alert ) {
		[_alert dismiss];
		[_alert release];
		_alert = nil;
	}
	_alert = [[[UIAlertSheet alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] retain];
	[_alert setAlertSheetStyle:2];
	[_alert setDelegate:self];
	[_alert setTitle:@"No Updates Available"];
	[_alert setBodyText:[NSString stringWithFormat:@"You already have the latest version of %@ installed.", @APPNAME]];
	[_alert addButtonWithTitle:@"OK"];
	[[[_alert buttons] lastObject] setTag:-2];

	[_alert presentSheetInView:_transView];
}

- (void) showStartupMessage {
	if ( _alert ) {
		[_alert dismiss];
		[_alert release];
		_alert = nil;
	}
	_alert = [[[UIAlertSheet alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] retain];
	[_alert setAlertSheetStyle:2];
	[_alert setDelegate:self];
	[_alert setTitle:@"New Features"];
	[_alert setBodyText:[NSString stringWithFormat:@"New features have been added.\nTo access them, tap the HP logo in the upper-right corner.", @APPNAME]];
	[_alert addButtonWithTitle:@"OK"];
	[[[_alert buttons] lastObject] setTag:-2];
	[_alert presentSheetInView:_transView];
}

- (void) checkForUpdate {
	[self showProgressSheet];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
	OTUpdateManager *um = [self getUpdateManager];

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
	[self hideProgressSheet];
	_alert = [[[UIAlertSheet alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] retain];
	[_alert setAlertSheetStyle:2];
	[_alert setDelegate:self];
	[_alert setTitle:@"Restart Required"];
	[_alert setBodyText:[NSString stringWithFormat:@"A new version of %@ has been installed.\nClick the Home button to exit back to the springboard and then tap the icon to re-launch the calculator for the changes to take effect.", @APPNAME]];
	[_alert addButtonWithTitle:@"OK"];
	[[[_alert buttons] lastObject] setTag:-2];
	[_alert presentSheetInView:_transView];
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
	self = [super initWithFrame:frame];
	if (self) {
		_menuStack = [[NSMutableArray alloc] init];
		_menuData = [[NSMutableDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"/Applications/%s.app/menu.plist", APPNAME]] retain];

		NSEnumerator *enumerator = [[_menuData copy] keyEnumerator];
		id key;
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
	
		_tableView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 480, 300)] retain];

		_navBar = [[[UINavigationBar alloc] init] retain];
		[_navBar setFrame:CGRectMake(0, 0, 480, 45)];
		[_navBar setDelegate:self];
		[_navBar showButtonsWithLeftTitle:nil rightTitle:@"Exit" leftBack:YES];
		[_tableView addSubview:_navBar];

		_innerTransView = [[[UITransitionView alloc] initWithFrame:CGRectMake(0, 45, 480, 300-45)] retain];
		_activeTable = 0;

		UITableColumn *col = [[UITableColumn alloc] initWithTitle:@"name" identifier:@"name" width:480];
		int i;
		for (i=0; i<2; i++) {
			_table[i] = [[[UITable alloc] initWithFrame:CGRectMake(0, 0, 480, 300-45)] retain];
			[_table[i] addTableColumn:col];
			[_table[i] setDelegate:self];
			[_table[i] setDataSource:self];
			[_table[i] setReusesTableCells:NO];
			[_table[i] setShowScrollerIndicators:YES];
			[_table[i] setSeparatorStyle:1];
			[_table[i] reloadData];
		}
		[_tableView addSubview:_innerTransView];
		[_innerTransView transition:1 toView:_table[_activeTable]];

		frame = CGRectMake(-90, 90, 480, 300);
		_transView = [[[UITransitionView alloc] initWithFrame:frame] retain];
		[_transView setRotationBy:90];

		_view = [[UIView alloc] initWithFrame:frame];
		[_view retain];

		[self addSubview:_transView];
		[_transView transition:1 toView:_view];
	}
	
    _progressBar = [[UIProgressBar alloc] initWithFrame:CGRectMake(60, 34, 360, 20)];
    _progressSheet = [[UIAlertSheet alloc] init];
    [_progressSheet setTitle:@"Please wait..."];
    [_progressSheet setBodyText:@" "];
    [_progressSheet setDelegate:self];
    [_progressSheet setAlertSheetStyle:2];
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
    id messageDate = [NSDate dateWithString:@"2008-01-27 21:57:00 -0600"];
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
        [_progressSheet presentSheetInView:_transView];
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