//
//  MyCocos2DClass.m
//  Mime
//
//  Created by Rahil Patel on 6/25/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "Node.h"
#import "NodeGroup.h"
#import "NodeSuperGroup.h"

@implementation GameScene

#pragma mark - overridden functions
+ (CCScene *) scene {
	CCScene *scene = [CCScene node];
	GameScene *layer = [GameScene node];
	[scene addChild: layer];
	
	return scene;
}

- (id) init {
	if(!(self=[super init]))
        return nil;
    
    [self setIsTouchEnabled:YES];
    //[[CCDirector sharedDirector] setAnimationInterval:1/240.0]; // todo: testing
    
    nodeSuperGroup = [[NodeSuperGroup nodeSuperGroup] retain];
    [self addChild:nodeSuperGroup];
    
    CGSize ws = [[CCDirector sharedDirector] winSize];
    CGRect bottomTouchAreaRectangle = CGRectMake(0, 0, ws.width, 200);
    bottomTouchArea = [CCSprite spriteWithFile:@"white.png" rect:bottomTouchAreaRectangle];
    bottomTouchArea.color = ccc3(0, 255, 0);
    bottomTouchArea.opacity = 255/4;
    bottomTouchArea.position = ccp(bottomTouchArea.contentSize.width/2, bottomTouchArea.contentSize.height/2);
    [self addChild:bottomTouchArea z:10];
    
    CGRect bottomCreationLineRect = CGRectMake(0, 0, ws.width, 5);
    CCSprite *bottomCreationLine = [CCSprite spriteWithFile:@"white.png" rect:bottomCreationLineRect];
    bottomCreationLine.color = ccc3(255, 0, 0);
    bottomCreationLine.position = ccp(bottomCreationLine.contentSize.width/2, bottomCreationLine.contentSize.height/2 + bottomTouchArea.contentSize.height - 5);
    [self addChild:bottomCreationLine z:10];
    
    
    [self schedule: @selector(update:)];
    
    return self;
}

- (void)onEnter {
    [[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:0 swallowsTouches:NO];
    [super onEnter];
}

- (void)onExit {
    [[CCDirector sharedDirector].touchDispatcher removeDelegate:self];
    [super onExit];
}

- (void) dealloc {
	[super dealloc];
}

#pragma mark - private functions
- (void)update:(ccTime)dt {
    
}

#pragma mark - touch handlers
// create points
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {    
    CGPoint touchPoint = [touch locationInView:[touch view]];
    touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
    
    if (!(CGRectContainsPoint(bottomTouchArea.textureRect, touchPoint)))
        return NO;
    
    Node *node = [Node node];
    node.type = kFirst;
    node.position = ccp(touchPoint.x, bottomTouchArea.textureRect.size.height);
    currentNodeGroup = [[NodeGroup nodeGroup] retain];
    [nodeSuperGroup addChild:currentNodeGroup];
    [currentNodeGroup addChild:node];
    
    return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touch locationInView:[touch view]];
    touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
    
    Node *node = [Node node];
    node.type = kMiddle;
    node.position = ccp(touchPoint.x, bottomTouchArea.textureRect.size.height);
    [currentNodeGroup addChild:node];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    NSInteger lastNodeIndex = [[currentNodeGroup children] count] - 1;
    ((Node *)[[currentNodeGroup children] objectAtIndex:lastNodeIndex]).type = kLast;
    [currentNodeGroup release];
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
	// do stuff
}

@end
