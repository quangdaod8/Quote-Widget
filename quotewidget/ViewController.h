//
//  ViewController.h
//  quotewidget
//
//  Created by Duy Quang on 4/4/16.
//  Copyright © 2016 duyquang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuoteService.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface ViewController : UIViewController<GADInterstitialDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblQuote;
@property (weak, nonatomic) IBOutlet UILabel *lblAuthor;

- (IBAction)btnShareAction:(id)sender;
- (IBAction)btnRateAction:(id)sender;
@property (weak, nonatomic) IBOutlet GADBannerView *banner;
@property (strong, nonatomic) GADInterstitial *full;
@property (weak, nonatomic) IBOutlet UIButton *btnShareApp;

@property (strong, nonatomic) QuoteService *service;


@end

