//
//  Created by stran on 3/9/12.
//
//

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
    PGProperties,
    PGMailProperties
} PGAction;

@protocol PGActionDelegate
- (void)receiveAction:(PGAction)action;

@end