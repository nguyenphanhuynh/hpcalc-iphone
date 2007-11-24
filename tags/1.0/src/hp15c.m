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
#import "hp15c.h"
#import "DisplayView.h"

@implementation HP15C

- (void) _updateDisplay {
}


- (id) initWithDisplay: (DisplayView *) dv {
	self = [super init];
	
	_display = dv;
	
	keyMap = [[NSMutableDictionary alloc] init];
	
	[keyMap setValue:[NSNumber numberWithInt:24] forKey:@"ON"];
	[keyMap setValue:[NSNumber numberWithInt:56] forKey:@"f"];
	[keyMap setValue:[NSNumber numberWithInt:120] forKey:@"g"];
	[keyMap setValue:[NSNumber numberWithInt:200] forKey:@"STO"];
	[keyMap setValue:[NSNumber numberWithInt:136] forKey:@"RCL"];
	[keyMap setValue:[NSNumber numberWithInt:132] forKey:@"ENTER"];
	[keyMap setValue:[NSNumber numberWithInt:197] forKey:@"0"];
	[keyMap setValue:[NSNumber numberWithInt:117] forKey:@"."];
	[keyMap setValue:[NSNumber numberWithInt:53] forKey:@"E+"];
	[keyMap setValue:[NSNumber numberWithInt:21] forKey:@"+"];

	[keyMap setValue:[NSNumber numberWithInt:17] forKey:@"R/S"];
	[keyMap setValue:[NSNumber numberWithInt:49] forKey:@"GSB"];
	[keyMap setValue:[NSNumber numberWithInt:113] forKey:@"Rdown"];
	[keyMap setValue:[NSNumber numberWithInt:193] forKey:@"x <-> y"];
	[keyMap setValue:[NSNumber numberWithInt:129] forKey:@"<-"];
	[keyMap setValue:[NSNumber numberWithInt:196] forKey:@"1"];
	[keyMap setValue:[NSNumber numberWithInt:116] forKey:@"2"];
	[keyMap setValue:[NSNumber numberWithInt:52] forKey:@"3"];
	[keyMap setValue:[NSNumber numberWithInt:20] forKey:@"-"];

	[keyMap setValue:[NSNumber numberWithInt:16] forKey:@"SST"];
	[keyMap setValue:[NSNumber numberWithInt:48] forKey:@"GTO"];
	[keyMap setValue:[NSNumber numberWithInt:112] forKey:@"SIN"];
	[keyMap setValue:[NSNumber numberWithInt:192] forKey:@"COS"];
	[keyMap setValue:[NSNumber numberWithInt:128] forKey:@"TAN"];
	[keyMap setValue:[NSNumber numberWithInt:135] forKey:@"EEX"];
	[keyMap setValue:[NSNumber numberWithInt:199] forKey:@"4"];
	[keyMap setValue:[NSNumber numberWithInt:119] forKey:@"5"];
	[keyMap setValue:[NSNumber numberWithInt:55] forKey:@"6"];
	[keyMap setValue:[NSNumber numberWithInt:23] forKey:@"*"];

	[keyMap setValue:[NSNumber numberWithInt:19] forKey:@"SQRT(x)"];
	[keyMap setValue:[NSNumber numberWithInt:51] forKey:@"e^x"];
	[keyMap setValue:[NSNumber numberWithInt:115] forKey:@"10^x"];
	[keyMap setValue:[NSNumber numberWithInt:195] forKey:@"y^x"];
	[keyMap setValue:[NSNumber numberWithInt:131] forKey:@"1/x"];
	[keyMap setValue:[NSNumber numberWithInt:130] forKey:@"CHS"];
	[keyMap setValue:[NSNumber numberWithInt:194] forKey:@"7"];
	[keyMap setValue:[NSNumber numberWithInt:114] forKey:@"8"];
	[keyMap setValue:[NSNumber numberWithInt:50] forKey:@"9"];
	[keyMap setValue:[NSNumber numberWithInt:18] forKey:@"/"];
			
	nv = nut_new_processor(NNPR_RAM, (void *)dv);
	
	NSString *objFile = [NSString stringWithString:@"/Applications/HP-15C.app/15c.obj"];
	nut_read_object_file(nv, [objFile cString]);
	
	keyQueue = [[NSMutableArray alloc] init];
	
	[self processKeypress:@"ON"]; // auto on
	[self processKeypress:@"<-"]; // clear Pr Error
	
	[NSThread detachNewThreadSelector:@selector(tick) toTarget:self withObject:nil];

	return self;
}

- (void) processKeypress: (NSString *) key {
	[keyQueue insertObject:[keyMap valueForKey:key] atIndex:0];
	[keyQueue insertObject:[NSNumber numberWithInt:-1] atIndex:0];
}

- (void) tick {
    NSAutoreleasePool* p = [[NSAutoreleasePool alloc] init];
	           
	[NSThread setThreadPriority:0.25];
	while (1) {
		[NSThread sleepForTimeInterval:0.05];
		[self performSelectorOnMainThread:@selector(readKeys) withObject:nil waitUntilDone:YES];
		[self performSelectorOnMainThread:@selector(executeCycle) withObject:nil waitUntilDone:YES];
	}
	
	[p release];
}

- (void) executeCycle {
	int i=500;
	while(i-- > 0) {
		nut_execute_instruction(nv);
	}
}

- (void) readKeys {
	static int delay = 0;
	int key;
	        
	if (delay) {
		delay--;
	} else {
		if ([keyQueue lastObject]) {
			key = [[keyQueue lastObject] intValue];
			[keyQueue removeLastObject];
			if (key >= 0) {
				nut_press_key(nv, key);
			} else {
				nut_release_key(nv);
			}
			
			if (key == -1) {
				if ([keyQueue lastObject]) {
					key = [[keyQueue lastObject] intValue];
					[keyQueue removeLastObject];
					if (key >= 0) {
						nut_press_key(nv, key);
					} else {
						nut_release_key(nv);
					}
					delay = 2;
				}
			}
		}
	}
}

@end