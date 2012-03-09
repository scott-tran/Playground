//
//  Created by stran on 3/2/12.
//
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PGAction.h"

@class PGTargetView;
@class PGMenuView;
@class PGInputView;

@interface PGWindow : UIWindow
<PGActionDelegate,
        UIGestureRecognizerDelegate> {

    BOOL locked;

    UIView *selectedView;
    NSUInteger selectedIndex;

    PGInputView *inputView;
    PGTargetView *targetView;
    UIView *overlayView;

    PGMenuView *menuView;

    CGPoint startPoint;
    BOOL moving;

}
@property(nonatomic) BOOL locked;
@property(nonatomic, retain) PGMenuView *menuView;


- (id)initWithFrame:(CGRect)frame locked:(BOOL)lock;


@end