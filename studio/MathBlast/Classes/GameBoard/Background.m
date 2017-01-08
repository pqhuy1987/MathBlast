//
//  Background.m
//  MathBlast
//
//  Created by JRamos on 6/8/13.
//  Copyright 2013 JRamos. All rights reserved.
//

#import "Background.h"
#import "Gems.h"

//This class manages any background images/ animation
@implementation Background{
    
    CGSize _winSize;
    
    GameController *gameController;
    
    CCParticleSystemQuad *emitter;
    
    CCSprite *detailMenu;
    CCMenu *menuMenuButton;
    CCMenu *menuMenuAlertButton;
    CCSprite *menuAlert;
    
    bool isPaused;

}

-(id) initWithController:(id)gc
{
    // always call "super" init
    // Apple recommends to re-assign "self" with the "super" return value
    if( (self=[super init] )) {
        _winSize = [CCDirector sharedDirector].winSize;
        gameController = gc;
        [self setupBackground];
        [self setupGrid];
        [self setupTimerBorder];
        [self setupDetailBorder];
        [self setupScoreBorder];
    }
    return self;
}

- (void)setupEmitter
{
    emitter = [CCParticleSystemQuad particleWithFile:@"progress.plist"];
    emitter.position = ccp(-200, 575);
    
    [self addChild:emitter z:1];
    
    [emitter runAction:
     [CCSequence actions:
      [CCDelayTime actionWithDuration:2],
      [CCMoveTo actionWithDuration:3 position:ccp(256  , 430)],
      nil]];
    
    
}

-(void) setupBackground
{
    CCSprite *bck = [CCSprite spriteWithFile:@"back2.jpg"];
    bck.position = ccp(_winSize.width/2, _winSize.height/2);
    [self addChild:bck];
    
    [self setupEmitter];
}

-(void) setupGrid
{
    CCSprite *grid = [CCSprite spriteWithFile:@"bckgrid.png"];
    grid.position = ccp(1600,383);
    [self addChild:grid];
    
    [grid runAction:
    [CCSequence actions:
     [CCDelayTime actionWithDuration:2],
     [CCMoveTo actionWithDuration:3 position:ccp(668, 383)],
     nil]];
}

-(void) setupTimerBorder
{
    CCSprite *timer = [CCSprite spriteWithFile:@"timerBorder.png"];
    timer.position = ccp(-200, 684);
    [self addChild:timer];
    
    [timer runAction:
     [CCSequence actions:
      [CCDelayTime actionWithDuration:2],
      [CCMoveTo actionWithDuration:3 position:ccp(170, 684)],
      nil]];
}

-(void) setupDetailBorder
{
    CCSprite *detailBorder = [CCSprite spriteWithFile:@"detailBorder.png"];
    detailBorder.position = ccp(-200, 275);
    [self addChild:detailBorder];
    
    detailMenu = [CCSprite spriteWithFile:@"detailMenu.png"];
    detailMenu.position = ccp(-200, 87);
    [self addChild:detailMenu];
    
    [detailBorder runAction:
     [CCSequence actions:
      [CCDelayTime actionWithDuration:2],
      [CCMoveTo actionWithDuration:3 position:ccp(175, 267)],
      nil]];
    
    [detailMenu runAction:
     [CCSequence actions:
      [CCDelayTime actionWithDuration:2],
      [CCMoveTo actionWithDuration:3 position:ccp(175, 87)],
      [CCCallFuncN actionWithTarget:self selector:@selector(makeMenuLive)],
      nil]];
    
}

-(void) setupScoreBorder
{
    CCSprite *score = [CCSprite spriteWithFile:@"scoreBorder.png"];
    score.position = ccp(-200, 570);
    [self addChild:score];
    
    CCSprite *treasure = [CCSprite spriteWithFile:@"treasureChest.png"];
    treasure.position = ccp(-200, 570);
    [self addChild:treasure];
    
    CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:@"Treasure Chest Value" fontName:@"Avenir-Heavy" fontSize:16];
    scoreLabel.color = ccYELLOW;
    scoreLabel.position = ccp(-200, 595);
    [self addChild:scoreLabel];
    
    [score runAction:
     [CCSequence actions:
      [CCDelayTime actionWithDuration:2],
      [CCMoveTo actionWithDuration:3 position:ccp(175, 570)],
      nil]];
    
    [treasure runAction:
     [CCSequence actions:
      [CCDelayTime actionWithDuration:2],
      [CCMoveTo actionWithDuration:3 position:ccp(78, 570)],
      nil]];
    
    [scoreLabel runAction:
     [CCSequence actions:
      [CCDelayTime actionWithDuration:2],
      [CCMoveTo actionWithDuration:3 position:ccp(210, 595)],
      nil]];
}

-(void) makeMenuLive
{
    [self removeChild:detailMenu cleanup:YES];
    
    CCSprite *menuButtonSprite = [CCSprite spriteWithFile:@"detailMenu.png"];
    
    CCMenuItemSprite *menuSprite = [CCMenuItemSprite itemWithNormalSprite:menuButtonSprite selectedSprite:nil target:self selector:@selector(menuTapped)];
    
    menuMenuButton = [CCMenu menuWithItems:menuSprite, nil];
    
    menuMenuButton.position = ccp(175, 87);
    menuMenuButton.scale = 1;
    menuMenuButton.tag = 10;
    
    [self addChild:menuMenuButton z:5];
    
    [menuMenuButton setEnabled:YES];
}

-(void) menuTapped
{
    if(!isPaused && !gameController.isGameOver)
    {
        for (Gems *sprite in gameController.spriteArray) {
            [sprite hide];
        }
        [self showMenuAlert];
        [[CCDirector sharedDirector] pause];
        isPaused = YES;
        [menuMenuButton setEnabled:NO];
        [menuMenuAlertButton setEnabled:YES];
    }
    else if(isPaused && !gameController.isGameOver){
        for (Gems *sprite in gameController.spriteArray) {
            [sprite show];
        }
        [[CCDirector sharedDirector] resume];
        [[CCDirector sharedDirector] startAnimation];
        isPaused = NO;
        [menuMenuButton setEnabled:YES];
        [menuMenuAlertButton setEnabled:NO];
        [self removeChild:menuMenuAlertButton];
        [self removeChild:menuAlert];
    }
}

-(void) showMenuAlert
{
    menuAlert = [CCSprite spriteWithFile:@"pauseMenu.png"];
    menuAlert.position = ccp(_winSize.width/2, _winSize.height/2);
    [self addChild:menuAlert z:6];
    
    CCSprite *menuButtonAlertSprite = [CCSprite spriteWithFile:@"pauseMenuButton.png"];
    
    CCMenuItemSprite *menuAlertSprite = [CCMenuItemSprite itemWithNormalSprite:menuButtonAlertSprite selectedSprite:nil target:self selector:@selector(menuTapped)];
    
    menuMenuAlertButton = [CCMenu menuWithItems:menuAlertSprite, nil];
    
    menuMenuAlertButton.position = ccp(_winSize.width/2 - 2, _winSize.height/2 - 30);
    menuMenuAlertButton.tag = 10;
    
    [self addChild:menuMenuAlertButton z:6];
}

@end
