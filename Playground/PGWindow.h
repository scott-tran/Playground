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
@class PGToolbar;

@interface PGWindow : UIWindow
<PGActionDelegate,
        UIGestureRecognizerDelegate> {

    BOOL locked;

    UIView *selectedView;
    NSUInteger selectedIndex;

    PGInputView *inputView;
    PGTargetView *targetView;

    PGToolbar *toolbar;

    CGPoint startPoint;
    BOOL moving;

}
@property(nonatomic) BOOL locked;
@property(nonatomic, retain) PGToolbar *toolbar;


- (id)initWithFrame:(CGRect)frame locked:(BOOL)lock;


@end