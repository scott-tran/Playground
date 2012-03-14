//
//  Created by stran on 3/2/12.
//
//


#import "PGWindow.h"
#import "PGTargetView.h"
#import "PGInputView.h"
#import "PGToolbar.h"


@implementation PGWindow {


}
@synthesize locked;
@synthesize toolbar;


- (NSMutableArray *)viewsAtPoint:(CGPoint)touchPoint view:(UIView *)view {
    NSMutableArray *views = [[NSMutableArray alloc] init];
    for (UIView *subview in view.subviews) {
        if (CGRectContainsPoint(subview.frame, touchPoint)) {
            if (subview != targetView) {
                [views addObject:subview];
                [views addObjectsFromArray:[self viewsAtPoint:[view convertPoint:touchPoint toView:subview] view:subview]];
            }
        }
    }

    return [views autorelease];
}


- (UIView *)findTarget:(CGPoint)touchPoint {
    NSMutableArray *views = [self viewsAtPoint:touchPoint view:self.rootViewController.view];
    if ([views count] == 0) {
        return nil;
    }


    return [views lastObject];
}

- (void)deactivateTarget {
    selectedView = nil;

    toolbar.target = nil;
    [toolbar updateTargetInfo];

    [targetView removeFromSuperview];

    [inputView removeFromSuperview];
    [inputView deactivateKeyboard];
}

- (void)activateTarget:(UIView *)view {
    if (view == selectedView) {
        return;
    }

    [self deactivateTarget];

    if (view != self.rootViewController.view) {
        selectedIndex = [view.superview.subviews indexOfObject:view];
        selectedView = view;

        if (!targetView) {
            targetView = [[PGTargetView alloc] initWithFrame:self.frame];
        }
        if (!inputView) {
            inputView = [[PGInputView alloc] initWithFrame:CGRectMake(-1, -1, 50, 50)];
            inputView.delegate = self;
        }
        if (!toolbar) {
            self.toolbar = [[[PGToolbar alloc] initWithFrame:CGRectZero] autorelease];
            toolbar.delegate = self;
        }

        toolbar.target = selectedView;
        targetView.target = selectedView;

        [view.superview addSubview:targetView];

        CGRect rect = self.rootViewController.view.bounds;
        toolbar.center = CGPointMake(toolbar.center.x, CGRectGetMidY(rect));
        [self.rootViewController.view addSubview:toolbar];

        [toolbar updateTargetInfo];
        [targetView setNeedsDisplay];

        [self addSubview:inputView];
        [inputView activateKeyboard];
    }

}

- (void)unlockGesture:(UIGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        self.locked = !locked;

        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        label.backgroundColor = [UIColor blackColor];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = UITextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:25];
        label.layer.cornerRadius = 5;

        if (locked) {
            label.text = @"Locked";
            [toolbar removeFromSuperview];
        } else {
            label.text = @"Unlocked";
        }

        CGRect frame = self.rootViewController.view.bounds;

        [label sizeToFit];
        label.frame = CGRectInset(label.frame, -40, -20);
        label.center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));

        [self.rootViewController.view addSubview:label];

        [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveLinear animations:^{
            label.alpha = 0;
        }  completion:^(BOOL finished) {
            [label removeFromSuperview];

        }];
    }
}

- (void)tapGesture:(UIGestureRecognizer *)recognizer {
    CGPoint touchPoint = [recognizer locationInView:self.rootViewController.view];
    UIView *target = [self findTarget:touchPoint];

    if (!target && selectedView) {
        [self deactivateTarget];
    } else if (target) {
        [self activateTarget:target];
    }
}

- (void)moveGesture:(UIGestureRecognizer *)recognizer {
    if (selectedView) {
        CGPoint touchPoint = [recognizer locationInView:self.rootViewController.view];

        if (recognizer.state == UIGestureRecognizerStateBegan) {
            startPoint = touchPoint;
            // inside target
            if ([targetView shouldMove:touchPoint]) {
                moving = YES;
            } else if ([targetView shouldResize:touchPoint]) {
                moving = NO;
            }
        }

        if (recognizer.state == UIGestureRecognizerStateChanged) {
            CGRect frame = selectedView.frame;
            if (moving) {
                CGPoint vector = CGPointMake(startPoint.x - touchPoint.x, startPoint.y - touchPoint.y);

                // move selectedview
                frame.origin.x -= vector.x;
                frame.origin.y -= vector.y;
            } else {
                // resize selected view
                CGPoint vector = CGPointMake(startPoint.x - touchPoint.x, startPoint.y - touchPoint.y);

                if (selectedView.center.x > touchPoint.x) {
                    frame.origin.x -= vector.x;
                    frame.size.width += vector.x;
                } else {
                    frame.size.width -= vector.x;
                }

                if (selectedView.center.y > touchPoint.y) {
                    frame.origin.y -= vector.y;
                    frame.size.height += vector.y;
                } else {
                    frame.size.height -= vector.y;
                }
            }

            selectedView.frame = frame;

            [toolbar updateTargetInfo];
            [targetView setNeedsDisplay];
            startPoint = touchPoint;
        }
    }

}

- (void)receiveAction:(PGAction)action {
    CGRect frame = selectedView.frame;

    switch (action) {
        case PGMoveLeft:
            frame.origin.x -= 1;
            selectedView.frame = frame;
            break;
        case PGMoveRight:
            frame.origin.x += 1;
            selectedView.frame = frame;
            break;
        case PGMoveUp:
            frame.origin.y -= 1;
            selectedView.frame = frame;
            break;
        case PGMoveDown:
            frame.origin.y += 1;
            selectedView.frame = frame;
            break;
        case PGIncreaseWidth:
            frame.size.width += 1;
            selectedView.frame = frame;
            break;
        case PGDecreaseWidth:
            frame.size.width -= 1;
            selectedView.frame = frame;
            break;
        case PGIncreaseHeight:
            frame.size.height += 1;
            selectedView.frame = frame;
            break;
        case PGDecreaseHeight:
            frame.size.height -= 1;
            selectedView.frame = frame;
            break;
        case PGMoveLeftInViews:
            if (selectedIndex > 0) {
                [self activateTarget:[selectedView.superview.subviews objectAtIndex:selectedIndex - 1]];
            }
            break;
        case PGMoveRightInViews:
            if (selectedIndex < [selectedView.superview.subviews count] - 1) {
                // account for subviews added
                UIView *target = selectedView;
                NSUInteger index = selectedIndex + 1;
                [self deactivateTarget];
                [self activateTarget:[target.superview.subviews objectAtIndex:index]];
            }
            break;
        case PGMoveUpInViews:
            if (selectedView.superview) {
                [self activateTarget:selectedView.superview];
            }
            break;
        case PGMoveDownInViews:
            if ([selectedView.subviews count] > 0) {
                [self activateTarget:[selectedView.subviews objectAtIndex:0]];
            }
            break;
        case PGProperties:
        {
            NSString *name = !selectedView.accessibilityIdentifier ? NSStringFromClass([selectedView class]) : selectedView.accessibilityIdentifier;

            NSMutableString *properties = [NSMutableString stringWithFormat:@"\n************* %@ : %@ : %d *************\n", name, selectedView.class, selectedView.tag];
            [properties appendFormat:@"FRAME:\nCGRectMake(%.0f, %.0f, %.0f, %.0f);\n", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height];

            NSLog(@"%@", properties);
            break;
        }
        default:
            break;
    }

    [toolbar updateTargetInfo];
    [targetView setNeedsDisplay];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (locked) {
        return NO;
    } else {
        if (toolbar.superview && (CGRectContainsPoint(toolbar.frame, [gestureRecognizer locationInView:self.rootViewController.view]))) {
            return NO;
        } else {
            return YES;
        }
    }
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.userInteractionEnabled = YES;
        self.locked = YES;

        UITapGestureRecognizer *unlockGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(unlockGesture:)];
        unlockGesture.numberOfTouchesRequired = 2;
        [self addGestureRecognizer:unlockGesture];
        [unlockGesture release];

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        tapGesture.delegate = self;
        [self addGestureRecognizer:tapGesture];
        [tapGesture release];

        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveGesture:)];
        panGesture.delegate = self;
        [self addGestureRecognizer:panGesture];
        [panGesture release];

    }

    return self;
}

- (id)initWithFrame:(CGRect)frame locked:(BOOL)lock {
    self = [self initWithFrame:frame];
    if (self) {
        self.locked = lock;
    }

    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (locked) {
        return [super hitTest:point withEvent:event];
    } else {
        if (CGRectContainsPoint(toolbar.frame, [self convertPoint:point toView:self.rootViewController.view])) {
            return [super hitTest:point withEvent:event];
        }
        // prevent subviews from receiving events
        return self;
    }
}

- (void)dealloc {
    [targetView release];
    [inputView release];
    [toolbar release];

    [super dealloc];
}

@end