//
//  DictionaryViewController.m
//  PraiseTheSun
//
//  Created by A-Team Intern on 25.05.21.
//

#import "DictionaryViewController.h"
#import "NotificationNames.h"

@interface DictionaryViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *wordSearchBar;
@property (weak, nonatomic) IBOutlet UITextView *currentWordDescription;
@property (assign) BOOL keystrokeTranslateState;


@end

@implementation DictionaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.wordSearchBar.delegate = self;
    self.keystrokeTranslateState = YES;
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didHaveWordInDictionary:) name:NOTIFICATION_HAVE_WORD object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didChangeKeystrokeTranslateState:) name:NOTIFICATION_CHANGE_KEYSTROKE_TRANSLATE object:nil];
    // Do any additional setup after loading the view.
}

//TODO: different notification for user choice
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString* partOfWord = searchBar.text;
    
    self.currentWordDescription.text = partOfWord;
    
    if (self.keystrokeTranslateState == YES)
    {
        [NSNotificationCenter.defaultCenter postNotificationName:NOTIFICATION_CHANGE_WORD object:partOfWord userInfo:nil];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString* partOfWord = searchBar.text;
    
    [NSNotificationCenter.defaultCenter postNotificationName:NOTIFICATION_CHANGE_WORD object:partOfWord userInfo:nil];
}

-(void)didHaveWordInDictionary:(NSNotification*)notification
{
    self.currentWordDescription.text = notification.object;
}

-(void)didChangeKeystrokeTranslateState:(NSNotification*)notification
{
    if ([notification.object isEqualToString:@"On"])
    {
        self.keystrokeTranslateState = YES;
    }
    else
    {
        self.keystrokeTranslateState = NO;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
