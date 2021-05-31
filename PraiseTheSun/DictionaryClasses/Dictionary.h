//
//  Dictionary.h
//  PraiseTheSun
//
//  Created by A-Team Intern on 14.05.21.
//

#import <Foundation/Foundation.h>
#import "DictionaryFileContent.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum
{
    EnumLanguageBG,
    EnumLanguageEN
} EnumLanguage;

@interface Dictionary : NSObject

@property (assign) EnumLanguage language;
@property (assign) int numberOfSuggestedWord;

-(instancetype)init;

-(NSArray<NSString*>*)wordsStartedWith:(NSString*)word;

-(NSString*)descriptionOfWord:(NSString*)word;

@end

NS_ASSUME_NONNULL_END
