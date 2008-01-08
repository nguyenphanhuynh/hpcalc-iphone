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
#import "MenuAlert.h"
#import "MenuButton.h"

static UIImage				* maImage = nil;
static CDAnonymousStruct11	  maSlices;
static MenuButton			* maBackButton = nil;
static MenuButton			* maTitleButton = nil;
static MenuButton			* maReturnButton = nil;
static MenuButton			* maYesButton = nil;
static MenuButton			* maNoButton = nil;
static MenuButton			* maOkButton = nil;

@implementation MenuAlert

// - (BOOL)respondsToSelector:(SEL)aSelector {
// 	NSLog(@"%@", NSStringFromSelector(aSelector));
// 	return [super respondsToSelector:aSelector];
// }	

- (void) drawRect:(struct CGRect) rect {
	[maImage draw9PartImageWithSliceRects:maSlices inRect:rect];
}

- (void) _setupTitleStyle {
	if ( _progress ) {
		[self setAlertSheetStyle:2];
		[super _setupTitleStyle];
		[self setAlertSheetStyle:4];
	} else {
		[super _setupTitleStyle];
	}
}

- (id)init {
	self = [super init];
	
	CGRect tl, tc, tr;
	CGRect ml, mc, mr;
	CGRect bl, bc, br;
	CGSize size;
	int cornerWidth, topHeight, botHeight;
	
	[self setAlertSheetStyle:4];
	_progress = YES;
	
	if (!maImage) {
		maImage = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/Applications/%s.app/alertbg.png", APPNAME]];
		size = [maImage size];
		cornerWidth = 24;
		topHeight = 50;
		botHeight = 24;
		tl = CGRectMake(0, 0, cornerWidth, topHeight);
		tc = CGRectMake(cornerWidth, 0, size.width-2*cornerWidth, topHeight);
		tr = CGRectMake(size.width-cornerWidth, 0, cornerWidth, topHeight);
		ml = CGRectMake(0, topHeight, cornerWidth, size.height-topHeight-botHeight);
		mc = CGRectMake(cornerWidth, topHeight, size.width-2*cornerWidth, size.height-topHeight-botHeight);
		mr = CGRectMake(size.width-cornerWidth, topHeight, cornerWidth, size.height-topHeight-botHeight);
		bl = CGRectMake(0, size.height-botHeight, cornerWidth, botHeight);
		bc = CGRectMake(cornerWidth, size.height-botHeight, size.width-2*cornerWidth, botHeight);
		br = CGRectMake(size.width-cornerWidth, size.height-botHeight, cornerWidth, botHeight);
		maSlices = (CDAnonymousStruct11) {tl, tc, tr, ml, mc, mr, bl, bc, br};
	}
	
	return self;
}

- (id)initWithFrame:(struct CGRect)frame buttons:(id)buttons title:(NSString *)title delegate:(id)delegate {
	self = [super initWithFrame:frame];
	
	CGRect tl, tc, tr;
	CGRect ml, mc, mr;
	CGRect bl, bc, br;
	CGSize size;
	int cornerWidth, topHeight, botHeight;
	
	[self setAlertSheetStyle:4];
	_progress = NO;
	
	if (!maImage) {
		maImage = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/Applications/%s.app/alertbg.png", APPNAME]];
		size = [maImage size];
		cornerWidth = 24;
		topHeight = 50;
		botHeight = 24;
		tl = CGRectMake(0, 0, cornerWidth, topHeight);
		tc = CGRectMake(cornerWidth, 0, size.width-2*cornerWidth, topHeight);
		tr = CGRectMake(size.width-cornerWidth, 0, cornerWidth, topHeight);
		ml = CGRectMake(0, topHeight, cornerWidth, size.height-topHeight-botHeight);
		mc = CGRectMake(cornerWidth, topHeight, size.width-2*cornerWidth, size.height-topHeight-botHeight);
		mr = CGRectMake(size.width-cornerWidth, topHeight, cornerWidth, size.height-topHeight-botHeight);
		bl = CGRectMake(0, size.height-botHeight, cornerWidth, botHeight);
		bc = CGRectMake(cornerWidth, size.height-botHeight, size.width-2*cornerWidth, botHeight);
		br = CGRectMake(size.width-cornerWidth, size.height-botHeight, cornerWidth, botHeight);
		maSlices = (CDAnonymousStruct11) {tl, tc, tr, ml, mc, mr, bl, bc, br};
	}
	
	if (!maBackButton) {
		maBackButton = [[MenuButton alloc] initWithTitle:@"Back"];
		[maBackButton setTag:-1];
		[maBackButton setDefault:YES];
	}
	[maBackButton setHidden:[title isEqualToString:@"Main Menu"]];

	if (!maTitleButton) {
		maTitleButton = [[MenuButton alloc] initWithTitle:@"Main Menu"];
		[maTitleButton setTitleLabel:YES];
	}
	
	if (!maReturnButton) {
		maReturnButton = [[MenuButton alloc] initWithTitle:@"Cancel"];
		[maReturnButton setTag:-2];
		[maReturnButton setDefault:YES];
	}
	
	[maTitleButton setTitle:title];

	// Add user buttons
	if (!_buttons) {
		_buttons = [[NSMutableArray alloc] init];
	}
	[_buttons removeAllObjects];
	[_buttons addObjectsFromArray:buttons];
	NSEnumerator *enumerator = [_buttons objectEnumerator];
	id b;
	while (b = [enumerator nextObject]) {
		[self addSubview:b];
		[b addTarget:self action:@selector(_buttonClicked:) forEvents:0x40];
	}
	
	// Empty buttons for spacing
	while ([_buttons count] % 3) {
		[_buttons addObject:[[MenuButton alloc] initWithTitle:@""]];
		[[_buttons lastObject] setHidden:YES];
		[self addSubview:[_buttons lastObject]];
	}
	
	// Standard buttons
	[_buttons addObject:maBackButton];	
	[self addSubview:maBackButton];
	[maBackButton addTarget:self action:@selector(_buttonClicked:) forEvents:0x40];
	[_buttons addObject:maTitleButton];	
	[self addSubview:maTitleButton];
	[maTitleButton addTarget:self action:@selector(_buttonClicked:) forEvents:0x40];
	[_buttons addObject:maReturnButton];	
	[self addSubview:maReturnButton];
	[maReturnButton addTarget:self action:@selector(_buttonClicked:) forEvents:0x40];
	
	// Additional properties
	[self setDelegate:delegate];
	[self setContext:delegate];
	[self setNumberOfRows:[_buttons count]/3];
	[self setRunsModal:YES];
	[self setShowsOverSpringBoardAlerts:NO];
	[self setTableShouldShowMinimumContent:NO];
	
	return self;
}

- (id)initYesNoWithFrame:(struct CGRect)frame title:(NSString *)title delegate:(id)delegate {
	self = [super initWithFrame:frame];
	
	CGRect tl, tc, tr;
	CGRect ml, mc, mr;
	CGRect bl, bc, br;
	CGSize size;
	int cornerWidth, topHeight, botHeight;
	
	[self setAlertSheetStyle:4];
	_progress = NO;
	
	if (!maImage) {
		maImage = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/Applications/%s.app/alertbg.png", APPNAME]];
		size = [maImage size];
		cornerWidth = 24;
		topHeight = 50;
		botHeight = 24;
		tl = CGRectMake(0, 0, cornerWidth, topHeight);
		tc = CGRectMake(cornerWidth, 0, size.width-2*cornerWidth, topHeight);
		tr = CGRectMake(size.width-cornerWidth, 0, cornerWidth, topHeight);
		ml = CGRectMake(0, topHeight, cornerWidth, size.height-topHeight-botHeight);
		mc = CGRectMake(cornerWidth, topHeight, size.width-2*cornerWidth, size.height-topHeight-botHeight);
		mr = CGRectMake(size.width-cornerWidth, topHeight, cornerWidth, size.height-topHeight-botHeight);
		bl = CGRectMake(0, size.height-botHeight, cornerWidth, botHeight);
		bc = CGRectMake(cornerWidth, size.height-botHeight, size.width-2*cornerWidth, botHeight);
		br = CGRectMake(size.width-cornerWidth, size.height-botHeight, cornerWidth, botHeight);
		maSlices = (CDAnonymousStruct11) {tl, tc, tr, ml, mc, mr, bl, bc, br};
	}

	if (!_buttons) {
		_buttons = [[NSMutableArray alloc] init];
	}
	[_buttons removeAllObjects];

	// Empty buttons for spacing
	while ([_buttons count] % 3) {
		[_buttons addObject:[[MenuButton alloc] initWithTitle:@""]];
		[[_buttons lastObject] setHidden:YES];
		[self addSubview:[_buttons lastObject]];
	}
	
	if (!maNoButton) {
		maNoButton = [[MenuButton alloc] initWithTitle:@"NO"];
		[maNoButton setTag:-2];
	}

	if (!maTitleButton) {
		maTitleButton = [[MenuButton alloc] initWithTitle:@""];
		[maTitleButton setTitleLabel:YES];
	}
	[maTitleButton setTitle:@""];

	if (!maYesButton) {
		maYesButton = [[MenuButton alloc] initWithTitle:@"YES"];
		[maYesButton setTag:-3];
		[maYesButton setDefault:YES];
	}
	
	// Standard buttons
	[_buttons addObject:maNoButton];	
	[self addSubview:maNoButton];
	[maNoButton addTarget:self action:@selector(_buttonClicked:) forEvents:0x40];
	[_buttons addObject:maTitleButton];	
	[self addSubview:maTitleButton];
	[maTitleButton addTarget:self action:@selector(_buttonClicked:) forEvents:0x40];
	[_buttons addObject:maYesButton];	
	[self addSubview:maYesButton];
	[maYesButton addTarget:self action:@selector(_buttonClicked:) forEvents:0x40];
	
	// Additional properties
	[self setDelegate:delegate];
	[self setContext:delegate];
	[self setNumberOfRows:[_buttons count]/3];
	[self setRunsModal:YES];
	[self setShowsOverSpringBoardAlerts:NO];
	[self setTableShouldShowMinimumContent:NO];  
	[self setTitle:title];
	
	return self;
}

- (id)initOkWithFrame:(struct CGRect)frame title:(NSString *)title delegate:(id)delegate {
	self = [super initWithFrame:frame];
	
	CGRect tl, tc, tr;
	CGRect ml, mc, mr;
	CGRect bl, bc, br;
	CGSize size;
	int cornerWidth, topHeight, botHeight;
	
	[self setAlertSheetStyle:4];
	_progress = NO;
	
	if (!maImage) {
		maImage = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/Applications/%s.app/alertbg.png", APPNAME]];
		size = [maImage size];
		cornerWidth = 24;
		topHeight = 50;
		botHeight = 24;
		tl = CGRectMake(0, 0, cornerWidth, topHeight);
		tc = CGRectMake(cornerWidth, 0, size.width-2*cornerWidth, topHeight);
		tr = CGRectMake(size.width-cornerWidth, 0, cornerWidth, topHeight);
		ml = CGRectMake(0, topHeight, cornerWidth, size.height-topHeight-botHeight);
		mc = CGRectMake(cornerWidth, topHeight, size.width-2*cornerWidth, size.height-topHeight-botHeight);
		mr = CGRectMake(size.width-cornerWidth, topHeight, cornerWidth, size.height-topHeight-botHeight);
		bl = CGRectMake(0, size.height-botHeight, cornerWidth, botHeight);
		bc = CGRectMake(cornerWidth, size.height-botHeight, size.width-2*cornerWidth, botHeight);
		br = CGRectMake(size.width-cornerWidth, size.height-botHeight, cornerWidth, botHeight);
		maSlices = (CDAnonymousStruct11) {tl, tc, tr, ml, mc, mr, bl, bc, br};
	}

	if (!_buttons) {
		_buttons = [[NSMutableArray alloc] init];
	}
	[_buttons removeAllObjects];

	// Empty buttons for spacing
	while ([_buttons count] % 3) {
		[_buttons addObject:[[MenuButton alloc] initWithTitle:@""]];
		[[_buttons lastObject] setHidden:YES];
		[self addSubview:[_buttons lastObject]];
	}
	
	[_buttons addObject:[[MenuButton alloc] initWithTitle:@""]];
	[[_buttons lastObject] setHidden:YES];
	[self addSubview:[_buttons lastObject]];

	if (!maTitleButton) {
		maTitleButton = [[MenuButton alloc] initWithTitle:@""];
		[maTitleButton setTitleLabel:YES];
	}
	[maTitleButton setTitle:@""];

	if (!maOkButton) {
		maOkButton = [[MenuButton alloc] initWithTitle:@"OK"];
		[maOkButton setTag:-2];
		[maOkButton setDefault:YES];
	}
	
	// Standard buttons
	[_buttons addObject:maTitleButton];	
	[self addSubview:maTitleButton];
	[maTitleButton addTarget:self action:@selector(_buttonClicked:) forEvents:0x40];
	[_buttons addObject:maOkButton];	
	[self addSubview:maOkButton];
	[maOkButton addTarget:self action:@selector(_buttonClicked:) forEvents:0x40];
	
	// Additional properties
	[self setDelegate:delegate];
	[self setContext:delegate];
	[self setNumberOfRows:[_buttons count]/3];
	[self setRunsModal:YES];
	[self setShowsOverSpringBoardAlerts:NO];
	[self setTableShouldShowMinimumContent:NO];  
	[self setTitle:title];
	
	return self;
}


- (void) dismiss {
	NSEnumerator *enumerator = [_buttons objectEnumerator];
	id b;
	while (b = [enumerator nextObject]) {
		[b removeTarget:self forEvents:0x40];
	}
	
	[super dismiss];
}

@end