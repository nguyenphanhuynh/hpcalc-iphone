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
		} else {
			// Macro
			[NSThread detachNewThreadSelector:@selector(_playMacroThread:) toTarget:self withObject:[NSNumber numberWithInt:code]];
			[_menuStack removeAllObjects];
		}
	} else if (code == -1) {
		// Back button
		[_menuStack removeLastObject];
		id menu = [_menuStack lastObject];
		[_menuStack removeLastObject];
		[NSThread detachNewThreadSelector:@selector(_showMenuThread:) toTarget:self withObject:menu];
	} else {
		// Cancel button
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


- (void) _showMenu:(id)tag {	
	NSMutableArray *buttons = [[NSMutableArray alloc] init];
	
	NSArray *buttonList = [[_menuData objectForKey:[self _tagToName:[tag intValue]]] objectForKey:@"menu"];
	NSEnumerator *enumerator = [buttonList objectEnumerator];
	id buttonName;
	while (buttonName = [enumerator nextObject]) {
		[buttons addObject:[self _buttonWithName:buttonName]];
	}
	
	_alert = [[[MenuAlert alloc] initWithFrame:CGRectMake(0, 0, 320, 480) buttons:buttons title:[self _tagToName:[tag intValue]] delegate:self] retain];
	[_menuStack addObject:[tag retain]];
	[_alert presentSheetInView:self];
}

- (void) _playMacro:(id)tag {	
	[_calcView playMacro:[[_menuData objectForKey:[self _tagToName:[tag intValue]]] objectForKey:@"macro"]];
}

- (id) initWithFrame:(CGRect) frame {
	int i;
	frame = CGRectMake(-90, 90, 480, 300);
	self = [super initWithFrame:frame];
	[self setRotationBy:90];

	_menuStack = [[NSMutableArray alloc] init];
	_menuData = [[NSMutableDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"/Applications/%s.app/menu.plist", APPNAME]] retain];

	_tagList = [[NSMutableArray alloc] init];
	[_tagList addObject:@"Main Menu"];
	NSEnumerator *enumerator = [_menuData keyEnumerator];
	id key;
	while (key = [enumerator nextObject]) {
		if (! [_tagList containsObject:key] ) {
			[_tagList addObject:key];
		}
	}

	return self;
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
	return ([[_menuData objectForKey:[self _tagToName:tag]] objectForKey:@"menu"] != nil);
}

- (void) setCalcView:(CalculatorView *) v {
	_calcView = v;
}

@end