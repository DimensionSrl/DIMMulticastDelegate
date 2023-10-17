//
//  DMNMulticastDelegateImplementation.m
//  DMNMulticastDelegate
//
//  Created by Matteo Matassoni on 17/10/23.
//

#import "DMNMulticastDelegateImplementation.h"

static inline id DMNGetKVOChange(NSDictionary<NSKeyValueChangeKey,id> *change,
                                 NSKeyValueChangeKey keyValueChangeKey) {
    id value = change[keyValueChangeKey];
    if ([value isEqual:NSNull.null]) {
        value = nil;
    }
    return value;
}

static NSInteger DMNMulticastDelegateKVOContext = 0;

#pragma mark Private Interface

@interface DMNMulticastDelegate()

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL delegateGetter;
@property (nonatomic, assign) SEL delegateSetter;
@property (nonatomic, strong) NSHashTable *delegates;
@property (nonatomic, assign) NSUInteger enumerationCounter;

@end

@implementation DMNMulticastDelegate

#pragma mark Initialization

- (instancetype)initWithTarget:(id)target
                delegateGetter:(SEL)delegateGetter
                delegateSetter:(SEL)delegateSetter {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.target = target;
    self.delegateGetter = delegateGetter;
    self.delegateSetter = delegateSetter;

    [self addInitialDelegate];
    [self startObservingUIKitDelegateChanges];
    [self performDelegateSetterWithObject:self];

    return self;
}

#pragma mark Public APIs

- (void)addDelegate:(id)delegate {
    if ([self.delegates containsObject:delegate]) {
        return;
    }

    if (self.enumerationCounter > 0) {
        self.delegates = [self.delegates copy];
    }

    [self.delegates addObject:delegate];
    [self resetUIKitDelegateCache];
}

- (void)removeDelegate:(id)delegate {
    if (![self.delegates containsObject:delegate]) {
        return;
    }

    if (self.enumerationCounter > 0) {
        self.delegates = [self.delegates copy];
    }

    [self.delegates removeObject:delegate];
    [self resetUIKitDelegateCache];
}

#pragma mark <NSObject>

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    __block BOOL result = NO;
    [self enumerateDelegatesUsingBlock:^(id delegate, BOOL *stop) {
        if ([delegate conformsToProtocol:aProtocol]) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    __block BOOL result = NO;
    [self enumerateDelegatesUsingBlock:^(id delegate, BOOL *stop) {
        if ([delegate respondsToSelector:aSelector]) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [self enumerateDelegatesUsingBlock:^(id delegate, BOOL *stop) {
        if ([delegate respondsToSelector:invocation.selector]) {
            [invocation invokeWithTarget:delegate];
        }
    }];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    __block NSMethodSignature *signature = nil;
    [self enumerateDelegatesUsingBlock:^(id delegate, BOOL *stop) {
        if ([delegate respondsToSelector:selector]) {
            signature = [delegate methodSignatureForSelector:selector];
            *stop = YES;
        }
    }];
    return signature ?: [NSMethodSignature signatureWithObjCTypes:"@^v^c"];
}

#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if (context != &DMNMulticastDelegateKVOContext) {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
        return;
    }

    id newUIKitDelegate = DMNGetKVOChange(change, NSKeyValueChangeNewKey);
    id oldUIKitDelegate = DMNGetKVOChange(change, NSKeyValueChangeOldKey);
    if (newUIKitDelegate == oldUIKitDelegate || newUIKitDelegate == self) {
        return;
    }

    if (oldUIKitDelegate) {
        [self removeDelegate:oldUIKitDelegate];
    }
    if (newUIKitDelegate) {
        [self addDelegate:newUIKitDelegate];
    }
}

#pragma mark Private APIs

- (NSHashTable *)delegates {
    if (_delegates) {
        return _delegates;
    }

    _delegates = [NSHashTable weakObjectsHashTable];
    return _delegates;
}

- (void)startObservingUIKitDelegateChanges {
    [self.target addObserver:self
              forKeyPath:NSStringFromSelector(self.delegateGetter)
                 options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                 context:&DMNMulticastDelegateKVOContext];
}

- (id)performDelegateGetter {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [self.target performSelector:self.delegateGetter];
#pragma clang diagnostic pop
}

- (void)performDelegateSetterWithObject:(id)object {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.target performSelector:self.delegateSetter withObject:object];
#pragma clang diagnostic pop
}

- (void)enumerateDelegatesUsingBlock:(void(^ NS_NOESCAPE)(id delegate, BOOL *stop))block {
    ++self.enumerationCounter;

    BOOL stop = NO;
    for (id delegate in self.delegates) {
        block(delegate, &stop);
        if (stop) {
            break;
        }
    }

    --self.enumerationCounter;
}

- (void)addInitialDelegate {
    id initialDelegate = [self performDelegateGetter];

    if (initialDelegate) {
        [self addDelegate:initialDelegate];
    }
}

- (void)resetUIKitDelegateCache {
    [self performDelegateSetterWithObject:nil];
    [self performDelegateSetterWithObject:self];
}

@end
