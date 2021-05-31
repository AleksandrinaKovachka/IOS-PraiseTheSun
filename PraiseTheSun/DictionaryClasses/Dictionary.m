//
//  Dictionary.m
//  PraiseTheSun
//
//  Created by A-Team Intern on 14.05.21.
//

#import "Dictionary.h"
#import "NotificationNames.h"

@interface Dictionary ()

@property (strong, nonatomic) NSDictionary<NSString*, NSString*>* englishWordsDictionary;

@property (strong, nonatomic) NSDictionary<NSString*, NSString*>* bulgarianWordsDictionary;


@end

@implementation Dictionary

-(instancetype)init
{
    if ([super init])
    {
        DictionaryFileContent* dictionaryContent = [[DictionaryFileContent alloc] init];
        self.englishWordsDictionary = dictionaryContent.englishWordsDictionary;
        self.bulgarianWordsDictionary = dictionaryContent.bulgarianWordsDictionary;
        
        self.numberOfSuggestedWord = 10;
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didChangeNumberOfSuggestedWords:) name:NOTIFICATION_CHANGE_NUMBER_OF_SUGGESTED_WORDS object:nil];
    }
    
    return self;
}

-(void)didChangeNumberOfSuggestedWords:(NSNotification*)notification
{
    self.numberOfSuggestedWord = [notification.object intValue] - 1;
}

-(NSDictionary<NSString *, NSString *> *)activeDictionary
{
    if (self.language == EnumLanguageEN)
    {
        return self.englishWordsDictionary;
    }
    return self.bulgarianWordsDictionary;
}

//TODO: only part of words - user choice
-(NSArray<NSString*>*)wordsStartedWith:(NSString*)word
{
    if ([word isEqual:@""])
    {
        return @[];
    }
    
    NSString* curWord = [word uppercaseString];
    
    //TODO: maybe something more efficient
    if ([self.englishWordsDictionary objectForKey:[curWord substringWithRange:NSMakeRange(0, 1)]])
    {
        self.language = EnumLanguageEN;
    }
    else
    {
        self.language = EnumLanguageBG;
    }
    
    NSMutableArray<NSString*>* wordsWithCommonPrefix = [[NSMutableArray alloc] init];
    
    [self didHaveWord:curWord];
    
    [self commonPrefixedWordsTo:curWord andWordsCommenPrefixArr:wordsWithCommonPrefix];
    
    return wordsWithCommonPrefix;
}

-(void)didHaveWord:(NSString*)word
{
    if ([[self activeDictionary] objectForKey:word])
    {
        NSString* wordWithDescription = [self.activeDictionary objectForKey:word];
        
        //notification to change word description
        [NSNotificationCenter.defaultCenter postNotificationName:NOTIFICATION_HAVE_WORD object:wordWithDescription userInfo:nil];
    }
}

-(void)commonPrefixedWordsTo:(NSString*)word andWordsCommenPrefixArr:(NSMutableArray<NSString*>*)wordsWithCommonPrefix
{
    NSArray<NSString*>* sortedKeys = [[self.activeDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    for (NSString* key in sortedKeys)
    {
        if (key.length >= word.length && [key hasPrefix:word])
        {
            [wordsWithCommonPrefix addObject:key];
        }
        if (wordsWithCommonPrefix.count > self.numberOfSuggestedWord)
        {
            break;
        }
    }
    
    if (wordsWithCommonPrefix.count < self.numberOfSuggestedWord) //TODO: user choice
    {
        NSString* part = [word substringWithRange:NSMakeRange(0, word.length - 1)];
        
        return [self commonPrefixedWordsTo:part andWordsCommenPrefixArr:wordsWithCommonPrefix];
    }
}

-(NSString*)descriptionOfWord:(NSString*)word
{
    return self.activeDictionary[word];
}

@end
