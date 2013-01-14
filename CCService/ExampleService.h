//
//  ExampleService.h
//  CCService
//
//  Created by Sean Fields on 1/11/13.
//  Copyright (c) 2013 Sean Fields. All rights reserved.
//

#import <Foundation/Foundation.h>

//Delegate method
@protocol ExampleServiceDelegate <NSObject>

-(void)applyData:(NSMutableData *)data;

@end

@interface ExampleService : NSObject

//Public delegate property
@property (nonatomic, assign) id <ExampleServiceDelegate> delegate;

//Public methods
- (void)sendRequestWithURL:(NSURL *)url;
- (void)cancelRequest;

@end
