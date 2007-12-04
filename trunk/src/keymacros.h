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

#ifdef HP15C
#include "keymacros-15c.h"
#endif
#ifdef HP12C
#include "keymacros-12c.h"
#endif
#ifdef HP16C
#include "keymacros-16c.h"
#endif
#ifdef HP11C
#include "keymacros-11c.h"
#endif

#define F_0					K_0
#define F_1					K_1
#define F_2					K_2
#define F_3					K_3
#define F_4					K_4
#define F_5					K_5
#define F_6					K_6
#define F_7					K_7
#define F_8					K_8
#define F_9					K_9
#define F_DIV				K_DIV
#define F_MULT				K_MULT
#define F_MINUS				K_MINUS
#define F_PLUS				K_PLUS
#define F_CHS				K_CHS
#define F_EEX				K_EEX
#define F_SQRT				K_SQRT

#ifdef K_X_2
	#define F_X_2				K_X_2
#else
	#ifdef K_Y_X
		#define F_X_2				K_X_EXCH_Y, K_X_EXCH_Y, F_2, K_Y_X
	#else
		#define F_X_2				K_ENTER, K_MULT
	#endif
#endif
