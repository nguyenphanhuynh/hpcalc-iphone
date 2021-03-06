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
#import "KeypadView.h"
#import "Key.h"

@implementation Key

- (id) initWithFrame: (CGRect) frame code: (int) code parent: (KeypadView *) p {
	self = [super initWithFrame: frame];
	_code = code;
	_keypad = p;
	return self;
}   

- (void)mouseDown:(struct __GSEvent *)event {
	if ( [[NSUserDefaults standardUserDefaults] boolForKey:@"keyClick"] ) {
		AudioServicesPlaySystemSound(1105);
	}
	[_keypad keyPressed:_code];
	[super mouseDown:event];
}

- (void)mouseUp:(struct __GSEvent *)event {
	[_keypad keyPressed:-1];
	[super mouseUp:event];
}

@end
