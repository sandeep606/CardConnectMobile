/********* CardConnectMobileiOS.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
// #import <PassKit/PassKit.h>
#import <CardConnectConsumerSDK/CardConnectConsumerSDK.h>


@interface CardConnectMobileiOS : CDVPlugin {
  // Member variables go here.
}
@property (nonatomic, strong) CCCCardInfo *card;


- (void)initialisePayment:(CDVInvokedUrlCommand*)command;
- (void)payWithCardDetails:(CDVInvokedUrlCommand*)command;
@end

@implementation CardConnectMobileiOS

// Method to initialise payment with endpoint.
- (void)initialisePayment:(CDVInvokedUrlCommand*)command
{

    NSLog(@"Parameters are %@", command.arguments);

    [CCCAPI instance].endpoint = @"fts-uat.cardconnect.com";
    if ([command.arguments[0] valueForKey:@"end_point"] == nil){

        [CCCAPI instance].endpoint = @"fts.cardconnect.com";
    }

    [CCCAPI instance].enableLogging = YES;    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Account added"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


- (void)payWithCardDetails:(CDVInvokedUrlCommand*)command{

    __block CDVPluginResult* pluginResult = nil;

    if ([(NSMutableDictionary *)[command.arguments[0] allKeys] count] > 0 ) {
        
        self.card = [CCCCardInfo new];
        self.card.cardNumber = [command.arguments[0] valueForKey:@"card_number"];
        self.card.expirationDate = [command.arguments[0] valueForKey:@"card_expiry"];
        self.card.CVV = [command.arguments[0] valueForKey:@"card_cvv"];
        // self.card.postalCode = [command.arguments[0] valueForKey:@"card_postalcode"];
        // [MFSettings.sharedInstance setMerchantWithMerchantCodeWithMerchantCode:[command.arguments[0] valueForKey:@"card_number"]
        //                                                           merchantName:[command.arguments[0] valueForKey:@"card_expiry"]
        //                                                       merchantUserName:[command.arguments[0] valueForKey:@"card_cvv"]
        //                                                             isTestMode:isTestMode];
        [[CCCAPI instance] generateAccountForCard:self.card completion:^(CCCAccount * _Nullable account, NSError * _Nullable error) {
        // self.card = nil;
            if (account){
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:account.token];
            }
            else{
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
            }
        }];
    }
    else{

        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Please provide complete card details"];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}


@end
