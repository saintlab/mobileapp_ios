//
//  OMNDebugLaunch.m
//  omnom
//
//  Created by tea on 01.05.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNDebugLaunch.h"

@implementation OMNDebugLaunch

- (instancetype)init {
  self = [super init];
  
  if (self) {
#if OMN_TEST
    NSLog(@"test");
#elif LUNCH_2GIS
    self.qr = @"qr-code-for-0-lunch2gis";
#elif LUNCH_2GIS_SUNCITY
    self.config = @"config_staging";
    self.qr = @"qr-code-for-0-lunch2gis-sun-city";
#elif DEBUG
    //    prod
    self.config = @"config_prod";
//    self.qr =  @"http://m.2gis.ru/os/";
    //    _qr = @"qr-code-for-4-ruby-bar-nsk-at-lenina-9"; //rubi
    //    _qr = @"qr-code-for-0-harats-tomsk";
    //    _qr = @"qr-code-for-0-lunch2gis";
    //    _qr = @"http://omnom.menu/qr-hash-for-table-5-at-saintlab-rkeeper-v6";
    //    _qr = @"qr-code-for-1-riba-ris-nsk-at-aura";
//        self.qr = @"qr-code-for-2-saintlab-iiko";
    self.qr = @"qr-code-for-2-saintlab-iiko-dev";
//        _qr = @"http://omnom.menu/qr/d5495734ed5491655234e528d50972e9"; //бирман
    //    _qr = @"http://omnom.menu/qr/8eab9af3006a4fb0cd0bd92836e90130"; //мехико
    //    _qr = @"qr-code-for-1-ruby-bar-nsk-at-lenina-9"; //руби
    //    _qr = @"qr-code-for-3-travelerscoffee-nsk-at-karla-marksa-7"; //тревелерз
    //    _qr = @"http://omnom.menu/qr/special-and-vip"; //b-cafe
    
    
        self.config = @"config_staging";
    //    self.qr = @"http://omnom.menu/zr9b"; //saintlab-iiko-dev
    //    self.qr =  @"qr-code-for-2-saintlab-iiko-dev"; //staging
    
#endif
  }
  return self;
}

@end
