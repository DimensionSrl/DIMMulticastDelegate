//
//  DIMMulticastDelegateTests.m
//  DIMMulticastDelegateTests
//
//  Created by Matteo Matassoni on 17/10/23.
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import <DIMMulticastDelegate/DIMMulticastDelegate.h>

@interface UIScrollViewMulticastDelegateTests : XCTestCase<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL hasScrollViewDidScrollBeenCalled;

@end

@interface MockedScrollViewDelegate: NSObject<UIScrollViewDelegate>

@property (nonatomic, assign) BOOL hasScrollViewShouldScrollToTopBeenCalled;

@end

@implementation UIScrollViewMulticastDelegateTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.hasScrollViewDidScrollBeenCalled = NO;
}

- (void)test {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    MockedScrollViewDelegate *mockedScrollViewDelegate = [[MockedScrollViewDelegate alloc] init];
    self.scrollView.delegate = mockedScrollViewDelegate;
    [self.scrollView.multicastDelegate addDelegate:self];

    XCTAssertEqual(self.scrollView.multicastDelegate, self.scrollView.delegate);

    [self.scrollView.delegate scrollViewDidScroll:self.scrollView];
    XCTAssertTrue(self.hasScrollViewDidScrollBeenCalled);

    BOOL shouldScroll = [self.scrollView.delegate scrollViewShouldScrollToTop:self.scrollView];
    XCTAssertTrue(mockedScrollViewDelegate.hasScrollViewShouldScrollToTopBeenCalled);
    XCTAssertTrue(shouldScroll);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.hasScrollViewDidScrollBeenCalled = YES;
}

@end

@implementation MockedScrollViewDelegate

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    self.hasScrollViewShouldScrollToTopBeenCalled = YES;
    return YES;
}

@end
