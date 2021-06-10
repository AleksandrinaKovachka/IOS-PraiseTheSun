//
//  WordsTableViewController.h
//  PraiseTheSun
//
//  Created by A-Team Intern on 25.05.21.
//

#import <UIKit/UIKit.h>
#import <PredictiveTextSearch/KeypadSearchBar.h>

NS_ASSUME_NONNULL_BEGIN

@interface WordsTableViewController : UITableViewController<SuggestedWordsDelegate>

@property (weak, nonatomic) id<UserWordsChoiceDelegate> userWordsChoiceDelegate;

@end

NS_ASSUME_NONNULL_END
