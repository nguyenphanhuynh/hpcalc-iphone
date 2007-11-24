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
#import "KeypadView.h"
#import "Key.h"

@implementation KeypadView

- (id) initWithFrame: (CGRect)frame parent: (CalculatorView *) p {
	self = [super initWithFrame: frame];
	
	_calc = p;
	
	[self setImage: [UIImage imageNamed: @"keypad.png"]];
	
	NSString * labels[10][4] = {
		{ @"ON",	@"R/S",		@"SST",		@"SQRT(x)"	}, 
		{ @"f",		@"GSB",		@"GTO",		@"e^x" 		},
		{ @"g",		@"Rdown",   @"SIN",		@"10^x"   	},
		{ @"STO",  	@"x <-> y",	@"COS",		@"y^x" 		},
		{ @"RCL",   @"<-",		@"TAN",		@"1/x" 		},
		{ @"ENTER", @"ENTER",   @"EEX",		@"CHS" 		},
		{ @"0",		@"1",		@"4",		@"7" 		},
		{ @".",		@"2",		@"5",		@"8" 		},
		{ @"E+",    @"3",		@"6",		@"9" 		},
		{ @"+",		@"-",		@"*",		@"/" 		},
	};
	
	// Setup pushbuttons
	Key *button;
	int r, c;
	for (c=0; c<4; c++) {
		for (r=0; r<10; r++) {
			if (c < 2 && r == 5) {
			} else {
				button = [[Key alloc] initWithFrame:CGRectMake(12+c*51 -8, 12+r*47 -4, 33 +2*8, 29 +2*4) label:labels[r][c] parent:self];
				[button setShowPressFeedback:YES];
				[button addTarget:button action:@selector(keyPressed) forEvents:1];
				[self addSubview: button];
			}
		}
	}
	button = [[Key alloc] initWithFrame:CGRectMake(12+0*52 -8, 12+5*47 -4, 33+47 +2*8, 33 +2*4) label:@"ENTER" parent:self];
	[button setShowPressFeedback:YES];
	[button addTarget:button action:@selector(keyPressed) forEvents:1];
	[self addSubview: button];

	// set up to get Tap events (handleTapWithCount)
	[self setTapDelegate: self];
	
	return self;
} 

- (void) keyPressed: (NSString *) key {
	// NSLog(@"Keypad: %@ pressed", key);
	[_calc keyPressed:key];
}


@end
