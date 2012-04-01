//
//  Created by stran on 3/2/12.
//
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "PGAction.h"


@class PGTargetView;
@class PGInputView;
@class PGToolbar;

@interface PGWindow : UIWindow
        <PGActionDelegate,
        UIGestureRecognizerDelegate,
        MFMailComposeViewControllerDelegate> {

    BOOL active;
    UIGestureRecognizer *activateGestureRecognizer;

    UIView *selectedView;
    NSUInteger selectedIndex;

    PGInputView *inputView;
    PGTargetView *targetView;

    PGToolbar *toolbar;

    CGPoint startPoint;
    NSInteger moving;

}
@property(nonatomic) BOOL active;
@property(nonatomic, retain) PGToolbar *toolbar;
@property(nonatomic, strong) UIGestureRecognizer *activateGestureRecognizer;

+ (UIImage *)createScreenshot:(UIView *)view;

+ (void)displayMessage:(NSString *)message;


@end