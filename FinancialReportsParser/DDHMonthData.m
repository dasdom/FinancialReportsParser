//  Created by Dominik Hauser on 25.12.22.
//

#import "DDHMonthData.h"

@implementation DDHMonthData
- (instancetype)initWithMonthName:(NSString *)monthName value:(NSNumber *)value currencyString:(NSString *)currencyString {
  if (self = [super init]) {
    _monthName = monthName;
    _value = value;
    _currentyString = currencyString;
  }
  return self;
}
@end
