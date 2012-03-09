//
//  Created by stran on 3/5/12.
//
//


#import <Foundation/Foundation.h>

@protocol PGActionDelegate;

@interface PGMenuView : UIView {

    UIView *target;

    id<PGActionDelegate> delegate;

    UILabel *info;
    UILabel *detail;
    UISegmentedControl *toolbar;
    UIButton *leftButton;
    UIButton *rightButton;
    UIButton *upButton;
    UIButton *downButton;

    CGPoint startPoint;

}
@property(nonatomic, assign) UIView *target;
@property(assign)id<PGActionDelegate> delegate;
@property(nonatomic, retain) UILabel *info;
@property(nonatomic, retain) UISegmentedControl *toolbar;
@property(nonatomic, retain) UIButton *leftButton;
@property(nonatomic, retain) UIButton *rightButton;
@property(nonatomic, retain) UIButton *upButton;
@property(nonatomic, retain) UIButton *downButton;

- (void)updateTargetInfo;

@end