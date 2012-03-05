//
//  Created by stran on 3/4/12.
//
//


#import <Foundation/Foundation.h>


@interface PGTargetView : UIView   {
    __weak UIView *target;
    CGRect resizeRect;
    BOOL resizing;

}
@property(nonatomic, weak) UIView *target;
@property(nonatomic) BOOL resizing;

- (BOOL)shouldResize:(CGPoint)point;
- (BOOL)shouldMove:(CGPoint)point;
@end