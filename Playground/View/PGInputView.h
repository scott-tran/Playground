//
//  Created by stran on 3/4/12.
//
//


#import <Foundation/Foundation.h>

@protocol PGActionDelegate;


@interface PGInputView : UIView
        <UITextViewDelegate> {

    UITextView *inputView;

    id<PGActionDelegate> delegate;
}

@property(assign) id<PGActionDelegate> delegate;

- (void)activateKeyboard;

- (void)deactivateKeyboard;
@end