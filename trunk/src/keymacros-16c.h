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
#define K_CHS			[NSNumber numberWithInt:53],  [NSNumber numberWithInt:-1]
#define K_PLUS			[NSNumber numberWithInt:21],  [NSNumber numberWithInt:-1]

#define K_WSIZE			K_F, K_STO
#define K_FLOAT			K_F, K_RCL
#define K_WINDOW		K_F, K_ENTER
#define K_MEM			K_F, K_0
#define K_STATUS		K_F, K_DECIMAL
#define K_EEX			K_F, K_CHS
#define K_OR			K_F, K_PLUS

#define K_LT			K_G, K_STO
#define K_GT			K_G, K_RCL
#define K_LAST_X		K_G, K_ENTER
#define K_X_NE_Y		K_G, K_0
#define K_X_NE_0		K_G, K_DECIMAL
#define K_X_EQ_Y		K_G, K_CHS
#define K_X_EQ_0		K_G, K_PLUS

//
// Second Row
// 

#define K_R_S			[NSNumber numberWithInt:17],  [NSNumber numberWithInt:-1]
#define K_SST			[NSNumber numberWithInt:49],  [NSNumber numberWithInt:-1]
#define K_R_DOWN		[NSNumber numberWithInt:113], [NSNumber numberWithInt:-1]
#define K_X_EXCH_Y		[NSNumber numberWithInt:193], [NSNumber numberWithInt:-1]
#define K_DEL			[NSNumber numberWithInt:129], [NSNumber numberWithInt:-1]
#define K_BSP			K_DEL
#define K_1				[NSNumber numberWithInt:196], [NSNumber numberWithInt:-1]
#define K_2				[NSNumber numberWithInt:116], [NSNumber numberWithInt:-1]
#define K_3				[NSNumber numberWithInt:52],  [NSNumber numberWithInt:-1]
#define K_MINUS			[NSNumber numberWithInt:20],  [NSNumber numberWithInt:-1]

#define K_PAREN_I		K_F, K_R_S
#define K_I				K_F, K_SST
#define K_CLR_PRGM		K_F, K_R_DOWN
#define K_CLR_REG		K_F, K_X_EXCH_Y
#define K_CLR_PREFIX	K_F, K_BSP
#define K_1S_COMPL		K_F, K_1
#define K_2S_COMPL		K_F, K_2
#define K_UNSGN			K_F, K_3
#define K_NOT			K_F, K_MINUS

#define K_P_R			K_G, K_R_S
#define K_BST			K_G, K_SST
#define K_R_UP			K_G, K_R_DOWN
#define K_PSE			K_G, K_X_EXCH_Y
#define K_CLR_X			K_G, K_BSP
#define K_X_LE_Y		K_G, K_1
#define K_X_LT_0		K_G, K_2
#define K_X_GT_Y		K_G, K_3
#define K_X_GT_0		K_G, K_MINUS

//
// Third Row
// 

#define K_GSB			[NSNumber numberWithInt:16],  [NSNumber numberWithInt:-1]
#define K_GTO			[NSNumber numberWithInt:48],  [NSNumber numberWithInt:-1]
#define K_HEX	  		[NSNumber numberWithInt:112], [NSNumber numberWithInt:-1]
#define K_DEC	  		[NSNumber numberWithInt:192], [NSNumber numberWithInt:-1]
#define K_OCT	  		[NSNumber numberWithInt:128], [NSNumber numberWithInt:-1]
#define K_BIN	  		[NSNumber numberWithInt:135], [NSNumber numberWithInt:-1]
#define K_4				[NSNumber numberWithInt:199], [NSNumber numberWithInt:-1]
#define K_5				[NSNumber numberWithInt:119], [NSNumber numberWithInt:-1]
#define K_6				[NSNumber numberWithInt:55],  [NSNumber numberWithInt:-1]
#define K_MULT 			[NSNumber numberWithInt:23],  [NSNumber numberWithInt:-1]

#define K_X_EXCH_PAREN_I	K_F, K_GSB
#define K_X_EXCH_I		K_F, K_GTO
#define K_SB			K_F, K_4
#define K_CB			K_F, K_5
#define K_B_TEST		K_F, K_6
#define K_AND			K_F, K_MULT

#define K_RTN			K_G, K_GSB
#define K_LBL			K_G, K_GTO
#define K_DSZ			K_G, K_HEX
#define K_ISZ			K_G, K_DEC
#define K_SQRT			K_G, K_OCT
#define K_1_X			K_G, K_BIN
#define K_SF			K_G, K_4
#define K_CF			K_G, K_5
#define K_F_TEST		K_G, K_6
#define K_DBL_MULT		K_G, K_MULT

//
// Fourth Row
// 
  
#define K_AH			[NSNumber numberWithInt:19],  [NSNumber numberWithInt:-1]
#define K_BH			[NSNumber numberWithInt:51],  [NSNumber numberWithInt:-1]
#define K_CH			[NSNumber numberWithInt:115], [NSNumber numberWithInt:-1]
#define K_DH			[NSNumber numberWithInt:195], [NSNumber numberWithInt:-1]
#define K_EH			[NSNumber numberWithInt:131], [NSNumber numberWithInt:-1]
#define K_FH			[NSNumber numberWithInt:130], [NSNumber numberWithInt:-1]
#define K_7				[NSNumber numberWithInt:194], [NSNumber numberWithInt:-1]
#define K_8				[NSNumber numberWithInt:114], [NSNumber numberWithInt:-1]
#define K_9				[NSNumber numberWithInt:50],  [NSNumber numberWithInt:-1]
#define K_DIV			[NSNumber numberWithInt:18],  [NSNumber numberWithInt:-1]

#define K_SL			K_F, K_AH
#define K_SR			K_F, K_BH
#define K_RL			K_F, K_CH
#define K_RR			K_F, K_DH
#define K_RLN			K_F, K_EH
#define K_RRB			K_F, K_FH
#define K_MASKL			K_F, K_7
#define K_MASKR			K_F, K_8
#define K_RMD			K_F, K_9
#define K_XOR			K_F, K_DIV

#define K_LJ			K_G, K_AH
#define K_ASR			K_G, K_BH
#define K_RLC			K_G, K_CH
#define K_RRC			K_G, K_DH
#define K_RLCN			K_G, K_EH
#define K_RRCN			K_G, K_FH
#define K_NUM_B			K_G, K_7
#define K_ABS			K_G, K_8
#define K_DBLR			K_G, K_9
#define K_DBL_DIV		K_G, K_DIV
