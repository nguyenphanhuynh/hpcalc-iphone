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
#import "MenuButton.h"

@class MenuAlert;

@interface MenuView : UIView {
	MenuAlert				* _alert;
	CalculatorView			* _calcView;
	NSMutableArray			* _menuStack;
	NSMutableDictionary		* _menuData;
	NSMutableArray			* _tagList;
}

- (void) setCalcView:(CalculatorView *) v;
- (void) processKeypress: (int) code;

- (int) _nameToTag:(NSString *) name;
- (NSString *) _tagToName:(int) tag;
- (MenuButton *) _buttonWithTag:(int) tag;
- (MenuButton *) _buttonWithName:(NSString *) name;
- (bool) _isMenu:(int) tag;
- (bool) _isMacro:(int) tag;
- (void) _playMacro:(id)tag;

@end