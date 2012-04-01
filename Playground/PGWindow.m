//
//  Created by stran on 3/2/12.
//
//

#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import "PGWindow.h"
#import "PGTargetView.h"
#import "PGInputView.h"
#import "PGToolbar.h"

@interface PGWindow ()
- (NSString *)propertiesForView:(UIView *)target;

- (void)emailProperties;

@end

@implementation PGWindow {


}
@synthesize active;
@synthesize toolbar;
@synthesize activateGestureRecognizer;


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
    selectedIndex = 0;

    toolbar.target = nil;
    [toolbar updateTargetInfo];
    [toolbar removeFromSuperview];

    [targetView removeFromSuperview];

    if (inputView) {
        [inputView removeFromSuperview];
        [inputView deactivateKeyboard];
    }
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

#if TARGET_IPHONE_SIMULATOR
        if (!inputView) {
            inputView = [[PGInputView alloc] initWithFrame:CGRectMake(-1, -1, 50, 50)];
            inputView.delegate = self;
        }
#endif

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

        if (inputView) {
            [self addSubview:inputView];
            [inputView activateKeyboard];
        }
    }

}

- (void)activateGesture:(UIGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        self.active = !active;

        NSString *message = nil;
        if (active) {
            message = @"Active";
        } else {
            message = @"Inactive";
            [toolbar removeFromSuperview];
            [targetView removeFromSuperview];
        }

        [PGWindow displayMessage:message];
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
        CGPoint touchPoint = [recognizer locationInView:targetView];

        if (recognizer.state == UIGestureRecognizerStateBegan) {
            startPoint = touchPoint;
            // inside target
            if ([targetView shouldMove:touchPoint]) {
                moving = 1;
            } else if ([targetView shouldResize:touchPoint]) {
                moving = -1;
            } else {
                moving = 0;
            }
        }

        if (recognizer.state == UIGestureRecognizerStateChanged) {

            CGRect frame = selectedView.frame;
            CGPoint vector = CGPointMake(startPoint.x - touchPoint.x, startPoint.y - touchPoint.y);

            switch (moving) {
                case 1:
                    // move selectedview
                    frame.origin.x -= vector.x;
                    frame.origin.y -= vector.y;
                    break;
                case -1:
                    // resize selected view
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
                    break;
                default:
                    return;
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
        {
            NSUInteger index = selectedIndex;
            UIView *target = selectedView;

            [self deactivateTarget];
            if (index < [target.superview.subviews count] - 1) {
                index++;
            }
            [self activateTarget:[target.superview.subviews objectAtIndex:index]];

            break;
        }
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
            NSLog(@"%@", [self propertiesForView:selectedView]);
            break;
        case PGMailProperties:
            [self emailProperties];
            break;
        default:
            break;
    }

    [toolbar updateTargetInfo];
    [targetView setNeedsDisplay];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (active) {
        if (toolbar.superview && (toolbar.overlay.superview || (CGRectContainsPoint(toolbar.frame, [gestureRecognizer locationInView:self.rootViewController.view])))) {
            return NO;
        } else {
            return YES;
        }
    } else {
        return NO;
    }
}

- (void)setActivateGestureRecognizer:(UIGestureRecognizer *)anActivateGestureRecognizer {
    [self removeGestureRecognizer:activateGestureRecognizer];
    [activateGestureRecognizer release];

    activateGestureRecognizer = [anActivateGestureRecognizer retain];
    [activateGestureRecognizer addTarget:self action:@selector(activateGesture:)];
    [self addGestureRecognizer:activateGestureRecognizer];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.userInteractionEnabled = YES;

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        tapGesture.delegate = self;
        [self addGestureRecognizer:tapGesture];
        [tapGesture release];

        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveGesture:)];
        panGesture.delegate = self;
        [self addGestureRecognizer:panGesture];
        [panGesture release];

        UILongPressGestureRecognizer *defaultActivateGesture = [[UILongPressGestureRecognizer alloc] init];
        defaultActivateGesture.numberOfTouchesRequired = 2;
        self.activateGestureRecognizer = defaultActivateGesture;

    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (active) {
        if (CGRectContainsPoint(toolbar.frame, [self convertPoint:point toView:self.rootViewController.view])) {
            return [super hitTest:point withEvent:event];
        } else {
            // prevent subviews from receiving events
            return self;
        }
    } else {
        return [super hitTest:point withEvent:event];
    }
}

- (void)dealloc {
    [targetView release];
    [inputView release];
    [toolbar release];

    [super dealloc];
}

- (NSString *)propertiesForView:(UIView *)target {
    NSString *name = !target.accessibilityIdentifier ? NSStringFromClass([target class]) : target.accessibilityIdentifier;
    CGRect frame = target.frame;
    CGPoint center = target.center;

    NSMutableString *properties = [NSMutableString stringWithFormat:@"\n************* %@ : %d *************\n", name, target.tag];
    [properties appendFormat:@"FRAME:\nCGRectMake(%.0f, %.0f, %.0f, %.0f);\n", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height];
    [properties appendFormat:@"CENTER:\nCGPointMake(%.0f, %.0f);\n", center.x, center.y];

    return properties;
}

- (void)emailProperties {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        controller.modalPresentationStyle = UIModalPresentationFormSheet;
        controller.mailComposeDelegate = self;

        NSString *message = [self propertiesForView:selectedView];
        [controller setMessageBody:message isHTML:NO];

        toolbar.hidden = YES;
//        targetView.hidden = YES;

        UIImage *screenshot = [PGWindow createScreenshot:self.rootViewController.view];
        NSData *data = UIImagePNGRepresentation(screenshot);
        [controller addAttachmentData:data mimeType:@"image/png" fileName:@"screenshot.png"];

        toolbar.hidden = NO;
//        targetView.hidden = NO;

        active = NO;
        if (inputView) {
            [inputView deactivateKeyboard];
            [inputView removeFromSuperview];
        }
        [self.rootViewController presentModalViewController:controller animated:YES];
        [controller release];
    } else {
        [PGWindow displayMessage:@"Unable to send mail"];
    }
}

#pragma mark mail delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    active = YES;
    [self.rootViewController dismissModalViewControllerAnimated:YES];
    if (inputView) {
        [self addSubview:inputView];
        [inputView activateKeyboard];
    }
}

+ (UIImage *)createScreenshot:(UIView *)view {
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    [view.layer renderInContext:context];

    UIImage *shot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return shot;
}

+ (void)displayMessage:(NSString *)message {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor blackColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:25];
    label.layer.cornerRadius = 5;

    label.text = message;

    UIView *rootView = [UIApplication sharedApplication].delegate.window.rootViewController.view;
    CGRect frame = rootView.bounds;

    [label sizeToFit];
    label.frame = CGRectInset(label.frame, -40, -20);
    label.center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));

    [rootView addSubview:label];
    [label release];

    [UIView animateWithDuration:.5 delay:1 options:UIViewAnimationOptionCurveLinear animations:^{
        label.alpha = 0;
    }                completion:^(BOOL finished) {
        [label removeFromSuperview];

    }];
}
@end