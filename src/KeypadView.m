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
	
	int codes[10][4] = {
		{  24,   17,   16,   19 }, 
		{  56,   49,   48,   51 },
		{ 120,  113,  112,  115 },
		{ 200,  193,  192,  195 },
		{ 136,  129,  128,  131 },
		{ 132,  132,  135,  130 },
		{ 197,  196,  199,  194 },
		{ 117,  116,  119,  114 },
		{  53,   52,   55,   50 },
		{  21,   20,   23,   18 },
	};

	// Setup pushbuttons
	Key *button;
	int r, c;
	for (c=0; c<4; c++) {
		for (r=0; r<10; r++) {
			if (c < 2 && r == 5) {
			} else {
				button = [[Key alloc] initWithFrame:CGRectMake(12+c*51 -8, 12+r*47 -4, 33 +2*8, 29 +2*4) code:codes[r][c] parent:self];
				[button setShowPressFeedback:YES];
				[button addTarget:button action:@selector(keyPressed) forEvents:1];
				[self addSubview: button];
			}
		}
	}
	button = [[Key alloc] initWithFrame:CGRectMake(12+0*52 -8, 12+5*47 -4, 33+47 +2*8, 33 +2*4) code:132 parent:self];
	[button setShowPressFeedback:YES];
	[button addTarget:button action:@selector(keyPressed) forEvents:1];
	[self addSubview: button];

	// set up to get Tap events (handleTapWithCount)
	[self setTapDelegate: self];
	
	return self;
} 

- (void) keyPressed: (int) code {
	[_calc keyPressed:code];
}


@end
