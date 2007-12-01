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

@interface DisplayView : UIImageView {
	UIImage 		* digit[36];
	UIImageView		* pos[11];
	UIImageView		* comma[11];
	UIImageView		* dp;
	UIImageView		* f, * g, *c;
	UIImageView		* grad, * rad;
	UIImageView		* user, * prgm;
	UIImageView		* begin, * dmy;
}

- (void) displayString: (NSString *) str;
- (void) showFlagF: (BOOL) visible;
- (void) showFlagG: (BOOL) visible;
- (void) showFlagC: (BOOL) visible;
- (void) showUser: (BOOL) visible;
- (void) showBegin: (BOOL) visible;
- (void) showDMY: (BOOL) visible;
- (void) showPrgm: (BOOL) visible;
- (void) showComma: (BOOL) visible position: (int) pos;
- (void) setDeg;
- (void) setRad;
- (void) setGrad;

@end
