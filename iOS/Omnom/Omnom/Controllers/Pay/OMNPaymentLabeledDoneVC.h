//
//  OMNPaymentLabeledDoneVC.h
//  omnom
//
//  Created by tea on 13.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNScrollContentVC.h"
#import "OMNVisitor.h"

@interface OMNPaymentLabeledDoneVC : OMNScrollContentVC

@property (nonatomic, strong, readonly) UILabel *textLabel;
@property (nonatomic, strong, readonly) OMNVisitor *visitor;

- (instancetype)initWithVisitor:(OMNVisitor *)visitor;

@end
