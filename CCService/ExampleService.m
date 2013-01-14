//
//  ExampleService.m
//  CCService
//
//  Created by Sean Fields on 1/11/13.
//  Copyright (c) 2013 Sean Fields. All rights reserved.
//

#import "ExampleService.h"

@interface ExampleService ()
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSURLConnection *connection;
@end

@implementation ExampleService
@synthesize delegate=_delegate;
@synthesize receivedData=_receivedData;
@synthesize connection=_connection;

/* Public method to send a request */
- (void)sendRequestWithURL:(NSURL *)url {
    //Build the url request with the NSURL object from the sender
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:url
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    
    //Create the connection with the request
    self.connection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (self.connection) {
        //Create the data object to hold the results
        self.receivedData = [NSMutableData data];
    } else {
        //There is no connection for some reason, so handle that error here.
    }
}

/* Public method to cancel the request */
- (void)cancelRequest{
    //cancels the active request
    [self.connection cancel];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //Connection got a response.  Set the receivedData to zero to handle redirects.
    [self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //Connection received data, so append the received data object.
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connectiondidFailWithError:(NSError *)error
{
    // Connection failed, so handle the error
    NSLog(@"Connection failed! Error - %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //Connection succeeded, so send the receivedData back to the delegate.
    [self.delegate applyData:self.receivedData];
}

- (void)dealloc {
    //When this class is deallocated, setting it's delegate to nil protects against the possibilty of the request thread attempting to apply the data to a delegate that may no longer exist.
    //This situation, if not handled properly, causes an app crash.
    self.delegate=nil;
}


@end
