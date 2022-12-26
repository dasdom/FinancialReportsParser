//  Created by Dominik Hauser on 24.12.22.
//

#import "AppDelegate.h"
#import "DDHMonthsOverviewWindowController.h"

@interface AppDelegate ()
@property (strong) DDHMonthsOverviewWindowController *monthsOverviewWindowController;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  DDHMonthsOverviewWindowController *monthsOverviewWindowController = [[DDHMonthsOverviewWindowController alloc] init];
  [monthsOverviewWindowController showWindow:self];
  [self setMonthsOverviewWindowController:monthsOverviewWindowController];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
  // Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
  return YES;
}


@end
