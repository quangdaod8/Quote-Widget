//
//  QuoteService.m
//  quotewidget
//
//  Created by Duy Quang on 4/4/16.
//  Copyright © 2016 duyquang. All rights reserved.
//

#import "QuoteService.h"

@implementation QuoteService

-(void)getQuoteDataWithBlock:(blockDone)completed {
    
    self.manager = [[AFHTTPRequestOperationManager alloc]init];
    
    NSString *address= @"https://andruxnet-random-famous-quotes.p.mashape.com/?cat=famous";
    
    //NSMutableDictionary *data=[[NSMutableDictionary alloc]init];
    
    //[data setObject:@"c6LRJ2ECA0msho69g7wmj62iAzQgp1vsCD5jsnWHgjjGlNehrY" forKey:@"X-Mashape-Key"];
    //[data setObject:@"application/x-www-form-urlencoded" forKey:@"Content-Type"];
    //[data setObject:@"application/json" forKey:@"Accept"];
    
    //self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    self.manager.responseSerializer.acceptableContentTypes = [self.manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    
    [self.manager.requestSerializer setValue:@"Ly9RirKE75mshE59e2dGPvW4thQ9p1PoyHFjsnhe43x2wYZ4aY" forHTTPHeaderField:@"X-Mashape-Key"];
    
    [self.manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [self.manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [self.manager POST:address parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        QuoteData *data = [[QuoteData alloc]init];
        
        NSDictionary *item = responseObject;
        
        [data getSingleDataByItem:item];

        
        completed(data,nil);
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        completed(nil,error);
        
    }];

}

@end
