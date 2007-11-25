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
#import "DisplayView.h"
#import "hp15c.h"

@implementation CalculatorView

- (id) initWithFrame: (CGRect) frame {
	self = [super initWithFrame: frame];
	
	keypad = [[KeypadView alloc] initWithFrame: frame parent:self];
	[self addSubview: keypad];

	frame.origin.x += 211;
	frame.size.width -= 211;
	display = [[DisplayView alloc] initWithFrame: frame];
	[self addSubview: display];
	
	calc = [[HP15C alloc] initWithDisplay:display];
	[calc _updateDisplay];
	
	return self;
}

- (void) keyPressed: (int) code {
	[calc processKeypress:code];
}

@end
