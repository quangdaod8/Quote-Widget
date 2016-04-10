//
//  TodayViewController.m
//  widget
//
//  Created by Duy Quang on 4/4/16.
//  Copyright © 2016 duyquang. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.service = [[QuoteService alloc]init];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.service getQuoteDataWithBlock:^(QuoteData *quoteData, NSError *error) {
        if(!error) {
            self.lblQuote.text = [NSString stringWithFormat:@"\" %@ \"",quoteData.title];
            self.lblAuthor.text = quoteData.author;
        } else {
            self.lblQuote.text = error.localizedDescription;
            self.lblAuthor.text = @"Error";
        }
    
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
