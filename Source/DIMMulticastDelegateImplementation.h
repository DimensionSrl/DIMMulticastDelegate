//
//  DIMMulticastDelegateImplementation.h
//  DIMMulticastDelegate
//
//  Created by Matteo Matassoni on 17/10/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(MulticastDelegate)
@interface DIMMulticastDelegate : NSObject

- (instancetype)initWithTarget:(id)target
                delegateGetter:(SEL)delegateGetter
                delegateSetter:(SEL)delegateSetter NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (void)addDelegate:(id)delegate NS_SWIFT_NAME(addDelegate(_:));

- (void)removeDelegate:(id)delegate NS_SWIFT_NAME(removeDelegate(_:));

@end

NS_ASSUME_NONNULL_END
