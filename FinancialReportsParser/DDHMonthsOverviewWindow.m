//  Created by Dominik Hauser on 24.12.22.
//

#import "DDHMonthsOverviewWindow.h"
#import "DDHMonthData.h"

@interface DDHMonthsOverviewWindow () <NSDraggingDestination>

@end

@implementation DDHMonthsOverviewWindow

- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)backingStoreType defer:(BOOL)flag {
  if (self = [super initWithContentRect:contentRect styleMask:style backing:backingStoreType defer:flag]) {
    
    _tableView = [[NSTableView alloc] init];
    
    NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:@"month"];
    [column setTitle:@"Month"];
    [column setWidth:contentRect.size.width*2.0/5.0];
    [_tableView addTableColumn:column];
    
    column = [[NSTableColumn alloc] initWithIdentifier:@"amount"];
    [column setTitle:@"Amount"];
    [_tableView addTableColumn:column];
    
    NSScrollView *scrollView = [[NSScrollView alloc] init];
//    [scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollView setHasVerticalScroller:YES];
    [scrollView setDocumentView:_tableView];
    
    _sumTextField = [[NSTextField alloc] init];
    [_sumTextField setAlignment:NSTextAlignmentCenter];
//    [_sumTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSStackView *stackView = [NSStackView stackViewWithViews:@[scrollView, _sumTextField]];
    [stackView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [stackView setOrientation:NSUserInterfaceLayoutOrientationVertical];
    
    [[self contentView] addSubview:stackView];
    
    [NSLayoutConstraint activateConstraints:@[
      [[stackView topAnchor] constraintEqualToAnchor:[[self contentView] topAnchor]],
      [[stackView leadingAnchor] constraintEqualToAnchor:[[self contentView] leadingAnchor]],
      [[stackView bottomAnchor] constraintEqualToAnchor:[[self contentView] bottomAnchor]],
      [[stackView trailingAnchor] constraintEqualToAnchor:[[self contentView] trailingAnchor]],
    ]];
    
    [self registerForDraggedTypes:@[NSPasteboardTypeFileURL]];
    [self setTitle:@"Sales"];
  }
  return self;
}

// MARK: - NSDraggingDestination
- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
  if ([[sender draggingSource] isEqual:self]) {
    return NSDragOperationNone;
  }
  return [sender draggingSourceOperationMask];
}

- (void)draggingExited:(id<NSDraggingInfo>)sender {
  
}

- (BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender {
  return YES;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
  
  NSPasteboard *pasteboard = [sender draggingPasteboard];
  
  if ([[pasteboard types] containsObject:NSPasteboardTypeFileURL]) {
    NSArray<NSURL *> *fileURLs = [pasteboard readObjectsForClasses:@[[NSURL class]] options:nil];
    
    NSMutableArray<DDHMonthData *> *monthDataArray = [[NSMutableArray alloc] init];
    
    [fileURLs enumerateObjectsUsingBlock:^(NSURL * _Nonnull url, NSUInteger idx, BOOL * _Nonnull stop) {
      NSLog(@"url: %@", url);
      
      NSError *stringCreationError = nil;
      NSString *fileContent = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&stringCreationError];
      if (stringCreationError) {
        NSLog(@"Could not create the content string: %@", stringCreationError);
        return;
      }
      
      __block NSString *monthString;
      __block NSMutableArray<NSString *> *amounts = [[NSMutableArray alloc] init];
      __block NSInteger numberOfEmptyLines = 0;
      __block BOOL lastLineWasEmpty = NO;
      
      NSArray<NSString *> *lines = [fileContent componentsSeparatedByString:@"\n"];
      [lines enumerateObjectsUsingBlock:^(NSString * _Nonnull line, NSUInteger linesIndex, BOOL * _Nonnull linesStop) {
        NSLog(@"idx: %ld: %@", linesIndex, line);
        
        if (linesIndex == 0) {
          NSString *titleBeforeClosingParentheses = [[line componentsSeparatedByString:@")"] objectAtIndex:0];
          monthString = [[titleBeforeClosingParentheses componentsSeparatedByString:@"("] objectAtIndex:1];
        } else {
          NSArray<NSString *> *lineComponents = [line componentsSeparatedByString:@","];
          __block BOOL lineIsEmpty = YES;
          [lineComponents enumerateObjectsUsingBlock:^(NSString * _Nonnull component, NSUInteger componentIndex, BOOL * _Nonnull lineComponentsStop) {
            if ([component length] > 0) {
              lineIsEmpty = NO;
              if (lastLineWasEmpty && numberOfEmptyLines > 1) {
                [amounts addObject:[component stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
              }
              lastLineWasEmpty = NO;
            }
          }];
          if (lineIsEmpty) {
            numberOfEmptyLines += 1;
            lastLineWasEmpty = YES;
          }
        }
      }];
      
      __block NSDecimalNumber *finalAmount = [[NSDecimalNumber alloc] initWithDouble:0.0];
      __block NSString *currency = @"";
      
      [amounts enumerateObjectsUsingBlock:^(NSString * _Nonnull amount, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray<NSString *> *amountComponents = [amount componentsSeparatedByString:@" "];
        NSDecimalNumber *decimalNumber = [[NSDecimalNumber alloc] initWithString:[amountComponents objectAtIndex:0]];
        if (decimalNumber && NO == [decimalNumber isEqual:[NSDecimalNumber notANumber]]) {
          finalAmount = [finalAmount decimalNumberByAdding:decimalNumber];
          currency = [amountComponents objectAtIndex:1];
        }
      }];
      
      DDHMonthData *monthData = [[DDHMonthData alloc] initWithMonthName:monthString value:finalAmount currencyString:currency];
      [monthDataArray addObject:monthData];
    }];
   
    [self parseCompletionHandler](monthDataArray);
  }
  
  return YES;
}

@end
