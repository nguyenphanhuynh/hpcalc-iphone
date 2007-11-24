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

#import <UIKit/UIWindow.h>

#import "CalculatorApp.h"

/*
 * Main entry point of application 
 */
int main(int argc, char **argv) {
	int rc = 0;
	bool init = NO;
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	int i;
	for (i=1; i<argc; i++) {
		if (strncasecmp("--init", argv[i], 6) == 0) {
			init = YES;
		}
	}

	if (init) {
		/* Set springboard to hide status bar on launch */
		NSString *path = [NSString stringWithString:@"/System/Library/CoreServices/SpringBoard.app/DefaultApplicationState.plist"];
		NSMutableDictionary *sb = [NSMutableDictionary dictionaryWithContentsOfFile:path];
		NSMutableDictionary *me = [sb objectForKey:@"net.fors.iphone.hp15c"];
		if (me == nil) {
			me = [[NSMutableDictionary alloc] init];
			[me setObject:[NSNumber numberWithInt:2] forKey:@"SBDefaultStatusBarModeKey"];
	   		[sb setObject:me forKey:@"net.fors.iphone.hp15c"];
			[sb writeToFile:path atomically:YES];
		}     
	} else {
		rc = UIApplicationMain(argc, argv, [CalculatorApp class]);
	}
	
	[pool release];
	return rc;
}
