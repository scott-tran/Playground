//
//  Created by stran on 3/4/12.
//
//


#import "PGTargetView.h"


@implementation PGTargetView {

}
@synthesize target;
@synthesize resizing;

- (BOOL)shouldResize:(CGPoint)point {
    return CGRectContainsPoint(resizeRect, point);
}

- (BOOL)shouldMove:(CGPoint)point {
    return CGRectContainsPoint(target.frame, point);
}

- (void)setTarget:(UIView *)aTarget {
    target = aTarget;

    if (target.superview) {
        self.frame = CGRectMake(0, 0, target.superview.bounds.size.width, target.superview.bounds.size.height);
    }
}

- (void)drawRect:(CGRect)rect {
    resizeRect = CGRectInset(target.frame, -20, -20);

    UIColor *color = [UIColor redColor];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetFillColorWithColor(context, color.CGColor);
    UIFont *font = [UIFont boldSystemFontOfSize:11];

    CGContextStrokeRect(context, target.frame);

    CGFloat dash[2] = {2, 5};
    CGContextSetLineDash(context, 0, dash, 2);
    CGContextSetLineWidth(context, 3);

    CGFloat minX = CGRectGetMinX(target.frame);
    CGFloat minY = CGRectGetMinY(target.frame);
    CGFloat midX = floorf(CGRectGetMidX(target.frame));
    CGFloat midY = floorf(CGRectGetMidY(target.frame));
    CGFloat maxX = CGRectGetMaxX(target.frame);
    CGFloat maxY = CGRectGetMaxY(target.frame);

    // left
    CGContextMoveToPoint(context, 0, midY);
    CGContextAddLineToPoint(context, minX, midY);
    CGContextStrokePath(context);
    NSString *left = [NSString stringWithFormat:@"%.0f", minX];
    CGSize leftSize = [left sizeWithFont:font];
    CGRect leftRect = CGRectMake(1, midY + 6, leftSize.width, leftSize.height);
    [left drawInRect:leftRect withFont:font];

    // right
    CGContextMoveToPoint(context, maxX, midY);
    CGContextAddLineToPoint(context, rect.size.width, midY);
    CGContextStrokePath(context);
    NSString *right = [NSString stringWithFormat:@"%.0f", rect.size.width - maxX];
    CGSize rightSize = [right sizeWithFont:font];
    CGRect rightRect = CGRectMake(rect.size.width - rightSize.width - 1, midY + 6, rightSize.width, rightSize.height);
    [right drawInRect:rightRect withFont:font];

    // top
    CGContextMoveToPoint(context, midX, 0);
    CGContextAddLineToPoint(context, midX, minY);
    CGContextStrokePath(context);
    NSString *top = [NSString stringWithFormat:@"%.0f", minY];
    CGSize topSize = [top sizeWithFont:font];
    CGRect topRect = CGRectMake(midX + 6, 1, topSize.width, topSize.height);
    [top drawInRect:topRect withFont:font];

    // bottom
    CGContextMoveToPoint(context, midX, maxY);
    CGContextAddLineToPoint(context, midX, rect.size.height);
    CGContextStrokePath(context);
    NSString *bottom = [NSString stringWithFormat:@"%.0f", rect.size.height - maxY];
    CGSize bottomSize = [bottom sizeWithFont:font];
    CGRect bottomRect = CGRectMake(midX + 6, rect.size.height - bottomSize.height - 1, bottomSize.width, bottomSize.height);
    [bottom drawInRect:bottomRect withFont:font];

}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.contentMode = UIViewContentModeRedraw;
    }

    return self;
}

@end