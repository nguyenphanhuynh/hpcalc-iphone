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
#import <UIKIT/NSString-UIStringDrawing.h>

static UIImage				* mbImage = nil;
static UIImage				* mbPressedImage = nil;
static CDAnonymousStruct11	  mbSlices;
struct __GSFont				* mbTitleFont = nil;

@implementation MenuButton

// - (BOOL)respondsToSelector:(SEL)aSelector {
// 	NSLog(@"%@", NSStringFromSelector(aSelector));
// 	return [super respondsToSelector:aSelector];
// }	

- (id)initWithFrame:(struct CGRect)frame {
	self = [super initWithFrame: frame];
	return self;
}

- (id)initWithTitle:(NSString *)title {
	CGRect tl, tc, tr;
	CGRect ml, mc, mr;
	CGRect bl, bc, br;
	CGSize size;
	int cornerWidth, topHeight, botHeight;
	
	self = [super init];
	
	_initialized = NO;
	_hidden = NO;
	_default = NO;
	_titleLabel = NO;
	
	if (!mbImage) {
		mbImage = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/Applications/%s.app/alertbutton.png", APPNAME]];
	 	size = [mbImage size];
		cornerWidth = 15;
	 	topHeight = 20;
	 	botHeight = 15;
	 	tl = CGRectMake(0, 0, cornerWidth, topHeight);
	 	tc = CGRectMake(cornerWidth, 0, size.width-2*cornerWidth, topHeight);
	 	tr = CGRectMake(size.width-cornerWidth, 0, cornerWidth, topHeight);
	 	ml = CGRectMake(0, topHeight, cornerWidth, size.height-topHeight-botHeight);
	 	mc = CGRectMake(cornerWidth, topHeight, size.width-2*cornerWidth, size.height-topHeight-botHeight);
	 	mr = CGRectMake(size.width-cornerWidth, topHeight, cornerWidth, size.height-topHeight-botHeight);
	 	bl = CGRectMake(0, size.height-botHeight, cornerWidth, botHeight);
	 	bc = CGRectMake(cornerWidth, size.height-botHeight, size.width-2*cornerWidth, botHeight);
	 	br = CGRectMake(size.width-cornerWidth, size.height-botHeight, cornerWidth, botHeight);
		mbSlices = (CDAnonymousStruct11) {tl, tc, tr, ml, mc, mr, bl, bc, br};
	}

	if (!mbPressedImage) {
		mbPressedImage = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/Applications/%s.app/alertbuttonpressed.png", APPNAME]];
	}

	if (!mbTitleFont) {
		mbTitleFont = [NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:2 size:13.0];
	}
	
	[self setTitle:title];
	
	_textLabel = [[UITextLabel alloc] init];
	[_textLabel setText:title];
	[_textLabel setWrapsText:YES];
	[_textLabel setCentersHorizontally:YES];
	
	return self;
}

- (void)mouseDown:(struct __GSEvent *)event {
	// AudioServicesPlaySystemSound(1105);
	[super mouseDown:event];
}

- (void)mouseUp:(struct __GSEvent *)event {
	[super mouseUp:event];
}

- (void)drawButtonPart:(int)part inRect:(struct CGRect)rect {
	if ( ! _initialized ) {
		CGRect frame = [super frame];
		[self setFrame:frame];
		
		if ( _titleLabel ) {
			[self setEnabled:NO];
		}

		[_textLabel setFrame:CGRectMake(0, 0, rect.size.width-20, rect.size.height)];

		if ( _titleLabel ) {
			[_textLabel setFont:mbTitleFont];
			// set to gray
			[_textLabel setColor:(struct CGColor *)GSColorForSystemColor(3)];
		} else {
			// Auto-size text to fit button volumetrically
			CGSize size;
			struct __GSFont * myFont;
			float fontSize = 15.5;
			do {
				myFont = [NSClassFromString(@"WebFontCache") 
						createFontWithFamily:@"Helvetica" traits:2 size:fontSize];

				[_textLabel setFont: myFont];
				size = [_textLabel textSize];
				fontSize -= 0.1;
			} while ( (size.width*size.height) > (rect.size.width*rect.size.height)/2 );
			[_textLabel setFont: myFont];
			// set to white
			[_textLabel setColor:(struct CGColor *)GSColorForSystemColor(1)];
		}
		
		// [_textLabel setFrame:CGRectMake(0, 0, rect.size.width-10, rect.size.height)];
		_initialized = YES;
	}

	[self setEnabled:(!_hidden && !_titleLabel)];

	// Draw the custom button image
	if ( ! _hidden && ! _titleLabel && part==1 ) {
		CGRect drawRect = rect;
		drawRect.origin.y += 2;
		if ([self isPressed] ? !_default : _default) {
			[mbPressedImage draw9PartImageWithSliceRects:mbSlices inRect:drawRect];
		} else {
			[mbImage draw9PartImageWithSliceRects:mbSlices inRect:drawRect];
		}
	}
	
	// Use UITextLabel routines to display button text
	if ( ! _hidden && part==2 ) {
		CGRect drawRect = rect;
		drawRect.origin.x += 10;
		drawRect.size.width -= 20;
		[_textLabel drawContentsInRect:drawRect];
	}
}

- (void) setHidden:(bool) hidden {
	_hidden = hidden;
	[self setNeedsDisplay];
}

- (void) setDefault:(bool) def {
	_default = def;
}

- (void) setTitleLabel:(bool) titleLabel {
	_titleLabel = titleLabel;
}

- (void) setTitle:(NSString *) title {
	[super setTitle:title];
	[_textLabel setText:title];
}

@end