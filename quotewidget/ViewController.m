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

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSUserDefaults *check = [NSUserDefaults standardUserDefaults];
    if([check boolForKey:@"isPurchased"]) {
        _full.adUnitID = @"";
        _banner.adUnitID = @"";
        [_banner setHidden:YES];
        CGRect frame = _banner.frame;
        frame.size.height = 1;
        [_banner setFrame:frame];
    }
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

- (IBAction)removeAdsAction:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Remove Ads" message:@"Purchase $0.99 to remove all Ads in App. If you have purchased before, you can restore purchase. After purchasing, you need to restart App to take effect." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Purchase" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if([SKPaymentQueue canMakePayments]) {
            SKProductsRequest *request = [[SKProductsRequest alloc]initWithProductIdentifiers:[NSSet setWithObject:@"quotewidget"]];
            request.delegate = self;
            [request start];
        } else NSLog(@"Can't payment");
    }];
    
    UIAlertAction *restore = [UIAlertAction actionWithTitle:@"Restore Purchase" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:ok];
    [alert addAction:restore];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    SKProduct *validProduct = nil;
    int count = [response.products count];
    if(count > 0){
        validProduct = [response.products objectAtIndex:0];
        NSLog(@"Products Available!");
        [self purchase:validProduct];
    }
    else if(!validProduct){
        NSLog(@"No products available");
        //this is called if your product id is not valid, this shouldn't be called unless that happens.
    }
}

- (void)purchase:(SKProduct *)product{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"received restored transactions: %d", queue.transactions.count);
    for(SKPaymentTransaction *transaction in queue.transactions){
        if(transaction.transactionState == SKPaymentTransactionStateRestored){
            //called when the user successfully restores a purchase
            NSLog(@"Transaction state -> Restored");
            
            //if you have more than one in-app purchase product,
            //you restore the correct product for the identifier.
            //For example, you could use
            //if(productID == kRemoveAdsProductIdentifier)
            //to get the product identifier for the
            //restored purchases, you can use
            //
            //NSString *productID = transaction.payment.productIdentifier;
            [self setPurchased];
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            break;
        }
    }   
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    for(SKPaymentTransaction *transaction in transactions){
        switch(transaction.transactionState){
            case SKPaymentTransactionStatePurchasing: NSLog(@"Transaction state -> Purchasing");
                //called when the user is in the process of purchasing, do not add any of your own code here.
                break;
            case SKPaymentTransactionStatePurchased:
                //this is called when the user has successfully purchased the package (Cha-Ching!)
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSLog(@"Transaction state -> Purchased");
                [self setPurchased];
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Transaction state -> Restored");
                //add the same code as you did from SKPaymentTransactionStatePurchased here
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                //called when the transaction does not finish
                if(transaction.error.code == SKErrorPaymentCancelled){
                    NSLog(@"Transaction state -> Cancelled");
                    //the user cancelled the payment ;(
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
        }
    }
}

-(void)setPurchased {
    NSUserDefaults *check = [NSUserDefaults standardUserDefaults];
    [check setBool:YES forKey:@"isPurchased"];
    [check synchronize];
}

@end
