//
//  CopyLabel.m
//  DEYSocketClientTest
//
//  Created by Wingle Wong on 1/19/13.
//  Copyright (c) 2013 Neusoft. All rights reserved.
//

#import "CopyLabel.h"

@implementation CopyLabel

#pragma mark Initialization

- (void) attachTapHandler
{
    [self setUserInteractionEnabled:YES];
    UIGestureRecognizer *touchy = [[UILongPressGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:touchy];
    [touchy release];
}

- (id) initWithFrame: (CGRect) frame
{
    self = [super initWithFrame:frame];
    if (self) {
       [self attachTapHandler]; 
    }
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self attachTapHandler];
}

#pragma mark Clipboard

- (void) copy: (id) sender
{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.text;
}

- (BOOL) canPerformAction: (SEL) action withSender: (id) sender
{
    return (action == @selector(copy:));
}

- (void) handleTap: (UIGestureRecognizer*) recognizer
{
    if (recognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    [self becomeFirstResponder];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setTargetRect:self.frame inView:self.superview];
    [menu setMenuVisible:YES animated:YES];
}

- (BOOL) canBecomeFirstResponder
{
    return YES;
}

@end
