//
//  QuoteService.h
//  quotewidget
//
//  Created by Duy Quang on 4/4/16.
//  Copyright © 2016 duyquang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuoteData.h"
#import "AFNetworking.h"

typedef void (^blockDone) (QuoteData* quoteData, NSError* error);

@interface QuoteService : NSObject

@property (strong,nonatomic) AFHTTPRequestOperationManager *manager;

-(void)getQuoteDataWithBlock:(blockDone) completed;

@end
