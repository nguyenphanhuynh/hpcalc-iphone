
#import <Foundation/Foundation.h>

@interface OTUpdateManager : NSObject {
	NSDictionary				* _trustedSource;
	NSDictionary				* _thisPackage;
	NSString					* _prefFolder;
	id							  delegate;
}

- (id) initWithPrefFolder:(id) pf trustedSource:(id) ts thisPackage:(id) tp;
- (void) setDelegate:(id) del;
- (bool) refreshIsNeeded;
- (void) checkForUpdates;
- (bool) updateIsAvailable;
- (bool) update;

@end
