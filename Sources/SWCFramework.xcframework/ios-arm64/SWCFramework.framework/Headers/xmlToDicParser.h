//
//  xmlToDicParser.h
//  DEWASmart
//
//  Created by DEWA on 9/2/13.
//  Copyright (c) 2013 DEWA. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface xmlToDicParser : NSObject<NSXMLParserDelegate>
{
    NSMutableArray *dictionaryStack;
    NSMutableString *textInProgress;
    //NSString *leafElementName;

    NSError *errorPointer;
    

}
- (NSDictionary *)objectWithData:(NSData *)data;

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError *)errorPointer;
+ (NSDictionary *)dictionaryForXMLString:(NSString *)string;

@end
