//
//  ViewController.m
//  CCService
//
//  Created by Sean Fields on 1/11/13.
//  Copyright (c) 2013 Sean Fields. All rights reserved.
//

#import "ViewController.h"
#import "ExampleService.h"

//Third party JSON library
#import "JSON.h"

//Set up as the delegate for the ExampleService
@interface ViewController () <ExampleServiceDelegate>

/* Private properties for the service and some interface outlets */
@property (nonatomic,strong) ExampleService *service;
@property (nonatomic,strong) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic,strong) IBOutlet UITextView *output;
@end

@implementation ViewController

/* synthesize the properties */
@synthesize service=_service;
@synthesize spinner=_spinner;
@synthesize output=_output;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


/* IBAction Methods */

//Send the request
-(IBAction)doRequest:(id)sender{
    //Start animating the activity indicator
    [self.spinner startAnimating];
    
    //if the service object already exits, cancel the request.
    if (self.service){
        [self.service cancelRequest];
    }
    //if it doesn't exist, create it.
    else {
        self.service=[[ExampleService alloc] init];
    }
    
    //set its deletage to self
    [self.service setDelegate:self];
    
    //create the NSURL object with whatever URL string.
    NSURL *url=[NSURL URLWithString:@"http://localhost/~seanfields/api/getDepartureLocations.php"];
    
    //send the request
    [self.service sendRequestWithURL:url];
}

//Cancel the request
-(IBAction)cancelRequest:(id)sender{
    [self.service cancelRequest];
    //and stop the spinner from animating
    [self.spinner stopAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//Delegate method called from the service
-(void)applyData:(NSMutableData *)data{
    //stop the spinner
    [self.spinner stopAnimating];
    
    //create a string from the response data;
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //display that string in the text view
    [self.output setText:responseString];
    
    //Just for giggles, parse the response string (only works if the response string actually IS JSON
    NSArray *rawdata=responseString.JSONValue;
    
    //display the raw data in the console
    NSLog(@"Response Data\n\n%@",rawdata);
}

@end
