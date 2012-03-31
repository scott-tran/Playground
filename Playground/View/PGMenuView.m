//
//  Created by stran on 3/5/12.
//
//


#import <QuartzCore/QuartzCore.h>
#import "PGMenuView.h"
#import "PGAction.h"


@implementation PGMenuView {


}


@synthesize delegate;
@synthesize info;
@synthesize toolbar;
@synthesize target;
@synthesize leftButton;
@synthesize rightButton;
@synthesize upButton;
@synthesize downButton;

- (void)updateTargetInfo {
    if (target) {
        NSString *accessibilityIdentifier = !target.accessibilityIdentifier ? @"Accessibility Identifier" : target.accessibilityIdentifier;
        info.text = [NSString stringWithFormat:@"  %@\n  %@:%d\n  %@",
                                               accessibilityIdentifier,
                                               [target class],
                                               target.tag,
                                               NSStringFromCGRect(target.frame)];        
    } else {
        info.text = @"";
    }
}

- (void)sendAction:(PGAction)action {
    if (target && delegate) {
        [delegate receiveAction:action];
    }
}

- (void)leftAction {
    switch (toolbar.selectedSegmentIndex) {
        case 0:
            [self sendAction:PGMoveLeft];
            break;
        case 1:
            [self sendAction:PGDecreaseWidth];
            break;
        case 2:
            [self sendAction:PGMoveLeftInViews];
            break;
    }
}

- (void)rightAction {
    switch (toolbar.selectedSegmentIndex) {
        case 0:
            [self sendAction:PGMoveRight];
            break;
        case 1:
            [self sendAction:PGIncreaseWidth];
            break;
        case 2:
            [self sendAction:PGMoveRightInViews];
            break;
    }
}

- (void)upAction {
    switch (toolbar.selectedSegmentIndex) {
        case 0:
            [self sendAction:PGMoveUp];
            break;
        case 1:
            [self sendAction:PGIncreaseHeight];
            break;
        case 2:
            [self sendAction:PGMoveUpInViews];
            break;
    }
}

- (void)downAction {
    switch (toolbar.selectedSegmentIndex) {
        case 0:
            [self sendAction:PGMoveDown];
            break;
        case 1:
            [self sendAction:PGDecreaseHeight];
            break;
        case 2:
            [self sendAction:PGMoveDownInViews];
            break;
    }
}

- (void)moveGesture:(UIPanGestureRecognizer *)recognizer {
    CGPoint touchPoint = [recognizer locationInView:self.superview];

    if (recognizer.state == UIGestureRecognizerStateBegan) {
        startPoint = touchPoint;
    }

    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint vector = CGPointMake(startPoint.x - touchPoint.x, startPoint.y - touchPoint.y);
        CGRect frame = self.frame;

        frame.origin.x -= vector.x;
        frame.origin.y -= vector.y;

        self.frame = frame;

        startPoint = touchPoint;
    }

}

- (void)selectSegment {
    switch (toolbar.selectedSegmentIndex) {
        case 0:
            [leftButton setTitle:@"\u21e0" forState:UIControlStateNormal];
            [rightButton setTitle:@"\u21e2" forState:UIControlStateNormal];
            [upButton setTitle:@"\u21e1" forState:UIControlStateNormal];
            [downButton setTitle:@"\u21e3" forState:UIControlStateNormal];
            break;
        case 1:
            [leftButton setTitle:@"\u21a4" forState:UIControlStateNormal];
            [rightButton setTitle:@"\u21a6" forState:UIControlStateNormal];
            [upButton setTitle:@"\u21a5" forState:UIControlStateNormal];
            [downButton setTitle:@"\u21a7" forState:UIControlStateNormal];
            break;
        case 2:
            [leftButton setTitle:@"\u219e" forState:UIControlStateNormal];
            [rightButton setTitle:@"\u21a0" forState:UIControlStateNormal];
            [upButton setTitle:@"\u219f" forState:UIControlStateNormal];
            [downButton setTitle:@"\u21a1" forState:UIControlStateNormal];
            break;
    }
}

- (UIImage *)backgroundImage {
    UIGraphicsBeginImageContext(CGSizeMake(1, 2));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:31/255.0 green:31/255.0 blue:31/255.0 alpha:1].CGColor);

    CGContextFillRect(context, CGRectMake(0, 0, 1, 2));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    return image;
}

- (UIButton *)createButtonWithBackground:(UIImage *)backgroundImage {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(5, 5, 40, 40);
    button.layer.cornerRadius = 5;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = 2;

    button.titleLabel.font = [UIFont boldSystemFontOfSize:30];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];

    return button;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, 205, 150);
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor blackColor];

        self.info = [[[UILabel alloc] initWithFrame:CGRectMake(5, 45, 195, 55)] autorelease];
        info.backgroundColor = [UIColor darkGrayColor];
        info.layer.cornerRadius = 5;
        info.textColor = [UIColor whiteColor];
        info.font = [UIFont boldSystemFontOfSize:12];
        info.numberOfLines = 3;
        [self addSubview:info];

        self.toolbar = [[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:
                @"Move",
                @"Resize",
                @"Navigate",
                nil]] autorelease];
        toolbar.segmentedControlStyle = UISegmentedControlStyleBar;
        toolbar.tintColor = [UIColor darkGrayColor];
        [toolbar sizeToFit];
        toolbar.frame = CGRectMake(5, 5, 195, 35);
        [self addSubview:toolbar];

        [toolbar addTarget:self action:@selector(selectSegment) forControlEvents:UIControlEventValueChanged];
        toolbar.selectedSegmentIndex = 0;

        UIImage *backgroundImage = [self backgroundImage];

        self.leftButton = [self createButtonWithBackground:backgroundImage];
        leftButton.frame = CGRectMake(5, 105, 45, 40);
        [leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftButton];

        self.rightButton = [self createButtonWithBackground:backgroundImage];
        rightButton.frame = CGRectMake(55, 105, 45, 40);
        [rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightButton];

        self.upButton = [self createButtonWithBackground:backgroundImage];
        upButton.frame = CGRectMake(105, 105, 45, 40);
        [upButton addTarget:self action:@selector(upAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:upButton];

        self.downButton = [self createButtonWithBackground:backgroundImage];
        downButton.frame = CGRectMake(155, 105, 45, 40);
        [downButton addTarget:self action:@selector(downAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:downButton];

        self.userInteractionEnabled = YES;

        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveGesture:)];
        [self addGestureRecognizer:panGesture];
        [panGesture release];

        [self selectSegment];
    }

    return self;
}

- (void)dealloc {
    [info release];
    [toolbar release];
    [leftButton release];
    [rightButton release];
    [upButton release];
    [downButton release];

    [super dealloc];
}

@end