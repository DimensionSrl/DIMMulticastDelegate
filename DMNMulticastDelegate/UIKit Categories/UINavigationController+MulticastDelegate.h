//
//  UINavigationController+MulticastDelegate.h
//  DMNMulticastDelegate
//
//  Created by Matteo Matassoni on 17/10/23.
//

#import <UIKit/UIKit.h>

@class DMNMulticastDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (MulticastDelegate)

@property (null_unspecified, nonatomic, readonly) DMNMulticastDelegate *multicastDelegate;

@end

NS_ASSUME_NONNULL_END
