//
//  BandCardUtils.h
//  VgSale
//
//  Created by ztsapp on 2017/8/18.
//  Copyright © 2017年 ztstech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HandlerStringUtils: NSObject

///判断银行卡属于哪个银行
+ (NSString *)returnBankName:(NSString*) idCard;
///每隔几位插入一个字符
+ (NSString *)stringInsertChart:(NSString *)number chart:(NSString *)chart index:(int)index;
///每隔几位插入一个字符倒着
+ (NSString *)stringbackInsertChart:(NSString *)number chart:(NSString *)chart index:(int)index;
//身份证号正则表达式
+ (BOOL)accurateVerifyIDCardNumber:(NSString *)value;
//银行卡号正则表达式
+ (BOOL)wl_bankCardluhmCheck:(NSString *)bankcardNum;




 
@end
