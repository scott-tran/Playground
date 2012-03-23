//
//  Created by stran on 3/11/12.
//
//


#import <Foundation/Foundation.h>

typedef enum {
    PGMoveMode,
    PGResizeMode,
    PGNavigateMode
} PGToolbarMode;

@protocol PGActionDelegate;

@interface PGToolbar : UIView {

    UIView *target;

    id<PGActionDelegate> delegate;

    UIButton *commandButton;
    UIButton *infoButton;
    UIButton *leftButton;
    UIButton *rightButton;
    UIButton *upButton;
    UIButton *downButton;

    UIView *commandBar;
    UIView *overlay;

    BOOL expanded;

    PGToolbarMode mode;

}
@property(nonatomic, assign) UIView *target;
@property(assign)id<PGActionDelegate> delegate;
@property(nonatomic, retain) UIButton *commandButton;
@property(nonatomic, retain) UIButton *infoButton;
@property(nonatomic, retain) UIButton *leftButton;
@property(nonatomic, retain) UIButton *rightButton;
@property(nonatomic, retain) UIButton *upButton;
@property(nonatomic, retain) UIButton *downButton;
@property(nonatomic, retain) UIView *commandBar;
@property(nonatomic, retain) UIView *overlay;


- (void)updateTargetInfo;
@end