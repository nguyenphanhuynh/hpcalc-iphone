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
		
	nv = nut_new_processor(NNPR_RAM, (void *)dv);
	
	NSString *objFile = [NSString stringWithFormat:@"/Applications/%s.app/%s.obj", APPNAME, MODEL];
	nut_read_object_file(nv, [objFile cString]);
	
	keyQueue = [[NSMutableArray alloc] init];
	
	[self processKeypress:24];  // auto on
	[self processKeypress:129]; // clear Pr Error
	
	[NSThread detachNewThreadSelector:@selector(tick) toTarget:self withObject:nil];

	return self;
}

- (void) processKeypress: (int) code {
	[keyQueue insertObject:[NSNumber numberWithInt:code] atIndex:0];
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