//
//  ViewController.h
//  CaptureTheFlagPrototype
//
//  Created by Thomas Riccioli on 14/03/15.
//  Copyright (c) 2015 Thomas Riccioli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface ViewController : UIViewController <ZBarReaderDelegate>

- (IBAction)scanButtonPressed:(id)sender;

@end

