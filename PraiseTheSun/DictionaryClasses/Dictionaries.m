//
//  Dictionaries.m
//  PraiseTheSun
//
//  Created by A-Team Intern on 3.06.21.
//

#import "Dictionaries.h"


@implementation Dictionaries

-(instancetype)init
{
    if ([super init])
    {
        DictionaryFileContent* dictionaryContent = [[DictionaryFileContent alloc] init];
        self.englishWordsDictionary = dictionaryContent.englishWordsDictionary;
        self.bulgarianWordsDictionary = dictionaryContent.bulgarianWordsDictionary;
    }
    
    return self;
}

-(NSDictionary<NSString*, NSString*>*)dictionaryWith:(EnumLanguage)language
{
    if (language == EnumLanguageEN)
    {
        return self.englishWordsDictionary;
    }
    return self.bulgarianWordsDictionary;
}

@end
