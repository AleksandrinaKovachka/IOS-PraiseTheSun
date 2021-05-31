//
//  DictionaryFileCreator.h
//  PraiseTheSun
//
//  Created by A-Team Intern on 27.05.21.
//

#import <Foundation/Foundation.h>
#import "Dictionary.h"

NS_ASSUME_NONNULL_BEGIN

@interface DictionaryFileContent : NSObject

@property (strong, nonatomic) NSMutableDictionary<NSString*, NSString*>* englishWordsDictionary;

@property (strong, nonatomic) NSMutableDictionary<NSString*, NSString*>* bulgarianWordsDictionary;

-(instancetype)init;

@end

NS_ASSUME_NONNULL_END
