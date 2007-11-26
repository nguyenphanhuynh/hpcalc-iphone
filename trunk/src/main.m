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
		NSMutableDictionary *me = [sb objectForKey:[NSString stringWithFormat:@"net.fors.iphone.hp%s", MODEL]];
		if (me == nil) {
			me = [[NSMutableDictionary alloc] init];
			[me setObject:[NSNumber numberWithInt:2] forKey:@"SBDefaultStatusBarModeKey"];
	   		[sb setObject:me forKey:[NSString stringWithFormat:@"net.fors.iphone.hp%s", MODEL]];
			[sb writeToFile:path atomically:YES];
		}     
	} else {
		rc = UIApplicationMain(argc, argv, [CalculatorApp class]);
	}
	
	[pool release];
	return rc;
}
