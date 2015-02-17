//
//  UIColor+HexString.h
//  TwitterClient
//
//  Created by Casing Chu on 2/16/15.
//  Copyright (c) 2015 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexString)

+ (UIColor *)colorFromHexString:(NSString *)hexString withAlpha:(CGFloat) alpha;

@end
