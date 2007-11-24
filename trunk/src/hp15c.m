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