//
//  Created by stran on 3/11/12.
//
//


#import "PGToolbar.h"
#import "PGAction.h"

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


- (void)updateTargetInfo {
    if (target) {
        NSString *name = !target.accessibilityIdentifier ? NSStringFromClass([target class]) : target.accessibilityIdentifier;
        NSString *title = [NSString stringWithFormat:@" %@:%d\n  %@",
                                                     name,
                                                     target.tag,
                                                     NSStringFromCGRect(target.frame)];
        [infoButton setTitle:title forState:UIControlStateNormal];
    } else {
//        info.text = @"";
    }
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
    NSString *title = [commandButton titleForState:UIControlStateNormal];

    CGRect frame = self.frame;
    CGPoint center = self.center;
    frame.size.width = 50;

    [commandBar removeFromSuperview];
    switch (button.tag) {
        case 1:
            expanded = YES;
            frame.size.height = 268;
            frame.size.width = 196;
            [self addSubview:infoButton];
            [self addSubview:leftButton];
            [self addSubview:rightButton];
            [self addSubview:upButton];
            [self addSubview:downButton];

            [self addSubview:commandBar];
            break;
        case 2:
            mode = PGMoveMode;
            title = [button titleForState:UIControlStateNormal];
            break;
        case 3:
            mode = PGResizeMode;
            title = [button titleForState:UIControlStateNormal];
            break;
        case 4:
            mode = PGNavigateMode;
            title = [button titleForState:UIControlStateNormal];
            break;
        case 5:
            expanded = NO;
            frame.size.height = 48;
            [infoButton removeFromSuperview];
            [leftButton removeFromSuperview];
            [rightButton removeFromSuperview];
            [upButton removeFromSuperview];
            [downButton removeFromSuperview];
            break;
    }

    [commandButton setTitle:[button titleForState:UIControlStateNormal] forState:UIControlStateNormal];
    self.frame = frame;
    self.center = center;

    // pin to left
    frame = self.frame;
    frame.origin.x = 0;
    self.frame = frame;

    [self changeMode];
}

- (void)infoAction {
    NSLog(@"info action");
}

- (UIImage *)backgroundImage {
    UIGraphicsBeginImageContext(CGSizeMake(1, 2));
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:31/255.0 green:31/255.0 blue:31/255.0 alpha:1].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor darkGrayColor].CGColor);

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

        UIImage *backgroundImage = [self backgroundImage];

        self.commandButton = [self createButtonWithBackground:backgroundImage];
        commandButton.frame = CGRectMake(2, 4, 45, 40);
        commandButton.tag = 1;
        [commandButton setTitle:@"\u25C9" forState:UIControlStateNormal];
        [commandButton addTarget:self action:@selector(selectCommand:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:commandButton];

        self.commandBar = [[UIView alloc] initWithFrame:CGRectMake(2, 4, 190, 40)];
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

        UIButton *collapse = [self createButtonWithBackground:backgroundImage];
        collapse.frame = CGRectMake(CGRectGetMaxX(navigate.frame) + 4, 0, 45, 40);
        collapse.tag = 5;
        [collapse setTitle:@"\u25C9" forState:UIControlStateNormal];
        [collapse addTarget:self action:@selector(selectCommand:) forControlEvents:UIControlEventTouchUpInside];
        [commandBar addSubview:collapse];

        self.infoButton = [self createButtonWithBackground:backgroundImage];
        infoButton.frame = CGRectMake(2, CGRectGetMaxY(commandButton.frame) + 4, 130, 40);
        infoButton.titleLabel.font = [UIFont systemFontOfSize:12];
        infoButton.titleLabel.numberOfLines = 2;
        [infoButton addTarget:self action:@selector(infoAction) forControlEvents:UIControlEventTouchUpInside];

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

//        [self changeMode];

//        [self configureToolbar];
    }

    return self;
}

@end