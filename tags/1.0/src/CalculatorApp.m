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

@implementation CalculatorApp

- (void) applicationDidFinishLaunching: (id) fp8 {
	// init main window for the application to be the whole screen.
	struct CGRect frame = CGRectMake(0, 0, 320, 480);

	mainWindow = [[UIWindow alloc] initWithContentRect: frame];

	mainView = [[CalculatorView alloc] initWithFrame: frame];

	[mainWindow orderFront: self];
    [mainWindow makeKey: self];
	[mainWindow _setHidden: NO];	
	[mainWindow setContentView: mainView]; 

	/* show landscape status bar */
	[self setStatusBarMode:3 orientation:90 duration:0];
	// [self setStatusBarShowsProgress:NO];	
}

@end
