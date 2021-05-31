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

-(instancetype)init//WithLanguage:(NSString*)language
{
    if ([super init])
    {
        //TODO: [self loadWordsAndDescription];
        DictionaryFileContent* dictionaryContent = [[DictionaryFileContent alloc] init];
        self.englishWordsDictionary = dictionaryContent.englishWordsDictionary;
        self.bulgarianWordsDictionary = dictionaryContent.bulgarianWordsDictionary;
    }
    
    return self;
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
    
    //language
    //TODO : maybe something more efficient
    if ([self.englishWordsDictionary objectForKey:[curWord substringWithRange:NSMakeRange(0, 1)]])
    {
        self.language = EnumLanguageEN;
    }
    else
    {
        self.language = EnumLanguageBG;
    }
    
    [self didHaveWord:curWord];
    
    return [self commonPrefixedWordsTo:curWord];
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

-(NSArray<NSString*>*)commonPrefixedWordsTo:(NSString*)word
{
    NSMutableArray<NSString*>* wordsWithCommonPrefix = [[NSMutableArray alloc] init];
    
    //all keys
    for (NSString* key in self.activeDictionary)
    {
        if (key.length >= word.length && [key hasPrefix:word])
        {
                //[wordsToDisplay appendString:[NSString stringWithFormat:@"%@\n", self.wordsInDictionary[i]]];
            [wordsWithCommonPrefix addObject:key];
                //[wordsToDisplay addObject:[NSString stringWithFormat:@"%@\n%@", self.wordsInENDictionary[i], [self.wordsENDescription objectForKey: self.wordsInENDictionary[i]]]];
        }
    }
    
    if (wordsWithCommonPrefix.count < 10) //TODO: user choice
    {
        NSString* part = [word substringWithRange:NSMakeRange(0, word.length - 1)];
        
        return [self commonPrefixedWordsTo:part];
    }
    
    return wordsWithCommonPrefix;//[NSString stringWithString:wordsToDisplay];
}

-(NSString*)descriptionOfWord:(NSString*)word
{
    //return [[self activeDictionary] objectForKey:word];
    return self.activeDictionary[word];
}

@end
