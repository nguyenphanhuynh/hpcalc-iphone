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
#import "OTUpdateManager.h"
#import "hpcalc.h"

/*
 * Main entry point of application 
 */
int main(int argc, char **argv) {
	int rc = 0;
	bool init = NO;
	bool reset = NO;
	bool nogui = NO;
	bool ver = NO;
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	int i;
	for (i=1; i<argc; i++) {
		if (strncasecmp("--init", argv[i], 6) == 0) {
			init = YES;
		} else if (strncasecmp("--reset", argv[i], 7) == 0) {
			reset = YES;
		} else if (strncasecmp("--nogui", argv[i], 7) == 0) {
			nogui = YES;
		} else if (strncasecmp("--ver", argv[i], 5) == 0) {
			ver = YES;
		}
	}

	/* Set springboard to hide status bar on launch 
	 * 
	 * This code was moved out of the (init) case below so people that install it
	 * without using Installer.app will have the status bar go to landscape once they 
	 * restart or reboot their phone.
	 */
	NSString *path = [NSString stringWithString:@"/System/Library/CoreServices/SpringBoard.app/DefaultApplicationState.plist"];
	NSMutableDictionary *sb = [NSMutableDictionary dictionaryWithContentsOfFile:path];
	NSMutableDictionary *me = [sb objectForKey:[NSString stringWithFormat:@"net.fors.iphone.hp%s", MODEL]];
	if (me == nil) {
		me = [[NSMutableDictionary alloc] init];
		[me setObject:[NSNumber numberWithInt:2] forKey:@"SBDefaultStatusBarModeKey"];
   		[sb setObject:me forKey:[NSString stringWithFormat:@"net.fors.iphone.hp%s", MODEL]];
		[sb writeToFile:path atomically:YES];
	}     

	/* Create sub-folders under ~/Library/net.fors.iphone.hpcalc and move state file */
	if ( ! [[NSFileManager defaultManager] fileExistsAtPath:@CFGPATH] ) {
		[[NSFileManager defaultManager] createDirectoryAtPath:@CFGPATH attributes:nil];

		NSString *path = [NSString stringWithFormat:@"/var/root/Library/net.fors.iphone.hpcalc"];
		NSString *name = [NSString stringWithFormat:@"%@/%s.state", path, MODEL];
		NSString *newName = [NSString stringWithFormat:@"%@/%s/state", path, MODEL];
		if ( [[NSFileManager defaultManager] fileExistsAtPath:name] ) {
			[[NSFileManager defaultManager] copyPath:name toPath:newName handler:nil];
    		[[NSFileManager defaultManager] removeFileAtPath:name handler:nil];
		}
	}

	if (init) {
		/* This switch is used by Installer.app to run the status bar hiding code
		 * above.  So we do nothing here and exit below so Installer.app can finish.
		 */
	} else if (reset) {
		/* Delete persistent memory */
		NSString *path = [NSString stringWithFormat:@"/var/root/Library/net.fors.iphone.hpcalc"];
		NSString *name = [NSString stringWithFormat:@"%@/%s/state", path, MODEL];
     	[[NSFileManager defaultManager] removeFileAtPath:name handler:nil];
     	if ([[[NSFileManager defaultManager] directoryContentsAtPath:path] count] == 0) {
     		[[NSFileManager defaultManager] removeFileAtPath:path handler:nil];
		}
	} else if (nogui) {
		HPCalc *calc = [[HPCalc alloc] init];

		while ( ! [calc keyBufferIsEmpty]) {
			// wait for keystroke buffer to empty
			[NSThread sleepForTimeInterval:0.1];
		}

		// Turn on if the calculator was off
		if ([[calc getDisplayString] isEqualToString:@"               "]) {
			[calc playMacro:[NSArray arrayWithObjects:K_ON, nil]];
		}
		while ([[calc getDisplayString] isEqualToString:@"               "]) {
			[NSThread sleepForTimeInterval:0.1];
		}

		int i;
		for (i=1; i<argc; i++) {
			if (strncasecmp("--", argv[i], 2) != 0) {
				// if it's not a command line switch
				[calc computeFromString:[NSString stringWithCString:argv[i]]];
			}
			
		}
		printf("%s\n", [[calc getDisplayString] cStringUsingEncoding:NSASCIIStringEncoding]);
		
		[calc shutdown];
	} else if (ver) {
		printf("%s\n", VER_STR);
	} else {
		rc = UIApplicationMain(argc, argv, [CalculatorApp class]);
	}
	
	[pool release];
	return rc;
}
