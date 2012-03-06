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

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    UIFont *font = [UIFont systemFontOfSize:15];

    CGFloat dash[2] = {2, 5};
    CGContextSetLineDash(context, 0, dash, 2);

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
    NSString *left = [NSString stringWithFormat:@"%.1f", minX];
    CGSize leftSize = [left sizeWithFont:font];
    CGRect leftRect = CGRectMake(1, midY, leftSize.width, leftSize.height);
    [left drawInRect:leftRect withFont:font];

    // right
    CGContextMoveToPoint(context, maxX, midY);
    CGContextAddLineToPoint(context, rect.size.width, midY);
    CGContextStrokePath(context);
    NSString *right = [NSString stringWithFormat:@"%.1f", rect.size.width - maxX];
    CGSize rightSize = [right sizeWithFont:font];
    CGRect rightRect = CGRectMake(rect.size.width - rightSize.width - 1, midY, rightSize.width, rightSize.height);
    [right drawInRect:rightRect withFont:font];

    // top
    CGContextMoveToPoint(context, midX, 0);
    CGContextAddLineToPoint(context, midX, minY);
    CGContextStrokePath(context);
    NSString *top = [NSString stringWithFormat:@"%.1f", minY];
    CGSize topSize = [top sizeWithFont:font];
    CGRect topRect = CGRectMake(midX + 2, 1, topSize.width, topSize.height);
    [top drawInRect:topRect withFont:font];

    // bottom
    CGContextMoveToPoint(context, midX, maxY);
    CGContextAddLineToPoint(context, midX, rect.size.height);
    CGContextStrokePath(context);
    NSString *bottom = [NSString stringWithFormat:@"%.1f", rect.size.height - maxY];
    CGSize bottomSize = [bottom sizeWithFont:font];
    CGRect bottomRect = CGRectMake(midX + 2, rect.size.height - bottomSize.height - 1, bottomSize.width, bottomSize.height);
    [bottom drawInRect:bottomRect withFont:font];

    // frame
    NSString *frame = NSStringFromCGRect(target.frame);
    CGSize frameSize = [frame sizeWithFont:font];

    // align on bottom
    CGRect frameRect = CGRectMake(midX - (frameSize.width/2), maxY + 12, frameSize.width, frameSize.height);
    if (!CGRectContainsRect(rect, frameRect)) {
        // frameRect won't fit, try top
        frameRect.origin.y = minY - frameSize.height - 12;
        if (!CGRectContainsRect(rect, frameRect)) {
            // try left
            frameRect.origin.x = minX - frameSize.width - 12;
            frameRect.origin.y = midY - (frameSize.height) - 2;

            if (!CGRectContainsRect(rect, frameRect)) {
                // try right
                frameRect.origin.x = maxX + 10;
            }
        }
    }

    [frame drawInRect:frameRect withFont:font];

    // resize handles
    minX -= 10;
    minY -= 10;
    maxX += 10;
    maxY += 10;

    CGContextSetStrokeColorWithColor(context, [UIColor orangeColor].CGColor);
    CGContextSetLineDash(context, 0, NULL, 0);
    CGContextSetLineWidth(context, 5);

    // top left
    CGContextMoveToPoint(context, minX, minY + 20);
    CGContextAddLineToPoint(context, minX, minY);
    CGContextAddLineToPoint(context, minX + 20, minY);
    CGContextStrokePath(context);

    // top right
    CGContextMoveToPoint(context, maxX - 20, minY);
    CGContextAddLineToPoint(context, maxX, minY);
    CGContextAddLineToPoint(context, maxX, minY + 20);
    CGContextStrokePath(context);

    // bottom left
    CGContextMoveToPoint(context, minX, maxY - 20);
    CGContextAddLineToPoint(context, minX, maxY);
    CGContextAddLineToPoint(context, minX + 20, maxY);
    CGContextStrokePath(context);

    // bottom right
    CGContextMoveToPoint(context, maxX , maxY - 20);
    CGContextAddLineToPoint(context, maxX, maxY);
    CGContextAddLineToPoint(context, maxX - 20, maxY);
    CGContextStrokePath(context);
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