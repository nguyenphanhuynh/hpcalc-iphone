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
#import "hpcalc.h"
#import "DisplayView.h"

@implementation HPCalc

- (id) init {
	self = [super init];
	
	_display = NULL;
	_displayPaused = NO;
	_cycles = 0;
	
	[self initKeystrokeDict];

#ifdef HP15C           
	nv = nut_new_processor(80, NULL);
#else  
	nv = nut_new_processor(40, NULL);
#endif	

	NSString *objFile = [NSString stringWithFormat:@"/Applications/%s.app/%s.obj", APPNAME, MODEL];
	nut_read_object_file(nv, [objFile cString]);
	
	keyQueue = [[NSMutableArray alloc] init];
	
	BOOL isDir;
    if ( ! [[NSFileManager defaultManager] fileExistsAtPath:[@"~/Library/net.fors.iphone.hpcalc" stringByExpandingTildeInPath] isDirectory:&isDir]) {
		NSLog(@"Creating ~/Library/net.fors.iphone.hpcalc");
     	[[NSFileManager defaultManager] createDirectoryAtPath:[@"~/Library/net.fors.iphone.hpcalc" stringByExpandingTildeInPath] attributes:nil];
	    if ( ! [[NSFileManager defaultManager] fileExistsAtPath:[@CFGPATH stringByExpandingTildeInPath] isDirectory:&isDir]) {
			NSLog(@"Creating %s", CFGPATH);
	     	[[NSFileManager defaultManager] createDirectoryAtPath:[@CFGPATH stringByExpandingTildeInPath] attributes:nil];
		}
    }

	if ( ! [self loadState] ) {
		[self processKeypress:24];  // auto on
		[self processKeypress:-1];
		[self processKeypress:129]; // clear Pr Error
		[self processKeypress:-1];
	} else {
		[self processKeypress:24];  // auto on
		[self processKeypress:-1];
		[self processKeypress:24];  // auto on
		[self processKeypress:-1];
	}
	
	[NSThread detachNewThreadSelector:@selector(tick) toTarget:self withObject:nil];
	
	return self;
}

- (id) initWithDisplay: (DisplayView *) dv {
	[self init];
	_display = dv;
	nv->display = dv;
	
	return self;
}

- (void) shutdown {
	[self saveState];
}

- (void) saveState {
	NSString *name = [NSString stringWithFormat:[@"~/Library/net.fors.iphone.hpcalc/%s/state" stringByExpandingTildeInPath], MODEL];
	FILE *fp = fopen([name cStringUsingEncoding:NSASCIIStringEncoding], "wb");
	fwrite(&(nv->a), sizeof(reg_t), 1, fp);
	fwrite(&(nv->b), sizeof(reg_t), 1, fp);
	fwrite(&(nv->c), sizeof(reg_t), 1, fp);
	fwrite(&(nv->m), sizeof(reg_t), 1, fp);
	fwrite(&(nv->n), sizeof(reg_t), 1, fp);
	fwrite(&(nv->g), sizeof(digit_t), 2, fp);
	fwrite(&(nv->q_sel), sizeof(bool), 1, fp);
	fwrite(&(nv->fo), sizeof(uint8_t), 1, fp);
	fwrite(&(nv->decimal), sizeof(bool), 1, fp);
	fwrite(&(nv->carry), sizeof(bool), 1, fp);
	fwrite(&(nv->prev_carry), sizeof(bool), 1, fp);
	fwrite(&(nv->prev_tef_last), sizeof(int), 1, fp);
	fwrite(&(nv->s), sizeof(bool), SSIZE, fp);
	fwrite(&(nv->pc), sizeof(rom_addr_t), 1, fp);
	fwrite(&(nv->prev_pc), sizeof(rom_addr_t), 1, fp);
	fwrite(&(nv->stack), sizeof(rom_addr_t), STACK_DEPTH, fp);
	fwrite(&(nv->cxisa_addr), sizeof(rom_addr_t), 1, fp);
	fwrite(&(nv->inst_state), sizeof(inst_state_t), 1, fp);
	fwrite(&(nv->first_word), sizeof(rom_word_t), 1, fp);
	fwrite(&(nv->long_branch_carry), sizeof(bool), 1, fp);
	fwrite(&(nv->key_down), sizeof(bool), 1, fp);
	fwrite(&(nv->kb_state), sizeof(keyboard_state_t), 1, fp);
	fwrite(&(nv->kb_debounce_cycle_counter), sizeof(int), 1, fp);
	fwrite(&(nv->key_buf), sizeof(int), 1, fp);
	fwrite(&(nv->awake), sizeof(bool), 1, fp);
	fwrite(&(nv->bank_group), sizeof(int), MAX_PAGE, fp);
	fwrite(&(nv->active_bank), sizeof(uint8_t), MAX_PAGE, fp);
	fwrite(&(nv->ram_addr), sizeof(uint16_t), 1, fp);
	fwrite(&(nv->max_pf), sizeof(uint16_t), 1, fp);
	fwrite(&(nv->pf_addr), sizeof(uint8_t), 1, fp);
	fwrite(&(nv->ext_flag), sizeof(bool), EXT_FLAG_SIZE, fp);
	fwrite(&(nv->selprf), sizeof(uint8_t), 1, fp);
	fwrite(&(nv->display_digits), sizeof(int), 1, fp);
	fwrite(&(nv->display_segments), sizeof(segment_bitmap_t), MAX_DIGIT_POSITION, fp);
	fwrite(&(nv->cycle_count), sizeof(uint64_t), 1, fp);
	fwrite(&(nv->max_ram), sizeof(uint16_t), 1, fp);
	fwrite(&(nv->max_rom), sizeof(int), 1, fp);
	fwrite(&(nv->max_bank), sizeof(int), 1, fp);
	fwrite(nv->ram, sizeof(reg_t), 1024, fp);
	fwrite(nv->pf_exists, sizeof(bool), 256, fp);
	fclose(fp);
}

- (bool) loadState {
	NSString *name = [NSString stringWithFormat:[@"~/Library/net.fors.iphone.hpcalc/%s/state" stringByExpandingTildeInPath], MODEL];
	FILE *fp = fopen([name cStringUsingEncoding:NSASCIIStringEncoding], "rb");
	
	if (!fp) {
		return NO;
	}
	
	fread(&(nv->a), sizeof(reg_t), 1, fp);
	fread(&(nv->b), sizeof(reg_t), 1, fp);
	fread(&(nv->c), sizeof(reg_t), 1, fp);
	fread(&(nv->m), sizeof(reg_t), 1, fp);
	fread(&(nv->n), sizeof(reg_t), 1, fp);
	fread(&(nv->g), sizeof(digit_t), 2, fp);
	fread(&(nv->q_sel), sizeof(bool), 1, fp);
	fread(&(nv->fo), sizeof(uint8_t), 1, fp);
	fread(&(nv->decimal), sizeof(bool), 1, fp);
	fread(&(nv->carry), sizeof(bool), 1, fp);
	fread(&(nv->prev_carry), sizeof(bool), 1, fp);
	fread(&(nv->prev_tef_last), sizeof(int), 1, fp);
	fread(&(nv->s), sizeof(bool), SSIZE, fp);
	fread(&(nv->pc), sizeof(rom_addr_t), 1, fp);
	fread(&(nv->prev_pc), sizeof(rom_addr_t), 1, fp);
	fread(&(nv->stack), sizeof(rom_addr_t), STACK_DEPTH, fp);
	fread(&(nv->cxisa_addr), sizeof(rom_addr_t), 1, fp);
	fread(&(nv->inst_state), sizeof(inst_state_t), 1, fp);
	fread(&(nv->first_word), sizeof(rom_word_t), 1, fp);
	fread(&(nv->long_branch_carry), sizeof(bool), 1, fp);
	fread(&(nv->key_down), sizeof(bool), 1, fp);
	fread(&(nv->kb_state), sizeof(keyboard_state_t), 1, fp);
	fread(&(nv->kb_debounce_cycle_counter), sizeof(int), 1, fp);
	fread(&(nv->key_buf), sizeof(int), 1, fp);
	fread(&(nv->awake), sizeof(bool), 1, fp);
	fread(&(nv->bank_group), sizeof(int), MAX_PAGE, fp);
	fread(&(nv->active_bank), sizeof(uint8_t), MAX_PAGE, fp);
	fread(&(nv->ram_addr), sizeof(uint16_t), 1, fp);
	fread(&(nv->max_pf), sizeof(uint16_t), 1, fp);
	fread(&(nv->pf_addr), sizeof(uint8_t), 1, fp);
	fread(&(nv->ext_flag), sizeof(bool), EXT_FLAG_SIZE, fp);
	fread(&(nv->selprf), sizeof(uint8_t), 1, fp);
	fread(&(nv->display_digits), sizeof(int), 1, fp);
	fread(&(nv->display_segments), sizeof(segment_bitmap_t), MAX_DIGIT_POSITION, fp);
	fread(&(nv->cycle_count), sizeof(uint64_t), 1, fp);
	fread(&(nv->max_ram), sizeof(uint16_t), 1, fp);
	fread(&(nv->max_rom), sizeof(int), 1, fp);
	fread(&(nv->max_bank), sizeof(int), 1, fp);
	fread(nv->ram, sizeof(reg_t), 1024, fp);
	fread(nv->pf_exists, sizeof(bool), 256, fp);
	fclose(fp);    
	
	return YES;
}

- (void) processKeypress: (int) code {
	[keyQueue insertObject:[NSNumber numberWithInt:code] atIndex:0];
}

- (void) playMacro: (NSArray *) macro {
	NSEnumerator *enumerator = [macro objectEnumerator];
	id keystroke;

	if (_display) {
		[_display pauseDisplay:YES];
	} else {
		_displayPaused = YES;
	}
	while (keystroke = [enumerator nextObject]) {
		[self processKeypress:[keystroke intValue]];
	}
	_macroInProgress = true;
}

- (void) computeMacro: (NSArray *) macro {
	NSString *disp;
	int i, workingChars, ignoreChars, otherChars;
	
	[self playMacro:macro];
		
	// wait for computation to complete
	bool done = NO;
	do {
		[NSThread sleepForTimeInterval:0.05];
		disp = [self getDisplayString];
		workingChars = ignoreChars = otherChars = 0;
		if ([disp length] >= 15) {
			for (i=0; i<[disp length]; i++) {
				switch ([disp characterAtIndex:i]) {
					case 'R' :
					case 'u' :
					case 'n' :
					case 'i' :
						workingChars++;
						break;
					case ' ' :
						ignoreChars++;
						break;
					default:
						otherChars++;
						break;
				}
			}
		}
		if ([self keyBufferIsEmpty] && workingChars <= 3 && otherChars > 0) {
			done = YES;
		}
		// NSLog(@"|%@|", disp);
	} while ( ! done);
			
	// NSLog(@" + %@", [self getDisplayString]);
}

- (void) computeFromString:(NSString *) str {
	int i;
	NSMutableArray *keystrokes = [[NSMutableArray alloc] init];
	unsigned long long waitCycles = 500;

	NSArray *tokens = [[str lowercaseString] componentsSeparatedByString:@" "];
	
	NSEnumerator *enumerator = [tokens objectEnumerator];
	id token;
	while (token = [enumerator nextObject]) {
		bool isNumeric = YES;
		for (i=0; i<[token length]; i++) {
			switch ([token characterAtIndex:i]) {
				case '0':
				case '1':
				case '2':
				case '3':
				case '4':
				case '5':
				case '6':
				case '7':
				case '8':
				case '9':
				case '-':
				case '.':
				case 'e':
					break;
				default:
					isNumeric = NO;
					break;
			}
		}

		if ([token length] == 1)
			isNumeric = NO;
		
		if (isNumeric) {
			// terminate digit entry
			[keystrokes addObjectsFromArray:[_keystrokeDictionary objectForKey:@"x<>y"]];
			[keystrokes addObjectsFromArray:[_keystrokeDictionary objectForKey:@"x<>y"]];
			
			bool neg = NO;
			int mantissaLen = 0;
			int expLen = 0;
			bool inExp = NO;
			for (i=0; i<[token length]; i++) {
				switch ([token characterAtIndex:i]) {
					case '0':
					case '1':
					case '2':
					case '3':
					case '4':
					case '5':
					case '6':
					case '7':
					case '8':
					case '9':
						[keystrokes addObjectsFromArray:[_keystrokeDictionary objectForKey:[NSString stringWithFormat:@"%c", [token characterAtIndex:i]]]];
						if (!inExp) mantissaLen++; else expLen++;
						break;
					case '-':
						if ( (!inExp && mantissaLen==0) || (inExp && expLen==0) )
							neg = YES;
						break;
					case '.':
						if ( ! inExp)
							[keystrokes addObjectsFromArray:[_keystrokeDictionary objectForKey:@"."]];
						break;
					case 'e':
						if (neg) {
							[keystrokes addObjectsFromArray:[_keystrokeDictionary objectForKey:@"chs"]];
							neg = NO;
						}
						[keystrokes addObjectsFromArray:[NSArray arrayWithObjects:K_EEX, nil]];
						inExp = YES;
						break;
					default:
						break;
				}
			}
			if (neg) {
				[keystrokes addObjectsFromArray:[_keystrokeDictionary objectForKey:@"chs"]];
			}
			
			// terminate digit entry
			[keystrokes addObjectsFromArray:[_keystrokeDictionary objectForKey:@"x<>y"]];
			[keystrokes addObjectsFromArray:[_keystrokeDictionary objectForKey:@"x<>y"]];
		} else {
			if ([token isEqualToString:@"wait"]) {
				[NSThread sleepForTimeInterval:1.0];
			} else {
				[keystrokes addObjectsFromArray:[_keystrokeDictionary objectForKey:token]];
				[self computeMacro:keystrokes];
				[keystrokes removeAllObjects];
			}
		}
	}

	if ([keystrokes count]) {
		[self computeMacro:keystrokes];
		[keystrokes removeAllObjects];
	}
	
	unsigned long long cycles = [self cpuCycles];
	while ( [self cpuCycles] - cycles < waitCycles ) {
		// wait for final display update to complete
		[NSThread sleepForTimeInterval:0.1];
	}
	
}

- (bool) keyBufferIsEmpty {
	return ([keyQueue count] > 0 ? NO : YES);
}

- (void) tick {
    NSAutoreleasePool* p = [[NSAutoreleasePool alloc] init];
	           
	[NSThread setThreadPriority:0.25];
	int n=0;
	while (1) {
		[NSThread sleepForTimeInterval:0.05];
		if (_display) {
			[self performSelectorOnMainThread:@selector(readKeys) withObject:nil waitUntilDone:YES];
			[self performSelectorOnMainThread:@selector(executeCycle) withObject:nil waitUntilDone:YES];
			if (n++ % 2 == 0) {
				[self performSelectorOnMainThread:@selector(updateDisplay) withObject:nil waitUntilDone:YES];
			}
		} else {
			[self readKeys];
			[self executeCycle];
			if (n++ % 2 == 0) {
				[self updateDisplay];
			}
		}
	}
	
	[p release];
}

- (void) updateDisplay {
	display_callback(nv);		
}

- (id) getDisplayString {
	int i;
	NSMutableString * disp = [[NSMutableString alloc] init];
	
	for (i=0; i<MAX_DIGIT_POSITION; i++) {
		switch (nv->display_segments[i] & 127) {
			case 64:	[disp appendString:@"-"]; break;
			case 63:	[disp appendString:@"0"]; break;
			case 6:		[disp appendString:@"1"]; break;
			case 91:	[disp appendString:@"2"]; break;
			case 79:	[disp appendString:@"3"]; break;
			case 102:	[disp appendString:@"4"]; break;
			case 109:	[disp appendString:@"5"]; break;
			case 125:	[disp appendString:@"6"]; break;
			case 7:		[disp appendString:@"7"]; break;
			case 127:	[disp appendString:@"8"]; break;
			case 111:	[disp appendString:@"9"]; break;
			case 115:	[disp appendString:@"P"]; break;
			case 121:	[disp appendString:@"E"]; break;
			case 2:		[disp appendString:@"i"]; break;
			case 35:	[disp appendString:@"n"]; break;
			case 92:	[disp appendString:@"O"]; break;
			case 80:	[disp appendString:@"R"]; break;
			case 33:	[disp appendString:@"r"]; break;
			case 98:	[disp appendString:@"u"]; break;
			case 124:	[disp appendString:@"b"]; break;
			case 94:	[disp appendString:@"d"]; break;
			case 116:	[disp appendString:@"h"]; break;
			case 119:	[disp appendString:@"A"]; break;
			case 57:	[disp appendString:@"C"]; break;
			case 113:	[disp appendString:@"F"]; break;
			case 0:		[disp appendString:@" "]; break;
			default:	
				break;
		}
		if (nv->display_segments[i] & 256) {
			[disp appendString:@","]; 
		} else if (nv->display_segments[i] & 128) {
			[disp appendString:@"."]; 
		}
	}

	return disp;
}

- (void) executeCycle {
	int i=500;
	while (i-- > 0) {
		nut_execute_instruction(nv);
		_cycles++;
	}
}

- (unsigned long long) cpuCycles {
	return _cycles;
}

- (void) readKeys {
	static int delay = 0;
	int key;
	
	if ([keyQueue count] == 0 && _macroInProgress) {
		if (_display) {
			[_display pauseDisplay:NO];
		} else {
			_displayPaused = NO;
		}
		_macroInProgress = false;
	}
	        
	if (delay) {
		delay--;
	} else {
		if ([keyQueue lastObject]) {
			key = [[keyQueue lastObject] intValue];
			[keyQueue removeLastObject];
			if (key >= 0) {
				nut_press_key(nv, key);
			} else {
				nut_release_key(nv);
			}
			
			if (key == -1) {
				if ([keyQueue lastObject]) {
					key = [[keyQueue lastObject] intValue];
					[keyQueue removeLastObject];
					if (key >= 0) {
						nut_press_key(nv, key);
					} else {
						nut_release_key(nv);
					}
					delay = 1;
				}
			}
		}
	}
}

- (void) initKeystrokeDict {
	NSMutableDictionary *kd = [[NSMutableDictionary alloc] init];

	//
	// Row 4
	//
	
	[kd setObject:[NSArray arrayWithObjects:K_SQRT, nil] forKey:@"sqrt"];
#ifndef HP12C
#ifndef HP16C
	[kd setObject:[NSArray arrayWithObjects:K_A, nil] forKey:@"a"];
	[kd setObject:[NSArray arrayWithObjects:K_X_2, nil] forKey:@"x^2"];
#endif
#endif

#ifndef HP16C
	[kd setObject:[NSArray arrayWithObjects:K_E_X, nil] forKey:@"e^x"];
#ifndef HP12C
	[kd setObject:[NSArray arrayWithObjects:K_B, nil] forKey:@"b"];
#endif
	[kd setObject:[NSArray arrayWithObjects:K_LN, nil] forKey:@"ln"];
#endif

#ifndef HP12C
#ifndef HP16C
	[kd setObject:[NSArray arrayWithObjects:K_10_X, nil] forKey:@"10^x"];
	[kd setObject:[NSArray arrayWithObjects:K_C, nil] forKey:@"c"];
	[kd setObject:[NSArray arrayWithObjects:K_LOG, nil] forKey:@"log"];
#endif
#endif

#ifndef HP16C
	[kd setObject:[NSArray arrayWithObjects:K_Y_X, nil] forKey:@"y^x"];
#ifndef HP12C
	[kd setObject:[NSArray arrayWithObjects:K_D, nil] forKey:@"d"];
#endif
	[kd setObject:[NSArray arrayWithObjects:K_PCT, nil] forKey:@"%"];
#endif

	[kd setObject:[NSArray arrayWithObjects:K_1_X, nil] forKey:@"1/x"];
#ifndef HP16C
#ifndef HP12C
	[kd setObject:[NSArray arrayWithObjects:K_E, nil] forKey:@"e"];
#endif
	[kd setObject:[NSArray arrayWithObjects:K_DELTA_PCT, nil] forKey:@"delta%"];
#endif

	[kd setObject:[NSArray arrayWithObjects:K_CHS, nil] forKey:@"chs"];
#ifdef HP15C	
	[kd setObject:[NSArray arrayWithObjects:K_MATRIX, nil] forKey:@"matrix"];
#endif
#ifndef HP12C
	[kd setObject:[NSArray arrayWithObjects:K_ABS, nil] forKey:@"abs"];
#endif

	[kd setObject:[NSArray arrayWithObjects:K_7, nil] forKey:@"7"];
#ifndef HP12C
#ifndef HP16C
	[kd setObject:[NSArray arrayWithObjects:K_FIX, nil] forKey:@"fix"];
	[kd setObject:[NSArray arrayWithObjects:K_DEG, nil] forKey:@"deg"];
#endif
#endif

	[kd setObject:[NSArray arrayWithObjects:K_8, nil] forKey:@"8"];
#ifndef HP12C
#ifndef HP16C
	[kd setObject:[NSArray arrayWithObjects:K_SCI, nil] forKey:@"sci"];
	[kd setObject:[NSArray arrayWithObjects:K_RAD, nil] forKey:@"rad"];
#endif
#endif

	[kd setObject:[NSArray arrayWithObjects:K_9, nil] forKey:@"9"];
#ifndef HP12C
#ifndef HP16C
	[kd setObject:[NSArray arrayWithObjects:K_ENG, nil] forKey:@"eng"];
	[kd setObject:[NSArray arrayWithObjects:K_GRAD, nil] forKey:@"grad"];
	[kd setObject:[NSArray arrayWithObjects:K_GRAD, nil] forKey:@"grd"];
#endif
#endif

	[kd setObject:[NSArray arrayWithObjects:K_DIV, nil] forKey:@"/"];
	[kd setObject:[NSArray arrayWithObjects:K_DIV, nil] forKey:@"div"];
	[kd setObject:[NSArray arrayWithObjects:K_DIV, nil] forKey:@"divide"];
#ifdef HP15C	
	[kd setObject:[NSArray arrayWithObjects:K_SOLVE, nil] forKey:@"solve"];
#endif	
	[kd setObject:[NSArray arrayWithObjects:K_X_LE_Y, nil] forKey:@"x<=y"];

	//
	// Row 3
	//

	[kd setObject:[NSArray arrayWithObjects:K_SST, nil] forKey:@"sst"];
#ifndef HP12C
	[kd setObject:[NSArray arrayWithObjects:K_LBL, nil] forKey:@"lbl"];
#endif
	[kd setObject:[NSArray arrayWithObjects:K_BST, nil] forKey:@"bst"];

	[kd setObject:[NSArray arrayWithObjects:K_GTO, nil] forKey:@"gto"];
#ifndef HP12C
#ifndef HP16C
	[kd setObject:[NSArray arrayWithObjects:K_HYP, nil] forKey:@"hyp"];
	[kd setObject:[NSArray arrayWithObjects:K_AHYP, nil] forKey:@"hyp-1"];
	[kd setObject:[NSArray arrayWithObjects:K_AHYP, nil] forKey:@"ahyp"];
#endif
#endif
	
#ifndef HP12C
#ifndef HP16C
	[kd setObject:[NSArray arrayWithObjects:K_SIN, nil] forKey:@"sin"];
#ifdef HP15C	
	[kd setObject:[NSArray arrayWithObjects:K_DIM, nil] forKey:@"dim"];
#endif	
	[kd setObject:[NSArray arrayWithObjects:K_ASIN, nil] forKey:@"sin-1"];
	[kd setObject:[NSArray arrayWithObjects:K_ASIN, nil] forKey:@"asin"];

	[kd setObject:[NSArray arrayWithObjects:K_COS, nil] forKey:@"cos"];
	[kd setObject:[NSArray arrayWithObjects:K_ACOS, nil] forKey:@"cos-1"];
	[kd setObject:[NSArray arrayWithObjects:K_ACOS, nil] forKey:@"acos"];

	[kd setObject:[NSArray arrayWithObjects:K_TAN, nil] forKey:@"tan"];
	[kd setObject:[NSArray arrayWithObjects:K_ATAN, nil] forKey:@"tan-1"];
	[kd setObject:[NSArray arrayWithObjects:K_ATAN, nil] forKey:@"atan"];
#endif
	[kd setObject:[NSArray arrayWithObjects:K_I, nil] forKey:@"i"];
	[kd setObject:[NSArray arrayWithObjects:K_PAREN_I, nil] forKey:@"(i)"];
#endif
	
	[kd setObject:[NSArray arrayWithObjects:K_EEX, nil] forKey:@"eex"];
#ifdef HP15C	
	[kd setObject:[NSArray arrayWithObjects:K_RESULT, nil] forKey:@"result"];
#endif
#ifndef HP12C
#ifndef HP16C
	[kd setObject:[NSArray arrayWithObjects:K_PI, nil] forKey:@"pi"];
#endif
#endif
	
	[kd setObject:[NSArray arrayWithObjects:K_4, nil] forKey:@"4"];
#ifdef HP15C	
	[kd setObject:[NSArray arrayWithObjects:K_X_EXCH, nil] forKey:@"x<>"];
#endif
#ifndef HP12C
	[kd setObject:[NSArray arrayWithObjects:K_SF, nil] forKey:@"sf"];
#endif

	[kd setObject:[NSArray arrayWithObjects:K_5, nil] forKey:@"5"];
#ifndef HP12C
#ifndef HP16C
	[kd setObject:[NSArray arrayWithObjects:K_DSE, nil] forKey:@"dse"];
#endif
	[kd setObject:[NSArray arrayWithObjects:K_CF, nil] forKey:@"cf"];
#endif

	[kd setObject:[NSArray arrayWithObjects:K_6, nil] forKey:@"6"];
#ifndef HP12C
#ifndef HP16C
	[kd setObject:[NSArray arrayWithObjects:K_ISG, nil] forKey:@"isg"];
#endif
	[kd setObject:[NSArray arrayWithObjects:K_F_TEST, nil] forKey:@"f?"];
#endif

	[kd setObject:[NSArray arrayWithObjects:K_MULT, nil] forKey:@"*"];
	[kd setObject:[NSArray arrayWithObjects:K_MULT, nil] forKey:@"mult"];
	[kd setObject:[NSArray arrayWithObjects:K_MULT, nil] forKey:@"multiply"];
	[kd setObject:[NSArray arrayWithObjects:K_MULT, nil] forKey:@"product"];
#ifdef HP15C	
	[kd setObject:[NSArray arrayWithObjects:K_INTEG_XY, nil] forKey:@"integrate"];
#endif
	[kd setObject:[NSArray arrayWithObjects:K_X_EQ_0, nil] forKey:@"x=0"];
	[kd setObject:[NSArray arrayWithObjects:K_X_EQ_0, nil] forKey:@"x==0"];

	//
	// Row 2
	//

	[kd setObject:[NSArray arrayWithObjects:K_R_S, nil] forKey:@"r/s"];
	[kd setObject:[NSArray arrayWithObjects:K_PSE, nil] forKey:@"pse"];
	[kd setObject:[NSArray arrayWithObjects:K_P_R, nil] forKey:@"p/r"];

#ifndef HP12C
	[kd setObject:[NSArray arrayWithObjects:K_GSB, nil] forKey:@"gsb"];
#ifndef HP16C
	[kd setObject:[NSArray arrayWithObjects:K_CLR_SIG, nil] forKey:@"clrsigma"];
	[kd setObject:[NSArray arrayWithObjects:K_CLR_SIG, nil] forKey:@"clrsig"];
#endif
	[kd setObject:[NSArray arrayWithObjects:K_RTN, nil] forKey:@"rtn"];
#endif

	[kd setObject:[NSArray arrayWithObjects:K_R_DOWN, nil] forKey:@"rdown"];
	[kd setObject:[NSArray arrayWithObjects:K_CLR_PRGM, nil] forKey:@"clrprgm"];
#ifndef HP12C
	[kd setObject:[NSArray arrayWithObjects:K_R_UP, nil] forKey:@"rup"];
#endif

	[kd setObject:[NSArray arrayWithObjects:K_X_EXCH_Y, nil] forKey:@"x<>y"];
	[kd setObject:[NSArray arrayWithObjects:K_CLR_REG, nil] forKey:@"clrreg"];
#ifndef HP16C
	[kd setObject:[NSArray arrayWithObjects:K_RND, nil] forKey:@"rnd"];
#endif

#ifndef HP12C
	[kd setObject:[NSArray arrayWithObjects:K_DEL, nil] forKey:@"del"];
	[kd setObject:[NSArray arrayWithObjects:K_DEL, nil] forKey:@"bsp"];
#endif
	[kd setObject:[NSArray arrayWithObjects:K_CLR_PREFIX, nil] forKey:@"clrprefix"];
	[kd setObject:[NSArray arrayWithObjects:K_CLR_X, nil] forKey:@"clx"];

	[kd setObject:[NSArray arrayWithObjects:K_1, nil] forKey:@"1"];
#ifndef HP12C
#ifndef HP16C
	[kd setObject:[NSArray arrayWithObjects:K_TO_R, nil] forKey:@"tor"];
	[kd setObject:[NSArray arrayWithObjects:K_TO_P, nil] forKey:@"top"];
#endif
#endif
	[kd setObject:[NSArray arrayWithObjects:K_2, nil] forKey:@"2"];
#ifndef HP12C
#ifndef HP16C
	[kd setObject:[NSArray arrayWithObjects:K_TO_HMS, nil] forKey:@"tohms"];
	[kd setObject:[NSArray arrayWithObjects:K_TO_H, nil] forKey:@"toh"];
#endif
#endif

	[kd setObject:[NSArray arrayWithObjects:K_3, nil] forKey:@"3"];
#ifndef HP12C
#ifndef HP16C
	[kd setObject:[NSArray arrayWithObjects:K_TO_RAD, nil] forKey:@"torad"];
	[kd setObject:[NSArray arrayWithObjects:K_TO_DEG, nil] forKey:@"todeg"];
#endif
#endif

	[kd setObject:[NSArray arrayWithObjects:K_MINUS, nil] forKey:@"-"];
	[kd setObject:[NSArray arrayWithObjects:K_MINUS, nil] forKey:@"minus"];
	[kd setObject:[NSArray arrayWithObjects:K_MINUS, nil] forKey:@"subtract"];
#ifdef HP15C	
	[kd setObject:[NSArray arrayWithObjects:K_RE_EXCH_IM, nil] forKey:@"re<>im"];
	[kd setObject:[NSArray arrayWithObjects:K_TEST, nil] forKey:@"test"];
#endif

	//
	// Row 1
	//
	
	[kd setObject:[NSArray arrayWithObjects:K_ON, nil] forKey:@"on"];

	[kd setObject:[NSArray arrayWithObjects:K_F, nil] forKey:@"f"];
	
	[kd setObject:[NSArray arrayWithObjects:K_G, nil] forKey:@"g"];
	
	[kd setObject:[NSArray arrayWithObjects:K_STO, nil] forKey:@"sto"];
#ifndef HP16C
	[kd setObject:[NSArray arrayWithObjects:K_FRAC, nil] forKey:@"frac"];
	[kd setObject:[NSArray arrayWithObjects:K_INT, nil] forKey:@"int"];
#endif
	
	[kd setObject:[NSArray arrayWithObjects:K_RCL, nil] forKey:@"rcl"];
#ifndef HP12C
#ifndef HP16C
	[kd setObject:[NSArray arrayWithObjects:K_USER, nil] forKey:@"user"];
#endif
#endif
	[kd setObject:[NSArray arrayWithObjects:K_MEM, nil] forKey:@"mem"];
	
	[kd setObject:[NSArray arrayWithObjects:K_ENTER, nil] forKey:@"enter"];
#ifndef HP12C
#ifndef HP16C
	[kd setObject:[NSArray arrayWithObjects:K_RAND, nil] forKey:@"rand"];
	[kd setObject:[NSArray arrayWithObjects:K_RAND, nil] forKey:@"ran#"];
#endif
#endif
	[kd setObject:[NSArray arrayWithObjects:K_LAST_X, nil] forKey:@"lastx"];
	[kd setObject:[NSArray arrayWithObjects:K_LAST_X, nil] forKey:@"lstx"];
	
	[kd setObject:[NSArray arrayWithObjects:K_0, nil] forKey:@"0"];
#ifndef HP16C
	[kd setObject:[NSArray arrayWithObjects:K_FACT, nil] forKey:@"fact"];
	[kd setObject:[NSArray arrayWithObjects:K_FACT, nil] forKey:@"factorial"];
	[kd setObject:[NSArray arrayWithObjects:K_FACT, nil] forKey:@"!"];
	[kd setObject:[NSArray arrayWithObjects:K_XBAR, nil] forKey:@"xbar"];
#endif
	
	[kd setObject:[NSArray arrayWithObjects:K_DECIMAL, nil] forKey:@"."];
#ifndef HP16C
	[kd setObject:[NSArray arrayWithObjects:K_YHAT_R, nil] forKey:@"yhatr"];
	[kd setObject:[NSArray arrayWithObjects:K_YHAT_R, nil] forKey:@"yhat,r"];
	[kd setObject:[NSArray arrayWithObjects:K_S, nil] forKey:@"s"];
#endif
	
#ifndef HP16C
	[kd setObject:[NSArray arrayWithObjects:K_SIG_PLUS, nil] forKey:@"sigmaplus"];
	[kd setObject:[NSArray arrayWithObjects:K_SIG_PLUS, nil] forKey:@"sigma+"];
#ifndef HP12C
	[kd setObject:[NSArray arrayWithObjects:K_LR, nil] forKey:@"lr"];
	[kd setObject:[NSArray arrayWithObjects:K_LR, nil] forKey:@"l.r."];
#endif
	[kd setObject:[NSArray arrayWithObjects:K_SIG_MINUS, nil] forKey:@"sigmaminus"];
	[kd setObject:[NSArray arrayWithObjects:K_SIG_MINUS, nil] forKey:@"sigma-"];
#endif
	
	[kd setObject:[NSArray arrayWithObjects:K_PLUS, nil] forKey:@"+"];
	[kd setObject:[NSArray arrayWithObjects:K_PLUS, nil] forKey:@"add"];
	[kd setObject:[NSArray arrayWithObjects:K_PLUS, nil] forKey:@"sum"];
#ifndef HP12C
#ifndef HP16C
	[kd setObject:[NSArray arrayWithObjects:K_P_Y_X, nil] forKey:@"pyx"];
	[kd setObject:[NSArray arrayWithObjects:K_P_Y_X, nil] forKey:@"py,x"];
	[kd setObject:[NSArray arrayWithObjects:K_P_Y_X, nil] forKey:@"p(y,x)"];
	[kd setObject:[NSArray arrayWithObjects:K_C_Y_X, nil] forKey:@"cyx"];
	[kd setObject:[NSArray arrayWithObjects:K_C_Y_X, nil] forKey:@"cy,x"];
	[kd setObject:[NSArray arrayWithObjects:K_C_Y_X, nil] forKey:@"c(y,x)"];
#endif
#endif

#ifdef HP16C
	[kd setObject:[NSArray arrayWithObjects:K_FLOAT, nil] forKey:@"float"];
#endif
	
	_keystrokeDictionary = [[NSDictionary dictionaryWithDictionary:kd] retain];
}

@end