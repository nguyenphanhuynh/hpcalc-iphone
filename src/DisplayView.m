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
#import "DisplayView.h"
            
#import "display.h"
#import "proc.h"
#import "digit_ops.h"
#import "voyager_lcd.h"
#import "proc_nut.h"

@implementation DisplayView

- (id) initWithFrame: (CGRect)frame {
	self = [super initWithFrame: frame];
	
	[self setImage: [UIImage imageNamed: @"display.png"]];
     
	digit[0] = [UIImage imageNamed:@"0.png"];
	digit[1] = [UIImage imageNamed:@"1.png"];
	digit[2] = [UIImage imageNamed:@"2.png"];
	digit[3] = [UIImage imageNamed:@"3.png"];
	digit[4] = [UIImage imageNamed:@"4.png"];
	digit[5] = [UIImage imageNamed:@"5.png"];
	digit[6] = [UIImage imageNamed:@"6.png"];
	digit[7] = [UIImage imageNamed:@"7.png"];
	digit[8] = [UIImage imageNamed:@"8.png"];
	digit[9] = [UIImage imageNamed:@"9.png"];
	digit[10] = [UIImage imageNamed:@"decimal.png"];
	digit[11] = [UIImage imageNamed:@"comma.png"];
	digit[12] = [UIImage imageNamed:@"f.png"];
	digit[13] = [UIImage imageNamed:@"g.png"];
	digit[14] = [UIImage imageNamed:@"grad.png"];
	digit[15] = [UIImage imageNamed:@"rad.png"];
	digit[16] = [UIImage imageNamed:@"neg.png"];

	digit[17] = [UIImage imageNamed:@"E.png"];
	digit[18] = [UIImage imageNamed:@"RR.png"];
	digit[19] = [UIImage imageNamed:@"O.png"];
	digit[20] = [UIImage imageNamed:@"r.png"];
	digit[21] = [UIImage imageNamed:@"u.png"];
	digit[22] = [UIImage imageNamed:@"n.png"];
	digit[23] = [UIImage imageNamed:@"i.png"];
	digit[24] = [UIImage imageNamed:@"P.png"];

	digit[25] = [UIImage imageNamed:@"user.png"];
	digit[26] = [UIImage imageNamed:@"prgm.png"];
	digit[27] = [UIImage imageNamed:@"c.png"];

	digit[28] = [UIImage imageNamed:@"begin.png"];
	digit[29] = [UIImage imageNamed:@"dmy.png"];

	digit[30] = [UIImage imageNamed:@"h.png"];
	digit[31] = [UIImage imageNamed:@"d.png"];
	digit[32] = [UIImage imageNamed:@"b.png"];
	digit[33] = [UIImage imageNamed:@"a.png"];
	digit[34] = [UIImage imageNamed:@"CC.png"];
	digit[35] = [UIImage imageNamed:@"FF.png"];
	
	int i;                                                   
	for (i=0; i<11; i++) {
		comma[11-i-1] = [[UIImageView alloc] initWithFrame:CGRectMake(240 -211, 97-21+21*i, 26, 21)];
		[self addSubview: comma[11-i-1]];
		pos[11-i-1] = [[UIImageView alloc] initWithFrame:CGRectMake(240 -211, 97-21+21*i, 26, 21)];
		[self addSubview: pos[11-i-1]];
	}
	
	// dp = [[UIImageView alloc] initWithFrame:CGRectMake(240 -211, 97+21*0, 26, 21)];
	// [self addSubview: dp];
	
	user = [[UIImageView alloc] initWithFrame:CGRectMake(229 -211, 91 +0, 11, 26)];
	[self addSubview: user];
	f = [[UIImageView alloc] initWithFrame:CGRectMake(229 -211, 91 +30, 11, 6)];
	[self addSubview: f];
	g = [[UIImageView alloc] initWithFrame:CGRectMake(229 -211, 91 +41, 11, 7)];
	[self addSubview: g];
	begin = [[UIImageView alloc] initWithFrame:CGRectMake(229 -211, 91 +60, 11, 29)];
	[self addSubview: begin];
	grad = [[UIImageView alloc] initWithFrame:CGRectMake(229 -211, 91 +100, 11, 27)];
	[self addSubview: grad];
	rad = [[UIImageView alloc] initWithFrame:CGRectMake(229 -211, 91 +107, 11, 20)];
	[self addSubview: rad];
	dmy = [[UIImageView alloc] initWithFrame:CGRectMake(229 -211, 91 +133, 11, 25)];
	[self addSubview: dmy];
	c = [[UIImageView alloc] initWithFrame:CGRectMake(229 -211, 91 +164, 11, 8)];
	[self addSubview: c];
	prgm = [[UIImageView alloc] initWithFrame:CGRectMake(229 -211, 91 +184, 11, 28)];
	[self addSubview: prgm];
		
	// set up to get Tap events (handleTapWithCount)
	[self setTapDelegate: self];
	
	return self;
} 

- (void) displayString: (NSString *) str {
	int p = 10;

	// NSLog(@"displayString: %@ (%d)", str, [str length]);

	// [dp setImage:nil];
	
	int i;
	for (i=0; i<[str length]; i++) {
		switch ([str characterAtIndex:i]) {
			case 32:
				// space
				if (p>=0)
					[pos[p--] setImage:nil];
				break;
			case 45:
				// -
				if (p>=0)
					[pos[p--] setImage:digit[16]];
				break;
			// case 46:
			// 	// .
			// 	[dp setImage:digit[10]];
			// 	[dp setFrame:CGRectMake(240 -211, 97+21*(10-p-2), 26, 21)];
			// 	break;
			case 48:
			case 49:
			case 50:
			case 51:
			case 52:
			case 53:
			case 54:
			case 55:
			case 56:
			case 57:
				// 0-9
				if (p>=0)
					[pos[p--] setImage:digit[[str characterAtIndex:i]-48]];
				break; 
			case 69:
				// E
				if (p>=0)
					[pos[p--] setImage:digit[17]];
				break; 
			case 79:
				// O
				if (p>=0)
					[pos[p--] setImage:digit[19]];
				break; 
			case 80:
				// P
				if (p>=0)
					[pos[p--] setImage:digit[24]];
				break; 
			case 82:
				// R
				if (p>=0)
					[pos[p--] setImage:digit[18]];
				break; 
			case 114:
				// r
				if (p>=0)
					[pos[p--] setImage:digit[20]];
				break; 
			case 117:
				// u
				if (p>=0)
					[pos[p--] setImage:digit[21]];
				break; 
			case 110:
				// n
				if (p>=0)
					[pos[p--] setImage:digit[22]];
				break; 
			case 105:
				// i
				if (p>=0)
					[pos[p--] setImage:digit[23]];
				break; 
			case 98:
				// b
				if (p>=0)
					[pos[p--] setImage:digit[32]];
				break; 
			case 100:
				// d
				if (p>=0)
					[pos[p--] setImage:digit[31]];
				break; 
			case 104:
				// h
				if (p>=0)
					[pos[p--] setImage:digit[30]];
				break; 
			case 65:
				// A
				if (p>=0)
					[pos[p--] setImage:digit[33]];
				break; 
			case 67:
				// C
				if (p>=0)
					[pos[p--] setImage:digit[34]];
				break; 
			case 70:
				// F
				if (p>=0)
					[pos[p--] setImage:digit[35]];
				break; 
			default:
				break;
		}
	}
	
	while (p>=0) {
		[pos[p--] setImage:nil];
	}
}

- (void) showFlagF: (BOOL) visible {
	if (visible) {
		[f setImage:digit[12]];
	} else {
		[f setImage:nil];
	}
}

- (void) showFlagG: (BOOL) visible {
	if (visible) {
		[g setImage:digit[13]];
	} else {
		[g setImage:nil];
	}
}

- (void) showFlagC: (BOOL) visible {
	if (visible) {
		[c setImage:digit[27]];
	} else {
		[c setImage:nil];
	}
}

- (void) showUser: (BOOL) visible {
	if (visible) {
		[user setImage:digit[25]];
	} else {
		[user setImage:nil];
	}
}

- (void) showBegin: (BOOL) visible {
	if (visible) {
		[begin setImage:digit[28]];
	} else {
		[begin setImage:nil];
	}
}

- (void) showDMY: (BOOL) visible {
	if (visible) {
		[dmy setImage:digit[29]];
	} else {
		[dmy setImage:nil];
	}
}

- (void) showPrgm: (BOOL) visible {
	if (visible) {
		[prgm setImage:digit[26]];
	} else {
		[prgm setImage:nil];
	}
}

- (void) showComma: (BOOL) visible position: (int) p {
	if (visible) {
		[comma[10-p] setImage:digit[11]];
	} else {
		[comma[10-p] setImage:nil];
	}
}

- (void) showDecimal: (BOOL) visible position: (int) p {
	if (visible) {
		[comma[10-p] setImage:digit[10]];
	} else {
		[comma[10-p] setImage:nil];
	}
}

- (void) setDeg {
	[rad setImage:nil];
	[grad setImage:nil];
}

- (void) setRad {
	[grad setImage:nil];
	[rad setImage:digit[15]];
}

- (void) setGrad {
	[rad setImage:nil];
	[grad setImage:digit[14]];
}

void display_callback(struct nut_reg_t *nv) {
	static unsigned long last[MAX_DIGIT_POSITION];
	BOOL update = NO;
	
	int i;
	// for (i=0; i<MAX_DIGIT_POSITION; i++) {
	// 	if (nv->display_segments[i] != 0) {
	// 		update = YES;
	// 	}
	// }
	// if (update) {
		update = NO;
		for (i=0; i<MAX_DIGIT_POSITION; i++) {
			if (nv->display_segments[i] != last[i]) {
				update = YES;
			}
			last[i] = nv->display_segments[i];
		}
	// }
	
	if (update) {
		char disp[2*MAX_DIGIT_POSITION+1];
	
		int i, j;
		for (j=0; j<2*MAX_DIGIT_POSITION+1; j++) {
			disp[j] = '\x00';
		}
		j=0;
		for (i=0; i<MAX_DIGIT_POSITION; i++) {
			switch (nv->display_segments[i] & 127) {
				case 64:	
					disp[j++] = '-'; 
					break;
				case 63:	
					disp[j++] = '0'; 
					break;
				case 6:		
					disp[j++] = '1'; 
					break;
				case 91:	
					disp[j++] = '2'; 
					break;
				case 79:	
					disp[j++] = '3'; 
					break;
				case 102:	
					disp[j++] = '4'; 
					break;
				case 109:	
					disp[j++] = '5'; 
					break;
				case 125:	
					disp[j++] = '6'; 
					break;
				case 7:		
					disp[j++] = '7'; 
					break;
				case 127:	
					disp[j++] = '8'; 
					break;
				case 111:	
					disp[j++] = '9'; 
					break;
				case 115:	disp[j++] = 'P'; break;
				case 121:	disp[j++] = 'E'; break;
				case 2:		disp[j++] = 'i'; break;
				case 35:	disp[j++] = 'n'; break;
				case 92:	disp[j++] = 'O'; break;
				case 80:	disp[j++] = 'R'; break;
				case 33:	disp[j++] = 'r'; break;
				case 98:	disp[j++] = 'u'; break;
				case 124:	disp[j++] = 'b'; break;
				case 94:	disp[j++] = 'd'; break;
				case 116:	disp[j++] = 'h'; break;
				case 119:	disp[j++] = 'A'; break;
				case 57:	disp[j++] = 'C'; break;
				case 113:	disp[j++] = 'F'; break;
				case 0:		disp[j++] = ' '; break;
				default:	
					NSLog(@"unknown: %d", nv->display_segments[i]);
					// disp[j++] = ' '; 
					break;
			}
			if (nv->display_segments[i] & 256) {
				disp[j++] = ',';
			} else if (nv->display_segments[i] & 128) {
				disp[j++] = '.';
			}
			
			// if (nv->display_segments[i] & ~255) {
			// 	NSLog(@"%d: %d", i, nv->display_segments[i] & ~255);
			// }
			
			switch (i) {
			case 2:
				[(DisplayView *)nv->display showUser:((nv->display_segments[i] & ~511) != 0)];
				break;
			case 3:
				[(DisplayView *)nv->display showFlagF:((nv->display_segments[i] & ~511) != 0)];
				break;
			case 4:
				[(DisplayView *)nv->display showFlagG:((nv->display_segments[i] & ~511) != 0)];
				break;
			case 5:
				[(DisplayView *)nv->display showBegin:((nv->display_segments[i] & ~511) != 0)];
				break;
			case 7:
				if ((nv->display_segments[7] & ~511) != 0) {
					if ((nv->display_segments[6] & ~511) != 0) {
						[(DisplayView *)nv->display setGrad];
					} else {
						[(DisplayView *)nv->display setRad];
					}
				} else {
					[(DisplayView *)nv->display setDeg];
				}
				break;
			case 8:
				[(DisplayView *)nv->display showDMY:((nv->display_segments[i] & ~511) != 0)];
				break;
			case 9:
				[(DisplayView *)nv->display showFlagC:((nv->display_segments[i] & ~511) != 0)];
				break;
			case 10:
				[(DisplayView *)nv->display showPrgm:((nv->display_segments[i] & ~511) != 0)];
				break;
			}
		}
			
		disp[j++] = '\x00';
		if (strncmp(disp, "  Run", 5) == 0) {
			disp[2] = 'r';
		}
		[(DisplayView *)nv->display displayString:[NSString stringWithCString:disp]];
		// NSLog(@"[%s]", disp);

		for (i=0; i<11; i++) {
			[(DisplayView *)nv->display showComma:((nv->display_segments[i] & 256) != 0) position:i];
			[(DisplayView *)nv->display showDecimal:((nv->display_segments[i] & 384) == 128) position:i];
		}
	}
}

@end
