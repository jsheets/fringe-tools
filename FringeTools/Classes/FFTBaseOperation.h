//
//  BaseOperation.h
//  FringeTools
//
//  Created by John Sheets on 9/25/10.
//  Copyright 2010 FourFringe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFTBaseOperation : NSOperation
{
    BOOL _executing;
    BOOL _finished;
}

- (void)performOperation;
- (void)completeOperation;

@end
