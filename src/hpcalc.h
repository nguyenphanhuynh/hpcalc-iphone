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

@class DisplayView;

#import "display.h"
#import "proc.h"
#import "digit_ops.h"
#import "voyager_lcd.h"
#import "proc_nut.h"

#define NNPR_OBJ		@"15c"
#define NNPR_RAM		80
#define NNPR_CLOCK		215000.0
#define NNPR_WSIZE		56.0


@interface HPCalc : NSObject {
	DisplayView			* _display;
	nut_reg_t			* nv;
	NSMutableArray  	* keyQueue;
	NSTimeInterval  	lastRun;
}

- (void) _updateDisplay;
- (id) initWithDisplay: (DisplayView *) dv;
- (void) processKeypress: (int) code;
- (void) executeCycle;
- (void) readKeys;

@end
