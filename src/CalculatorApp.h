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

#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <GraphicsServices/GraphicsServices.h>
#import <CoreGraphics/CGColor.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIAlertSheet.h>
#import <UIKit/UIImage.h>
#import <UIKit/UIImageView.h>
#import <UIKit/UIProgressBar.h>
#import <UIKit/UIPushButton.h>
#import <UIKit/UIThreePartButton.h>
#import <UIKit/UITransitionView.h>
#import <UIKit/UIView.h>
#import <UIKit/UIView-Geometry.h>
#import <UIKit/UIWindow.h>
#import <UIKit/CDStructures.h>
#import <WebCore/WebFontCache.h>

#import <Celestial/AVController.h>
#import <Celestial/AVItem.h>
          
#include "keymacros.h"

#include <math.h>

#ifdef HP15C		
#define MODEL "15c"
#define APPNAME "HP-15C"
#define CFGPATH "~/Library/net.fors.iphone.hpcalc/15c"
#define ABOUTURL "http://hpcalc-iphone.googlecode.com/svn/repo/hp15c.html"
#include "version-15c.h"
#endif
#ifdef HP12C		
#define MODEL "12c"
#define APPNAME "HP-12C"
#define CFGPATH "~/Library/net.fors.iphone.hpcalc/12c"
#define ABOUTURL "http://hpcalc-iphone.googlecode.com/svn/repo/hp12c.html"
#include "version-12c.h"
#endif
#ifdef HP11C		
#define MODEL "11c"
#define APPNAME "HP-11C"
#define CFGPATH "~/Library/net.fors.iphone.hpcalc/11c"
#define ABOUTURL "http://hpcalc-iphone.googlecode.com/svn/repo/hp11c.html"
#include "version-11c.h"
#endif
#ifdef HP16C		
#define MODEL "16c"
#define APPNAME "HP-16C"
#define CFGPATH "~/Library/net.fors.iphone.hpcalc/16c"
#define ABOUTURL "http://hpcalc-iphone.googlecode.com/svn/repo/hp16c.html"
#include "version-16c.h"
#endif


@class CalculatorView;
@class MenuView;

@interface CalculatorApp : UIApplication {
	UIWindow				* mainWindow;
	CalculatorView			* calcView;
	MenuView				* menuView;
}

- (void) applicationDidFinishLaunching: (id) fp8;

@end
