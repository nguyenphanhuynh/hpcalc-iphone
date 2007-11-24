/* Copyright (c) 2007, Thomas Fors
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 *     * Redistributions of source code must retain the above copyright notice,
 *       this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the copyright holder nor the names of its
 *       contributors may be used to endorse or promote products derived from
 *       this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER
 * OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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
