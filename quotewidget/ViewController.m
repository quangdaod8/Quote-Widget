//
//  ViewController.m
//  quotewidget
//
//  Created by Duy Quang on 4/4/16.
//  Copyright © 2016 duyquang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _full = [[GADInterstitial alloc]initWithAdUnitID:@"ca-app-pub-9719677587937425/7190512590"];
    _full.delegate = self;
    [_full loadRequest:[GADRequest request]];
    
    
    _banner.adUnitID = @"ca-app-pub-9719677587937425/2292968199";
    _banner.rootViewController = self;
    [_banner loadRequest:[GADRequest request]];
    
    self.navigationItem.title = @"Quote Widget";
    
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(getQuote)];
    
    UIBarButtonItem *share = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share)];
    
    self.navigationItem.leftBarButtonItem = refresh;
    self.navigationItem.rightBarButtonItem = share;
    
    _service = [[QuoteService alloc]init];
    [self getQuote];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)getQuote {
    
    self.lblQuote.text = @"Loading...";
    self.lblAuthor.text = @"";
    
    [_service getQuoteDataWithBlock:^(QuoteData *quoteData, NSError *error) {
        if(!error) {
            self.lblQuote.text = [NSString stringWithFormat:@"\" %@ \"",quoteData.title];
            self.lblAuthor.text = quoteData.author;
        } else {
            self.lblQuote.text = error.localizedDescription;
            self.lblAuthor.text = @"Error";
        }
    }];
}

-(void)share {
    UIActivityViewController *share = [[UIActivityViewController alloc]initWithActivityItems:@[[NSString stringWithFormat:@"%@\n%@\n\n",_lblQuote.text,_lblAuthor.text],[NSURL URLWithString:@"https://itunes.apple.com/us/app/quote-widget/id1099958795?ls=1&mt=8"]] applicationActivities:nil];
    
    UIPopoverPresentationController *popPresenter = [share popoverPresentationController];
    popPresenter.sourceView = self.view;
    popPresenter.sourceRect = _lblQuote.frame;
    
    if(_full.isReady) [_full presentFromRootViewController:self];
    else [self presentViewController:share animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnShareAction:(id)sender {
    UIActivityViewController *share = [[UIActivityViewController alloc]initWithActivityItems:@[@"The Amazing Quote Collection gets even better on your Widget with just a swipe away.\n",[NSURL URLWithString:@"https://itunes.apple.com/us/app/quote-widget/id1099958795?ls=1&mt=8"]] applicationActivities:nil];
    
    UIPopoverPresentationController *popPresenter = [share popoverPresentationController];
    popPresenter.sourceView = self.view;
    popPresenter.sourceRect = _btnShareApp.frame;
    
    [self presentViewController:share animated:YES completion:nil];
}

- (IBAction)btnRateAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1099958795&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software"]];
}

-(void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    _full = [[GADInterstitial alloc]initWithAdUnitID:@"ca-app-pub-9719677587937425/7190512590"];
    _full.delegate = self;
    [_full loadRequest:[GADRequest request]];
    
    
    UIActivityViewController *share = [[UIActivityViewController alloc]initWithActivityItems:@[[NSString stringWithFormat:@"%@\n%@\n\n",_lblQuote.text,_lblAuthor.text],[NSURL URLWithString:@"https://itunes.apple.com/us/app/quote-widget/id1099958795?ls=1&mt=8"]] applicationActivities:nil];
    
    UIPopoverPresentationController *popPresenter = [share popoverPresentationController];
    popPresenter.sourceView = self.view;
    popPresenter.sourceRect = _lblQuote.frame;
    
    [self presentViewController:share animated:YES completion:nil];
    
}

@end
