//
//  Created by stran on 3/2/12.
//
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PGInputView.h"

@class PGTargetView;

@interface PlaygroundWindow : UIWindow
<PGInputViewDelegate,
        UIGestureRecognizerDelegate> {

    BOOL locked;

    UIView *selectedView;
    NSUInteger selectedIndex;

    PGInputView *inputView;
    PGTargetView *targetView;
    UIView *overlayView;

    CGPoint startPoint;
    BOOL moving;

}
@property(nonatomic) BOOL locked;

@end