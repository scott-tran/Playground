//
//  Created by stran on 3/11/12.
//
//

#import <QuartzCore/QuartzCore.h>
#import "PGToolbar.h"
#import "PGAction.h"
#import "PGWindow.h"

@implementation PGToolbar {

}

@synthesize target;
@synthesize delegate;
@synthesize commandButton;
@synthesize infoButton;
@synthesize leftButton;
@synthesize rightButton;
@synthesize upButton;
@synthesize downButton;
@synthesize commandBar;
@synthesize overlay;


- (void)updateTargetInfo {
    NSString *title = @"";
    if (target) {
        NSString *name = !target.accessibilityIdentifier ? NSStringFromClass([target class]) : target.accessibilityIdentifier;
        title = [NSString stringWithFormat:@" %@:%d\n  %@",
                                           name,
                                           target.tag,
                                           NSStringFromCGRect(target.frame)];
    }

    [infoButton setTitle:title forState:UIControlStateNormal];
}

- (void)sendAction:(PGAction)action {
    if (target && delegate) {
        [delegate receiveAction:action];
    }
}

- (void)leftAction {
    switch (mode) {
        case PGMoveMode:
            [self sendAction:PGMoveLeft];
            break;
        case PGResizeMode:
            [self sendAction:PGDecreaseWidth];
            break;
        case PGNavigateMode:
            [self sendAction:PGMoveLeftInViews];
            break;
    }
}

- (void)rightAction {
    switch (mode) {
        case PGMoveMode:
            [self sendAction:PGMoveRight];
            break;
        case PGResizeMode:
            [self sendAction:PGIncreaseWidth];
            break;
        case PGNavigateMode:
            [self sendAction:PGMoveRightInViews];
            break;
    }
}

- (void)upAction {
    switch (mode) {
        case PGMoveMode:
            [self sendAction:PGMoveUp];
            break;
        case PGResizeMode:
            [self sendAction:PGIncreaseHeight];
            break;
        case PGNavigateMode:
            [self sendAction:PGMoveUpInViews];
            break;
    }
}

- (void)downAction {
    switch (mode) {
        case PGMoveMode:
            [self sendAction:PGMoveDown];
            break;
        case PGResizeMode:
            [self sendAction:PGDecreaseHeight];
            break;
        case PGNavigateMode:
            [self sendAction:PGMoveDownInViews];
            break;
    }
}

- (void)changeMode {
    switch (mode) {
        case PGMoveMode:
            [leftButton setTitle:@"\u21e0" forState:UIControlStateNormal];
            [rightButton setTitle:@"\u21e2" forState:UIControlStateNormal];
            [upButton setTitle:@"\u21e1" forState:UIControlStateNormal];
            [downButton setTitle:@"\u21e3" forState:UIControlStateNormal];
            break;
        case PGResizeMode:
            [leftButton setTitle:@"\u21a4" forState:UIControlStateNormal];
            [rightButton setTitle:@"\u21a6" forState:UIControlStateNormal];
            [upButton setTitle:@"\u21a5" forState:UIControlStateNormal];
            [downButton setTitle:@"\u21a7" forState:UIControlStateNormal];
            break;
        case PGNavigateMode:
            [leftButton setTitle:@"\u219e" forState:UIControlStateNormal];
            [rightButton setTitle:@"\u21a0" forState:UIControlStateNormal];
            [upButton setTitle:@"\u219f" forState:UIControlStateNormal];
            [downButton setTitle:@"\u21a1" forState:UIControlStateNormal];
            break;
    }
}

- (void)selectCommand:(UIButton *)button {
    NSString *message = nil;
    NSString *title = [commandButton titleForState:UIControlStateNormal];

    CGRect frame = self.frame;
    frame.size.width = 50;

    [overlay removeFromSuperview];

    if (commandBar.superview) {
        [UIView animateWithDuration:0.15 animations:^{
            CGRect commandFrame = commandBar.frame;
            commandFrame.size.width = 50;
            commandBar.frame = commandFrame;
        }                completion:^(BOOL finished) {
            [commandBar removeFromSuperview];
        }];
    }

    switch (button.tag) {
        case 1:
            if (expanded) {
                frame.size.width = 244;
                overlay.frame = self.superview.bounds;
                [self.superview insertSubview:overlay belowSubview:self];

                [self addSubview:commandBar];
                [UIView animateWithDuration:0.15 animations:^{
                    CGRect commandFrame = commandBar.frame;
                    commandFrame.size.width = 244;
                    commandBar.frame = commandFrame;
                }];
            } else {
                expanded = YES;
                mode = PGMoveMode;
                title = @"\u271b";

                frame.size.height = 268;

                [self addSubview:infoButton];
                [self addSubview:leftButton];
                [self addSubview:rightButton];
                [self addSubview:upButton];
                [self addSubview:downButton];
            }

            break;
        case 2:
            mode = PGMoveMode;
            title = [button titleForState:UIControlStateNormal];
            message = @"Move";
            break;
        case 3:
            mode = PGResizeMode;
            title = [button titleForState:UIControlStateNormal];
            message = @"Resize";
            break;
        case 4:
            mode = PGNavigateMode;
            title = [button titleForState:UIControlStateNormal];
            message = @"Navigate";
            break;
        case 5:
            [self sendAction:PGMailProperties];
        case 6:
            expanded = NO;
            frame.size.height = 48;

            title = @"\u25C9";

            [infoButton removeFromSuperview];
            [leftButton removeFromSuperview];
            [rightButton removeFromSuperview];
            [upButton removeFromSuperview];
            [downButton removeFromSuperview];
            break;
    }

    if (message) {
        [PGWindow displayMessage:message];
    }

    [commandButton setTitle:title forState:UIControlStateNormal];

    // center along y
    frame.origin.y = CGRectGetMidY(self.superview.bounds) - frame.size.height / 2;

    self.clipsToBounds = YES;
    [UIView animateWithDuration:0.15 animations:^{
        self.frame = frame;
    }                completion:^(BOOL finished) {
        self.clipsToBounds = NO;
    }];


    [self changeMode];
}

- (UIImage *)backgroundImage {
    UIGraphicsBeginImageContext(CGSizeMake(1, 2));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:38 / 255.0 green:38 / 255.0 blue:38 / 255.0 alpha:1].CGColor);

    CGContextFillRect(context, CGRectMake(0, 0, 1, 2));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    return image;
}

- (UIButton *)createButtonWithBackground:(UIImage *)backgroundImage {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = 5;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = 2;
    button.clipsToBounds = YES;

    button.titleLabel.font = [UIFont boldSystemFontOfSize:30];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];

    return button;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, 50, 48);
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;

        UIImage *backgroundImage = [self backgroundImage];

        self.commandButton = [self createButtonWithBackground:backgroundImage];
        commandButton.frame = CGRectMake(2, 4, 45, 40);
        commandButton.tag = 1;
        [commandButton setTitle:@"\u25C9" forState:UIControlStateNormal];
        [commandButton addTarget:self action:@selector(selectCommand:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:commandButton];

        self.commandBar = [[[UIView alloc] initWithFrame:CGRectMake(2, 4, 230, 40)] autorelease];
        commandBar.clipsToBounds = YES;

        UIButton *move = [self createButtonWithBackground:backgroundImage];
        move.frame = CGRectMake(0, 0, 45, 40);
        move.tag = 2;
        [move setTitle:@"\u271b" forState:UIControlStateNormal];
        [move addTarget:self action:@selector(selectCommand:) forControlEvents:UIControlEventTouchUpInside];
        [commandBar addSubview:move];

        UIButton *resize = [self createButtonWithBackground:backgroundImage];
        resize.frame = CGRectMake(CGRectGetMaxX(move.frame) + 4, 0, 45, 40);
        resize.tag = 3;
        [resize setTitle:@"\u229e" forState:UIControlStateNormal];
        [resize addTarget:self action:@selector(selectCommand:) forControlEvents:UIControlEventTouchUpInside];
        [commandBar addSubview:resize];

        UIButton *navigate = [self createButtonWithBackground:backgroundImage];
        navigate.frame = CGRectMake(CGRectGetMaxX(resize.frame) + 4, 0, 45, 40);
        navigate.tag = 4;
        [navigate setTitle:@"\u2750" forState:UIControlStateNormal];
        [navigate addTarget:self action:@selector(selectCommand:) forControlEvents:UIControlEventTouchUpInside];
        [commandBar addSubview:navigate];

        UIButton *mail = [self createButtonWithBackground:backgroundImage];
        mail.frame = CGRectMake(CGRectGetMaxX(navigate.frame) + 4, 0, 45, 40);
        mail.tag = 5;
        [mail setTitle:@"\u25B3" forState:UIControlStateNormal];
        [mail addTarget:self action:@selector(selectCommand:) forControlEvents:UIControlEventTouchUpInside];
        [commandBar addSubview:mail];

        UIButton *collapse = [self createButtonWithBackground:backgroundImage];
        collapse.frame = CGRectMake(CGRectGetMaxX(mail.frame) + 4, 0, 45, 40);
        collapse.tag = 6;
        [collapse setTitle:@"\u25C9" forState:UIControlStateNormal];
        [collapse addTarget:self action:@selector(selectCommand:) forControlEvents:UIControlEventTouchUpInside];
        [commandBar addSubview:collapse];

        self.infoButton = [self createButtonWithBackground:backgroundImage];
        infoButton.frame = CGRectMake(2, CGRectGetMaxY(commandButton.frame) + 4, 130, 40);
        infoButton.titleLabel.font = [UIFont systemFontOfSize:11];
        infoButton.titleLabel.numberOfLines = 2;

        self.leftButton = [self createButtonWithBackground:backgroundImage];
        leftButton.frame = CGRectMake(2, CGRectGetMaxY(infoButton.frame) + 4, 45, 40);
        [leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];

        self.rightButton = [self createButtonWithBackground:backgroundImage];
        rightButton.frame = CGRectMake(2, CGRectGetMaxY(leftButton.frame) + 4, 45, 40);
        [rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];

        self.upButton = [self createButtonWithBackground:backgroundImage];
        upButton.frame = CGRectMake(2, CGRectGetMaxY(rightButton.frame) + 4, 45, 40);
        [upButton addTarget:self action:@selector(upAction) forControlEvents:UIControlEventTouchUpInside];

        self.downButton = [self createButtonWithBackground:backgroundImage];
        downButton.frame = CGRectMake(2, CGRectGetMaxY(upButton.frame) + 4, 45, 40);
        [downButton addTarget:self action:@selector(downAction) forControlEvents:UIControlEventTouchUpInside];

        self.overlay = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        overlay.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        overlay.backgroundColor = [UIColor blackColor];
        overlay.alpha = 0.5;
    }

    return self;
}

- (void)dealloc {
    [super dealloc];

    [commandButton release];
    [infoButton release];
    [leftButton release];
    [rightButton release];
    [upButton release];
    [downButton release];
    [commandBar release];
    [overlay release];
}

@end