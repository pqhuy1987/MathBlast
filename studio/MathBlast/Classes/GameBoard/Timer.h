//
//  Timer.h
//  MathBlast
//
//  Created by JRamos on 6/9/13.
//  Copyright 2013 JRamos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Timer : CCLayer

@property (nonatomic) int totalSeconds;

-(void) startTimer;


@end
