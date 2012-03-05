//
//  Created by stran on 3/4/12.
//
//


#import <Foundation/Foundation.h>

typedef enum {
    PGMoveLeft,
    PGMoveRight,
    PGMoveUp,
    PGMoveDown,
    PGIncreaseWidth,
    PGDecreaseWidth,
    PGIncreaseHeight,
    PGDecreaseHeight,
    PGMoveLeftInViews,
    PGMoveRightInViews,
    PGMoveUpInViews,
    PGMoveDownInViews,
    PGProperties
} PGInputAction;

@protocol PGInputViewDelegate
- (void)inputAction:(PGInputAction)action;
@end

@interface PGInputView : UIView
        <UITextViewDelegate> {

    UITextView *inputView;

    __weak id <PGInputViewDelegate> delegate;
}

@property(weak) id <PGInputViewDelegate> delegate;

- (void)activateKeyboard;

- (void)deactivateKeyboard;
@end