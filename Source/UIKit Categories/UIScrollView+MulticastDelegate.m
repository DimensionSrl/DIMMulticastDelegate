//
//  UIScrollView+MulticastDelegate.m
//  DMNMulticastDelegate
//
//  Created by Matteo Matassoni on 17/10/23.
//

#import "UIScrollView+MulticastDelegate.h"
#import <objc/runtime.h>
#import "DMNMulticastDelegateImplementation.h"

static void *DMNUIScrollViewMulticastDelegatePropertyKey = &DMNUIScrollViewMulticastDelegatePropertyKey;

@implementation UIScrollView (MulticastDelegate)

- (DMNMulticastDelegate *)multicastDelegate {
    id associatedObject = objc_getAssociatedObject(self,
                                                   &DMNUIScrollViewMulticastDelegatePropertyKey);
    if (associatedObject && [associatedObject isKindOfClass:DMNMulticastDelegate.class]) {
        return (DMNMulticastDelegate *)associatedObject;
    }

    DMNMulticastDelegate *multicastDelegate = [[DMNMulticastDelegate alloc] initWithTarget:self
                                                                            delegateGetter:@selector(delegate)
                                                                            delegateSetter:@selector(setDelegate:)];
    objc_setAssociatedObject(self,
                             &DMNUIScrollViewMulticastDelegatePropertyKey,
                             multicastDelegate,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return multicastDelegate;
}

@end
