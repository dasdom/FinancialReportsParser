//  Created by Dominik Hauser on 25.12.22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDHMonthData : NSObject
@property (strong) NSString *monthName;
@property (strong) NSNumber *value;
@property (strong) NSString *currentyString;
- (instancetype)initWithMonthName:(NSString *)monthName value:(NSNumber *)value currencyString:(NSString *)currencyString;
@end

NS_ASSUME_NONNULL_END
