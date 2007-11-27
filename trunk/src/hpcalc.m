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

- (void) _updateDisplay {
}


- (id) initWithDisplay: (DisplayView *) dv {
	self = [super init];
	
	_display = dv;
		
	if (strcmp(MODEL, "15c") == 0) {
		nv = nut_new_processor(80, (void *)dv);
	} else {
		nv = nut_new_processor(40, (void *)dv);
	}
	
	NSString *objFile = [NSString stringWithFormat:@"/Applications/%s.app/%s.obj", APPNAME, MODEL];
	nut_read_object_file(nv, [objFile cString]);
	
	keyQueue = [[NSMutableArray alloc] init];
	
	BOOL isDir;
    if ( ! [[NSFileManager defaultManager] fileExistsAtPath:@"/var/root/Library/net.fors.iphone.hpcalc" isDirectory:&isDir]) {
		NSLog(@"Creating /var/root/Library/net.fors.iphone.hpcalc");
     	[[NSFileManager defaultManager] createDirectoryAtPath:@"/var/root/Library/net.fors.iphone.hpcalc" attributes:nil];
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

- (void) shutdown {
	[self saveState];
}

- (void) saveState {
	NSString *name = [NSString stringWithFormat:@"/var/root/Library/net.fors.iphone.hpcalc/%s.state", MODEL];
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
	NSString *name = [NSString stringWithFormat:@"/var/root/Library/net.fors.iphone.hpcalc/%s.state", MODEL];
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

- (void) tick {
    NSAutoreleasePool* p = [[NSAutoreleasePool alloc] init];
	           
	[NSThread setThreadPriority:0.25];
	while (1) {
		[NSThread sleepForTimeInterval:0.05];
		[self performSelectorOnMainThread:@selector(readKeys) withObject:nil waitUntilDone:YES];
		[self performSelectorOnMainThread:@selector(executeCycle) withObject:nil waitUntilDone:YES];
	}
	
	[p release];
}

- (void) executeCycle {
	int i=500;
	while(i-- > 0) {
		nut_execute_instruction(nv);
	}
}

- (void) readKeys {
	static int delay = 0;
	int key;
	        
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
					delay = 2;
				}
			}
		}
	}
}

@end