//
//  UINavigationController+MulticastDelegate.m
//  DMNMulticastDelegate
//
//  Created by Matteo Matassoni on 17/10/23.
//

#import "UINavigationController+MulticastDelegate.h"
#import <objc/runtime.h>
#import "DMNMulticastDelegateImplementation.h"

static void *DMNUINavigationControllerMulticastDelegatePropertyKey = &DMNUINavigationControllerMulticastDelegatePropertyKey;

@implementation UINavigationController (MulticastDelegate)

- (DMNMulticastDelegate *)multicastDelegate {
    id associatedObject = objc_getAssociatedObject(self,
                                                   &DMNUINavigationControllerMulticastDelegatePropertyKey);
    if (associatedObject && [associatedObject isKindOfClass:DMNMulticastDelegate.class]) {
        return (DMNMulticastDelegate *)associatedObject;
    }

    DMNMulticastDelegate *multicastDelegate = [[DMNMulticastDelegate alloc] initWithTarget:self
                                                                            delegateGetter:@selector(delegate)
                                                                            delegateSetter:@selector(setDelegate:)];
    objc_setAssociatedObject(self,
                             &DMNUINavigationControllerMulticastDelegatePropertyKey,
                             multicastDelegate,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return multicastDelegate;
}

@end
