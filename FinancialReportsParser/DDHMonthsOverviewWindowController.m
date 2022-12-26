//  Created by Dominik Hauser on 24.12.22.
//

#import "DDHMonthsOverviewWindowController.h"
#import "DDHMonthsOverviewWindow.h"
#import "DDHMonthData.h"

@interface DDHMonthsOverviewWindowController () <NSTableViewDataSource>
@property (strong) NSArray<DDHMonthData *> *monthDataArray;
@property (strong) NSNumberFormatter *numberFormatter;
@end

@implementation DDHMonthsOverviewWindowController

@synthesize monthDataArray = _monthDataArray;

- (instancetype)init {
  if (self = [super init]) {
    _numberFormatter = [[NSNumberFormatter alloc] init];
    [_numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [_numberFormatter setMinimumFractionDigits:2];

    DDHMonthsOverviewWindow *window = [[DDHMonthsOverviewWindow alloc] initWithContentRect:NSMakeRect(0, 0, 400, 400) styleMask:NSWindowStyleMaskTitled | NSWindowStyleMaskClosable backing:NSBackingStoreBuffered defer:YES];
    
    [window setParseCompletionHandler:^(NSArray<DDHMonthData *> * _Nonnull monthDataArray) {
      [self setMonthDataArray:monthDataArray];
      [[[self contentWindow] tableView] reloadData];
      
    }];
    
    [[window tableView] setDataSource:self];
    [window center];
    [self setWindow:window];
    
  }
  return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (NSArray<DDHMonthData *> *)monthDataArray {
  return _monthDataArray;
}

- (void)setMonthDataArray:(NSArray<DDHMonthData *> *)monthDataArray {
  _monthDataArray = monthDataArray;
  
  __block NSDecimalNumber *sumDecimalNumber = [[NSDecimalNumber alloc] initWithDouble:0.0];
  __block NSString *currentyString = @"";
  [monthDataArray enumerateObjectsUsingBlock:^(DDHMonthData * _Nonnull monthData, NSUInteger idx, BOOL * _Nonnull stop) {
    sumDecimalNumber = [sumDecimalNumber decimalNumberByAdding:(NSDecimalNumber *)[monthData value]];
    currentyString = [monthData currentyString];
  }];
  
  NSString *sumString = [NSString stringWithFormat:@"∑ = %@ %@", [_numberFormatter stringFromNumber:sumDecimalNumber], currentyString];
  [[[self contentWindow] sumTextField] setStringValue:sumString];
}

- (DDHMonthsOverviewWindow *)contentWindow {
  return (DDHMonthsOverviewWindow *)[self window];
}

// MARK: - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
  return [[self monthDataArray] count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  
  DDHMonthData *monthData = [[self monthDataArray] objectAtIndex:row];
  
  if ([[tableColumn identifier] isEqualToString:@"month"]) {
    return [monthData monthName];
  } else {
    return [NSString stringWithFormat:@"%@ %@", [[self numberFormatter] stringFromNumber:monthData.value], monthData.currentyString];
  }
}

@end
