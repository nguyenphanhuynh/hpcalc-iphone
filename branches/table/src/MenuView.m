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

- (int) numberOfRowsInTable:(id) table {
	NSArray *buttonList = [[_menuData objectForKey:[self _tagToName:[[_navBar topItem] tag]]] objectForKey:@"menu"];
	return [buttonList count];
}

- (void) tableRowSelected:(NSNotification *) n {
	NSArray *buttonList = [[_menuData objectForKey:[self _tagToName:[[_navBar topItem] tag]]] objectForKey:@"menu"];
	
	if (([[n object] selectedRow] >= 0) && ([[n object] selectedRow] < INT_MAX)) {
		[self processKeypress:[self _nameToTag:[buttonList objectAtIndex:[[n object] selectedRow]]]];
	}
}

- (UITableCell *) table:(UITable *) table cellForRow:(int) row column:(int) col {
	id cell = [[[UIImageAndTextTableCell alloc] init] autorelease];

	NSArray *buttonList = [[_menuData objectForKey:[self _tagToName:[[_navBar topItem] tag]]] objectForKey:@"menu"];
	[cell setTitle:[buttonList objectAtIndex:row]];
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
		} else {
			// Macro
			[NSThread detachNewThreadSelector:@selector(_playMacroThread:) toTarget:self withObject:[NSNumber numberWithInt:code]];
			[_navBar setNavigationItems:nil];
			[_transView transition:2 toView:_view];
			[self setEnabled:NO];
		}
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
		_activeTable = ((_activeTable+1) % 2);
		[_table[_activeTable] selectRow:-1 byExtendingSelection:NO];
		[_table[_activeTable] reloadData];
		[_innerTransView transition:2 toView:_table[_activeTable]];
}

- (void) navigationBar:(UINavigationBar *) bar buttonClicked:(int) button {
	if (button == 0) {
		[_transView transition:2 toView:_view];
		[self setEnabled:NO];
	}
}

- (void) _playMacro:(id)tag {	
	[_calcView playMacro:[[_menuData objectForKey:[self _tagToName:[tag intValue]]] objectForKey:@"macro"]];
}

- (id) initWithFrame:(CGRect) frame {
	self = [super initWithFrame:frame];
	if (self) {
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