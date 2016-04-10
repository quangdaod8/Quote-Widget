//
//  QuoteData.h
//  quotewidget
//
//  Created by Duy Quang on 4/4/16.
//  Copyright © 2016 duyquang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuoteData : NSObject

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* author;
@property (strong, nonatomic) NSString* category;

-(void)getSingleDataByItem:(NSDictionary*) item;

@end
