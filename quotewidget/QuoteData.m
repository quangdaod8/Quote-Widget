//
//  QuoteData.m
//  quotewidget
//
//  Created by Duy Quang on 4/4/16.
//  Copyright © 2016 duyquang. All rights reserved.
//

#import "QuoteData.h"

@implementation QuoteData

-(void)getSingleDataByItem:(NSDictionary *)item {
    _title = item[@"quote"];
    _author = item[@"author"];
    _category = item[@"category"];
}

@end
