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

#define K_CLR_PREFIX	K_F, K_ENTER

#define K_LAST_X		K_G, K_ENTER
#define K_XBAR			K_G, K_0
#define K_S				K_G, K_DECIMAL
#define K_SIG_MINUS		K_G, K_SIG_PLUS

//
// Second Row
// 

#define K_R_S			[NSNumber numberWithInt:17],  [NSNumber numberWithInt:-1]
#define K_SST			[NSNumber numberWithInt:49],  [NSNumber numberWithInt:-1]
#define K_R_DOWN		[NSNumber numberWithInt:113], [NSNumber numberWithInt:-1]
#define K_X_EXCH_Y		[NSNumber numberWithInt:193], [NSNumber numberWithInt:-1]
#define K_CLX			[NSNumber numberWithInt:129], [NSNumber numberWithInt:-1]
#define K_CLR_X			K_CLX
#define K_1				[NSNumber numberWithInt:196], [NSNumber numberWithInt:-1]
#define K_2				[NSNumber numberWithInt:116], [NSNumber numberWithInt:-1]
#define K_3				[NSNumber numberWithInt:52],  [NSNumber numberWithInt:-1]
#define K_MINUS			[NSNumber numberWithInt:20],  [NSNumber numberWithInt:-1]

#define K_P_R			K_F, K_R_S
#define K_SIG			K_F, K_SST
#define K_CLR_PRGM		K_F, K_R_DOWN
#define K_CLR_FIN		K_F, K_X_EXCH_Y
#define K_CLR_REG		K_F, K_CLX

#define K_PSE			K_G, K_R_S
#define K_BST			K_G, K_SST
#define K_GTO			K_G, K_R_DOWN
#define K_X_LE_Y		K_G, K_X_EXCH_Y
#define K_X_EQ_0		K_G, K_CLX
#define K_XHAT_R		K_G, K_1
#define K_YHAT_R		K_G, K_2
#define K_FACT			K_G, K_3

//
// Third Row
// 

#define K_Y_X			[NSNumber numberWithInt:16],  [NSNumber numberWithInt:-1]
#define K_1_X			[NSNumber numberWithInt:48],  [NSNumber numberWithInt:-1]
#define K_PCT_T	  		[NSNumber numberWithInt:112], [NSNumber numberWithInt:-1]
#define K_DELTA_PCT	  	[NSNumber numberWithInt:192], [NSNumber numberWithInt:-1]
#define K_PCT	  		[NSNumber numberWithInt:128], [NSNumber numberWithInt:-1]
#define K_EEX	  		[NSNumber numberWithInt:135], [NSNumber numberWithInt:-1]
#define K_4				[NSNumber numberWithInt:199], [NSNumber numberWithInt:-1]
#define K_5				[NSNumber numberWithInt:119], [NSNumber numberWithInt:-1]
#define K_6				[NSNumber numberWithInt:55],  [NSNumber numberWithInt:-1]
#define K_MULT 			[NSNumber numberWithInt:23],  [NSNumber numberWithInt:-1]

#define K_FIN_PRICE		K_F, K_Y_X
#define K_FIN_YTM		K_F, K_1_X
#define K_FIN_SL		K_F, K_PCT_T
#define K_FIN_SOYD		K_F, K_DELTA_PCT
#define K_FIN_DB		K_F, K_PCT

#define K_SQRT			K_G, K_Y_X
#define K_E_X			K_G, K_1_X
#define K_LN			K_G, K_PCT_T
#define K_FRAC			K_G, K_DELTA_PCT
#define K_INTG			K_G, K_PCT
#define K_INT			K_INTG
#define K_DELTA_DYS		K_G, K_EEX
#define K_DMY			K_G, K_4
#define K_MDY			K_G, K_5
#define K_XBAR_W		K_G, K_6

//
// Fourth Row
// 
  
#define K_FIN_N			[NSNumber numberWithInt:19],  [NSNumber numberWithInt:-1]
#define K_FIN_I			[NSNumber numberWithInt:51],  [NSNumber numberWithInt:-1]
#define K_FIN_PV		[NSNumber numberWithInt:115], [NSNumber numberWithInt:-1]
#define K_FIN_PMT		[NSNumber numberWithInt:195], [NSNumber numberWithInt:-1]
#define K_FIN_FV		[NSNumber numberWithInt:131], [NSNumber numberWithInt:-1]
#define K_CHS			[NSNumber numberWithInt:130], [NSNumber numberWithInt:-1]
#define K_7				[NSNumber numberWithInt:194], [NSNumber numberWithInt:-1]
#define K_8				[NSNumber numberWithInt:114], [NSNumber numberWithInt:-1]
#define K_9				[NSNumber numberWithInt:50],  [NSNumber numberWithInt:-1]
#define K_DIV			[NSNumber numberWithInt:18],  [NSNumber numberWithInt:-1]

#define K_FIN_AMORT		K_F, K_FIN_N
#define K_FIN_INT		K_F, K_FIN_I
#define K_FIN_NPV		K_F, K_FIN_PV
#define K_RND			K_F, K_FIN_PMT
#define K_FIN_IRR		K_F, K_FIN_FV

#define K_FIN_12_MULT	K_G, K_FIN_N
#define K_FIN_12_DIV	K_G, K_FIN_I
#define K_FIN_CFO		K_G, K_FIN_PV
#define K_FIN_CFJ		K_G, K_FIN_PMT
#define K_FIN_NJ		K_G, K_FIN_FV
#define K_DATE			K_G, K_CHS
#define K_FIN_BEG		K_G, K_7
#define K_FIN_END		K_G, K_8
#define K_MEM			K_G, K_9
