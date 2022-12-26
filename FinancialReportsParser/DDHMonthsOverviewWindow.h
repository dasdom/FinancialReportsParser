//  Created by Dominik Hauser on 24.12.22.
//

#import <Cocoa/Cocoa.h>

@class DDHMonthData;

NS_ASSUME_NONNULL_BEGIN

@interface DDHMonthsOverviewWindow : NSWindow
@property (strong) NSTableView *tableView;
@property (strong) NSTextField *sumTextField;
@property (copy) void (^parseCompletionHandler)(NSArray<DDHMonthData *> *);
@end

NS_ASSUME_NONNULL_END
