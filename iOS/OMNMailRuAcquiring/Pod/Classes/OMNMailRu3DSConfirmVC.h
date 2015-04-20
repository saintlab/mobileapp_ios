//
//  OMNMailRu3DSConfirmVC.h
//  Pods
//
//  Created by tea on 18.04.15.
//
//

#import <UIKit/UIKit.h>
#import "OMNMailRuPoll.h"

typedef void(^OMNMailRu3DSReturnBlock)(NSDictionary *response, NSError *error);

@interface OMNMailRu3DSConfirmVC : UIViewController

- (instancetype)initWithPollResponse:(OMNMailRuPoll *)pollResponse;

@property (nonatomic, copy) OMNMailRu3DSReturnBlock didFinishBlock;

@end
