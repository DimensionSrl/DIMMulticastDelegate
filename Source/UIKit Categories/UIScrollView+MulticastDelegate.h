//
//  UIScrollView+MulticastDelegate.h
//  DIMMulticastDelegate
//
//  Created by Matteo Matassoni on 17/10/23.
//

#import <UIKit/UIKit.h>

@class DIMMulticastDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (MulticastDelegate)

@property (null_unspecified, nonatomic, readonly) DIMMulticastDelegate *multicastDelegate;

@end

NS_ASSUME_NONNULL_END
