//
//  Dictionaries.h
//  PraiseTheSun
//
//  Created by A-Team Intern on 3.06.21.
//

#import <Foundation/Foundation.h>
#import "DictionaryFileContent.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum
{
    EnumLanguageBG,
    EnumLanguageEN
} EnumLanguage;

@interface Dictionaries : NSObject

@property (strong, nonatomic) NSDictionary<NSString*, NSString*>* englishWordsDictionary;
@property (strong, nonatomic) NSDictionary<NSString*, NSString*>* bulgarianWordsDictionary;

-(instancetype)init;

-(NSDictionary<NSString*, NSString*>*)dictionaryWith:(EnumLanguage)language;

@end

NS_ASSUME_NONNULL_END
