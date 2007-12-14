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

//
// First Row
// 

#define K_ON			[NSNumber numberWithInt:24],  [NSNumber numberWithInt:-1]
#define K_F				[NSNumber numberWithInt:56],  [NSNumber numberWithInt:-1]
#define K_G				[NSNumber numberWithInt:120], [NSNumber numberWithInt:-1]
#define K_STO			[NSNumber numberWithInt:200], [NSNumber numberWithInt:-1]
#define K_RCL			[NSNumber numberWithInt:136], [NSNumber numberWithInt:-1]
#define K_ENTER			[NSNumber numberWithInt:132], [NSNumber numberWithInt:-1]
#define K_0				[NSNumber numberWithInt:197], [NSNumber numberWithInt:-1]
#define K_DECIMAL		[NSNumber numberWithInt:117], [NSNumber numberWithInt:-1]
#define K_SIG_PLUS		[NSNumber numberWithInt:53],  [NSNumber numberWithInt:-1]
#define K_PLUS			[NSNumber numberWithInt:21],  [NSNumber numberWithInt:-1]

#define K_FRAC			K_F, K_STO
#define K_USER			K_F, K_RCL
#define K_RAND			K_F, K_ENTER
#define K_FACT			K_F, K_0
#define K_YHAT_R		K_F, K_DECIMAL
#define K_LR			K_F, K_SIG_PLUS
#define K_P_Y_X			K_F, K_PLUS

#define K_INT			K_G, K_STO
#define K_MEM			K_G, K_RCL
#define K_LAST_X		K_G, K_ENTER
#define K_XBAR			K_G, K_0
#define K_S				K_G, K_DECIMAL
#define K_SIG_MINUS		K_G, K_SIG_PLUS
#define K_C_Y_X			K_G, K_PLUS

//
// Second Row
// 

#define K_R_S			[NSNumber numberWithInt:17],  [NSNumber numberWithInt:-1]
#define K_GSB			[NSNumber numberWithInt:49],  [NSNumber numberWithInt:-1]
#define K_R_DOWN		[NSNumber numberWithInt:113], [NSNumber numberWithInt:-1]
#define K_X_EXCH_Y		[NSNumber numberWithInt:193], [NSNumber numberWithInt:-1]
#define K_DEL			[NSNumber numberWithInt:129], [NSNumber numberWithInt:-1]
#define K_BSP			K_DEL
#define K_1				[NSNumber numberWithInt:196], [NSNumber numberWithInt:-1]
#define K_2				[NSNumber numberWithInt:116], [NSNumber numberWithInt:-1]
#define K_3				[NSNumber numberWithInt:52],  [NSNumber numberWithInt:-1]
#define K_MINUS			[NSNumber numberWithInt:20],  [NSNumber numberWithInt:-1]

#define K_PSE			K_F, K_R_S
#define K_CLR_SIG		K_F, K_GSB
#define K_CLR_PRGM		K_F, K_R_DOWN
#define K_CLR_REG		K_F, K_X_EXCH_Y
#define K_CLR_PREFIX	K_F, K_DEL
#define K_TO_R			K_F, K_1
#define K_TO_HMS		K_F, K_2
#define K_TO_RAD		K_F, K_3
#define K_RE_EXCH_IM	K_F, K_MINUS

#define K_P_R			K_G, K_R_S
#define K_RTN			K_G, K_GSB
#define K_R_UP			K_G, K_R_DOWN
#define K_RND			K_G, K_X_EXCH_Y
#define K_CLR_X			K_G, K_DEL
#define K_TO_P			K_G, K_1
#define K_TO_H			K_G, K_2
#define K_TO_DEG		K_G, K_3
#define K_TEST			K_G, K_MINUS

//
// Third Row
// 

#define K_SST			[NSNumber numberWithInt:16],  [NSNumber numberWithInt:-1]
#define K_GTO			[NSNumber numberWithInt:48],  [NSNumber numberWithInt:-1]
#define K_SIN	  		[NSNumber numberWithInt:112], [NSNumber numberWithInt:-1]
#define K_COS	  		[NSNumber numberWithInt:192], [NSNumber numberWithInt:-1]
#define K_TAN	  		[NSNumber numberWithInt:128], [NSNumber numberWithInt:-1]
#define K_EEX	  		[NSNumber numberWithInt:135], [NSNumber numberWithInt:-1]
#define K_4				[NSNumber numberWithInt:199], [NSNumber numberWithInt:-1]
#define K_5				[NSNumber numberWithInt:119], [NSNumber numberWithInt:-1]
#define K_6				[NSNumber numberWithInt:55],  [NSNumber numberWithInt:-1]
#define K_MULT 			[NSNumber numberWithInt:23],  [NSNumber numberWithInt:-1]

#define K_LBL			K_F, K_SST
#define K_HYP			K_F, K_GTO
#define K_DIM			K_F, K_SIN
#define K_PAREN_I		K_F, K_COS
#define K_I				K_F, K_TAN
#define K_RESULT		K_F, K_EEX
#define K_X_EXCH		K_F, K_4
#define K_DSE			K_F, K_5
#define K_ISG			K_F, K_6
#define K_INTEG_XY		K_F, K_MULT

#define K_BST			K_G, K_SST
#define K_AHYP			K_G, K_GTO
#define K_ASIN			K_G, K_SIN
#define K_ACOS			K_G, K_COS
#define K_ATAN			K_G, K_TAN
#define K_PI			K_G, K_EEX
#define K_SF			K_G, K_4
#define K_CF			K_G, K_5
#define K_F_TEST		K_G, K_6
#define K_X_EQ_0		K_G, K_MULT

//
// Fourth Row
// 
  
#define K_SQRT			[NSNumber numberWithInt:19],  [NSNumber numberWithInt:-1]
#define K_E_X			[NSNumber numberWithInt:51],  [NSNumber numberWithInt:-1]
#define K_10_X			[NSNumber numberWithInt:115], [NSNumber numberWithInt:-1]
#define K_Y_X			[NSNumber numberWithInt:195], [NSNumber numberWithInt:-1]
#define K_1_X			[NSNumber numberWithInt:131], [NSNumber numberWithInt:-1]
#define K_CHS			[NSNumber numberWithInt:130], [NSNumber numberWithInt:-1]
#define K_7				[NSNumber numberWithInt:194], [NSNumber numberWithInt:-1]
#define K_8				[NSNumber numberWithInt:114], [NSNumber numberWithInt:-1]
#define K_9				[NSNumber numberWithInt:50],  [NSNumber numberWithInt:-1]
#define K_DIV			[NSNumber numberWithInt:18],  [NSNumber numberWithInt:-1]

#define K_A				K_F, K_SQRT
#define K_B				K_F, K_E_X
#define K_C				K_F, K_10_X
#define K_D				K_F, K_Y_X
#define K_E				K_F, K_1_X
#define K_MATRIX		K_F, K_CHS
#define K_FIX			K_F, K_7
#define K_SCI			K_F, K_8
#define K_ENG			K_F, K_9
#define K_SOLVE			K_F, K_DIV

#define K_X_2			K_G, K_SQRT
#define K_LN			K_G, K_E_X
#define K_LOG			K_G, K_10_X
#define K_PCT			K_G, K_Y_X
#define K_DELTA_PCT		K_G, K_1_X
#define K_ABS			K_G, K_CHS
#define K_DEG			K_G, K_7
#define K_RAD			K_G, K_8
#define K_GRAD			K_G, K_9
#define K_X_LE_Y		K_G, K_DIV
