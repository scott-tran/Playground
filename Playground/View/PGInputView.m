//
//  Created by stran on 3/4/12.
//
//


#import "PGInputView.h"
#import "PGAction.h"


@implementation PGInputView {

}

@synthesize delegate;

- (void)activateKeyboard {
    [inputView becomeFirstResponder];
}

- (void)deactivateKeyboard {
    [inputView resignFirstResponder];
}

- (void)sendAction:(PGAction)action {
    if (delegate) {
        [delegate receiveAction:action];
    }
}
                                       
- (void)textViewDidBeginEditing:(UITextView *)textView {
    for (UIWindow *w in [[UIApplication sharedApplication] windows]) {
        if (!w.keyWindow) {
            w.hidden = YES;
        }
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    NSRange selection = textView.selectedRange;
    switch (selection.location) {
        case 0:
            [self sendAction:PGMoveUp];
            textView.selectedRange = NSMakeRange(2, 0);
        break;
        case 1:
            [self sendAction:PGMoveLeft];
            textView.selectedRange = NSMakeRange(2, 0);
        break;
        case 3:
            [self sendAction:PGMoveRight];
            textView.selectedRange = NSMakeRange(2, 0);
        break;
        case 4:
            [self sendAction:PGMoveDown];
            textView.selectedRange = NSMakeRange(2, 0);
        break;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"s"]) {
        [self sendAction:PGDecreaseHeight];
    } else if ([text isEqualToString:@"w"]) {
        [self sendAction:PGIncreaseHeight];
    } else if ([text isEqualToString:@"a"]) {
        [self sendAction:PGDecreaseWidth];
    } else if ([text isEqualToString:@"d"]) {
        [self sendAction:PGIncreaseWidth];
    } else if ([text isEqualToString:@"j"]) {
        [self sendAction:PGMoveLeftInViews];
    } else if ([text isEqualToString:@"l"]) {
        [self sendAction:PGMoveRightInViews];
    } else if ([text isEqualToString:@"i"]) {
        [self sendAction:PGMoveUpInViews];
    } else if ([text isEqualToString:@"k"]) {
        [self sendAction:PGMoveDownInViews];
    } else if ([text isEqualToString:@"p"]) {
        [self sendAction:PGProperties];
    } else if ([text isEqualToString:@"m"]) {
        [self sendAction:PGMailProperties];
    }

    return NO;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        inputView = [[UITextView alloc] initWithFrame:frame];
        inputView.text = @"\n11\n";
        inputView.selectedRange = NSMakeRange(2, 0);
        inputView.delegate = self;
        [self addSubview:inputView];

        self.hidden = YES;
    }

    return self;
}

- (void)dealloc {
    [inputView release];

    [super dealloc];
}

@end