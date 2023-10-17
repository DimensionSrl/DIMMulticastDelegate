//
//  UIScrollView+MulticastDelegate.m
//  DIMMulticastDelegate
//
//  Created by Matteo Matassoni on 17/10/23.
//

#import "UIScrollView+MulticastDelegate.h"
#import <objc/runtime.h>
#import "DIMMulticastDelegateImplementation.h"

static void *DIMUIScrollViewMulticastDelegatePropertyKey = &DIMUIScrollViewMulticastDelegatePropertyKey;

@implementation UIScrollView (MulticastDelegate)

- (DIMMulticastDelegate *)multicastDelegate {
    id associatedObject = objc_getAssociatedObject(self,
                                                   &DIMUIScrollViewMulticastDelegatePropertyKey);
    if (associatedObject && [associatedObject isKindOfClass:DIMMulticastDelegate.class]) {
        return (DIMMulticastDelegate *)associatedObject;
    }

    DIMMulticastDelegate *multicastDelegate = [[DIMMulticastDelegate alloc] initWithTarget:self
                                                                            delegateGetter:@selector(delegate)
                                                                            delegateSetter:@selector(setDelegate:)];
    objc_setAssociatedObject(self,
                             &DIMUIScrollViewMulticastDelegatePropertyKey,
                             multicastDelegate,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return multicastDelegate;
}

@end
