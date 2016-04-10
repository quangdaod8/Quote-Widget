//
//  TodayViewController.h
//  widget
//
//  Created by Duy Quang on 4/4/16.
//  Copyright © 2016 duyquang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuoteService.h"

@interface TodayViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblQuote;
@property (weak, nonatomic) IBOutlet UILabel *lblAuthor;

@property (strong, nonatomic) QuoteService *service;

@end
