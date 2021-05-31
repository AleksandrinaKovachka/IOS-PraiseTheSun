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

//one letter
//@property (readonly) char letter;

//language
@property (assign) EnumLanguage language;


//init with this one letter - initialize array with index from file
-(instancetype)init;//WithLanguage:(NSString*)language;

//load data for letter position
//-(void)loadPositions;

//function to search by part of word - return words starting with this part - if user push on word ?
-(NSArray<NSString*>*)wordsStartedWith:(NSString*)word;

-(NSString*)descriptionOfWord:(NSString*)word;

@end

NS_ASSUME_NONNULL_END
