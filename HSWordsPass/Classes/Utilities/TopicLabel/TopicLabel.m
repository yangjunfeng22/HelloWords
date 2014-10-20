//
//  TopicLabel.m
//  HelloHSK
//
//  Created by yang on 14-6-18.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "TopicLabel.h"
#import "TTTAttributedLabel.h"

#define kSperator @"^"
#define kApartor  @" "
#define kXDistance 4
#define kYDistance 5

#define kBBCodeUnderline @"*[u]*[/u]*"
#define kBBCodeBoldText  @"*[b]*[/b]*"
//@"^\\s*(.)[：:](.*)"
#define kTalkRegex @"^\\s*(.)[：:]([\\s\\S]*)"
#define kPinyinRegex @"*^*"
#define kChoiceRegex @"^\\s*[A-Za-z]([\\s\\S]*)"
#define kTextRegex   @"*[*]*"

@implementation TopicLabel
{
    NSMutableArray *arrPinyin;
    NSMutableArray *arrChinese;
    NSMutableArray *arrShowData;
    
    CGFloat totalHeight;
    CGFloat totalWidth;
    
    BOOL isPinyin;
    BOOL isTalk;
    BOOL isChoice;
    BOOL isText;
    
    TTTAttributedLabel *lblNTalk;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        arrPinyin   = [[NSMutableArray alloc] initWithCapacity:2];
        arrChinese  = [[NSMutableArray alloc] initWithCapacity:2];
        arrShowData = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return self;
}

#pragma mark - Touch Manager
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //[super touchesEnded:touches withEvent:event];
    if (self.delegate && [self.delegate respondsToSelector:@selector(topicLabel:selected:)])
    {
        [self.delegate topicLabel:self selected:self];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

#pragma mark - Draw Manager
- (void)drawRect:(CGRect)rect
{
    //NSLog(@"%@", NSStringFromSelector(_cmd));
    
    
    if (isPinyin || isTalk || isChoice)
    {
        //DLog(@"画pinyin");
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, self.textColor.CGColor);
        
        //高亮的str数组
        NSArray *keyWordArr = [self.keyWordHighlightStr componentsSeparatedByString:kApartor];
        
        for (int i = 0; i < [arrShowData count]; i++)
        {
            NSDictionary *dicAChar = [arrShowData objectAtIndex:i];
            NSArray *arrKey = [dicAChar allKeys];
            
            for (int k = 0; k < keyWordArr.count; k++) {
                NSString *tempStr = [keyWordArr objectAtIndex:k];
                
                if ([arrKey containsObject:tempStr]) {
                    CGContextSetFillColorWithColor(context, hsShineBlueColor.CGColor);
                    break;
                }else{
                    CGContextSetFillColorWithColor(context, self.textColor.CGColor);
                    continue;
                }
            }
            
            
            for (int j = 0; j < [arrKey count]; j++)
            {
                NSString *key    = [arrKey objectAtIndex:j];
                NSValue *value   = [dicAChar objectForKey:key];
                CGRect valueRect = [value CGRectValue];
  
                //NSLog(@"key : %@; value: %@", key, value);
                [key drawInRect:valueRect withFont:self.font lineBreakMode:self.lineBreakMode alignment:self.textAlignment];
            }
        }
        
        CGContextFlush(context);
    }
    else
    {
        [super drawRect:rect];
    }
}

- (void)sizeToFit
{
    [super sizeToFit];
    if (isPinyin || isTalk)
    {
        //CGFloat width  = isChoice ? totalWidth : self.frame.size.width;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, totalWidth, totalHeight);
        //self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, totalHeight);
    }
    
    //self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, totalWidth, totalHeight);
}

- (void)setText:(NSString *)aText
{
    //要加上这个super，不然不能触发drawRect函数
    [super setText:aText];
    
    if (aText && ![aText isEqualToString:@""])
    {
        [self decodeText:aText];
        [self setNeedsDisplay];
    }
}

- (void)decodeText:(NSString *)aText
{
    NSPredicate *pinTest = [NSPredicate predicateWithFormat:@"SELF LIKE %@", kPinyinRegex];
    isPinyin = [pinTest evaluateWithObject:aText];
    
    NSPredicate *talkTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kTalkRegex];
    isTalk = [talkTest evaluateWithObject:aText];
    
    [arrShowData removeAllObjects];
    totalHeight = 0;
    totalWidth  = 0;
    
    if (!isPinyin)
    {
        //[self decodeNormalHighlightStringWithText:aText];
        return;
    }
    
    NSPredicate *textTest = [NSPredicate predicateWithFormat:@"SELF LIKE %@", kTextRegex];
    isText = [textTest evaluateWithObject:aText];
    
    NSPredicate *choiceTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", kChoiceRegex];
    isChoice = [choiceTest evaluateWithObject:aText];
    
    if (isTalk){
        [self decodePinyinTalkWithText:aText];
    }else if (isChoice){
        [self decodeChoiceSentenceWithText:aText];
    }else if (isText){
        [self decodeTextSentenceWithText:aText];
    }else{
        [self decodePinyinSentenceWithText:aText];
    }
    
}

- (void)decodeNormalHighlightStringWithText:(NSString *)aText
{
    __block UIFont *titleFont = self.font;
    __weak NSString *strHighlight = _keyWordHighlightStr;
    
    if (!lblNTalk)
    {
        lblNTalk = [[TTTAttributedLabel alloc] init];
        lblNTalk.backgroundColor = [UIColor clearColor];
        lblNTalk.font = self.font;
        lblNTalk.textColor = self.textColor;
        lblNTalk.textAlignment = NSTextAlignmentLeft;
        lblNTalk.numberOfLines = 0;
        
        [self addSubview:lblNTalk];
    }
    
    lblNTalk.frame = CGRectMake(0.0f, 0.0f, self.bounds.size.width, self.bounds.size.height);
    
    [lblNTalk setText:aText afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        //NSRange range = NSMakeRange(0, mutableAttributedString.length);
        // Core Text APIs use C functions without a direct bridge to UIFont. See Apple's "Core Text Programming Guide" to learn how to configure string attributes.
        UIFont *boldSystemFont = titleFont;
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
        if (font)
        {
            if (strHighlight)
            {
                NSRange strRange = [[mutableAttributedString string] rangeOfString:strHighlight options:NSLiteralSearch];
                
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:strRange];
                [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:hsShineBlueColor range:strRange];
            }
            CFRelease(font);
        }
        return mutableAttributedString;
    }];
    [lblNTalk sizeToFit];
    
    totalHeight = lblNTalk.bounds.size.height;
    totalWidth  = lblNTalk.bounds.size.width;
}
/*
// 正常状态下的男女对话
- (void)decodeNormalTalkWithText:(NSString *)aText
{
    __block UIFont *titleFont = self.font;
    
    if (!lblNTalk)
    {
        lblNTalk = [[TTTAttributedLabel alloc] init];
        lblNTalk.backgroundColor = [UIColor clearColor];
        lblNTalk.font = self.font;
        lblNTalk.textColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
        lblNTalk.textAlignment = NSTextAlignmentLeft;
        lblNTalk.numberOfLines = 0;
        
        [self addSubview:lblNTalk];
    }
    
    lblNTalk.frame = CGRectMake(0.0f, 0.0f, self.bounds.size.width, self.bounds.size.height);
    
    [lblNTalk setText:aText afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        NSRange range = NSMakeRange(0, mutableAttributedString.length);
        // Core Text APIs use C functions without a direct bridge to UIFont. See Apple's "Core Text Programming Guide" to learn how to configure string attributes.
        UIFont *boldSystemFont = titleFont;
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
        if (font)
        {
            CTParagraphStyleSetting headIndent;
            NSString *strHuman = [aText substringToIndex:2];
            
            CGSize mSize = [strHuman sizeWithFont:boldSystemFont];
            CGFloat startFactor = mSize.width;
            CGFloat indent = startFactor;
            headIndent.value = &indent;
            headIndent.valueSize = sizeof(CGFloat);
            
            // 非首行缩进
            headIndent.spec = kCTParagraphStyleSpecifierHeadIndent;
            
            // 行间距
            CTParagraphStyleSetting lineSpacing;
            CGFloat spacing = 4.0f;
            lineSpacing.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
            lineSpacing.value = &spacing;
            lineSpacing.valueSize = sizeof(CGFloat);
            
            CTParagraphStyleSetting settings[] = {headIndent, lineSpacing};
            CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, 2);
            
            [mutableAttributedString addAttribute:(NSString *)kCTParagraphStyleAttributeName value:(__bridge id)paragraphStyle range:range];
            
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:range];
            
            CFRelease(paragraphStyle);
            CFRelease(font);
        }
        return mutableAttributedString;
    }];
    [lblNTalk sizeToFit];
    
    totalHeight = lblNTalk.bounds.size.height;
    totalWidth  = lblNTalk.bounds.size.width;
}
*/

// 拼音状态下的男女对话
- (void)decodePinyinTalkWithText:(NSString *)aText
{
    NSArray *arrTalk = [aText componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"|\n"]];
   
    NSInteger count = [arrTalk count];
    
    for (NSInteger i = 0; i < count; i++)
    {
        NSString *strTalk = [arrTalk objectAtIndex:i];
        [self decodePinyinTalkSentenceWithTalk:strTalk index:i];
    }
}

- (void)decodePinyinTalkSentenceWithTalk:(NSString *)aTalk index:(NSInteger)index
{
    //NSLog(@"aTalk : %@", aTalk);
    CGFloat width = self.bounds.size.width;
    CGFloat pinyinOriginX  = 0.0f;
    CGFloat pinyinOriginY  = totalHeight + (index == 0 ? 0 : kXDistance);
    
    //CGFloat chineseOriginX = 0.0f;
    CGFloat chineseOriginY = 0.0f;
    
    NSArray *arrText = [aTalk componentsSeparatedByString:kSperator];
    
    // 取出中文
    NSString *strTempChinese = [arrText objectAtIndex:0];
    // 取出拼音
    NSString *strTempPinyin = [arrText objectAtIndex:1];
    
    // 取出中文状态中的男：或女：
    NSString *strHuman = [strTempChinese substringToIndex:2];
    strTempChinese = [strTempChinese stringByReplacingOccurrencesOfString:strHuman withString:@""];
    //NSLog(@"Human: %@", strHuman);
    
    CGSize mSize = [strHuman sizeWithFont:self.font];
    CGFloat startFactor = mSize.width;
    
    // 分割拼音
    NSMutableArray *arrTempPinyin  = (NSMutableArray *)[strTempPinyin componentsSeparatedByString:kApartor];
    // 分割中文
    NSMutableArray *arrTempChinese = (NSMutableArray *)[strTempChinese componentsSeparatedByString:kApartor];
    // 将一开始的男：或女：插入到中文数组的第一个中，将空插入到拼音数组的第一个中。
    [arrTempPinyin insertObject:@" " atIndex:0];
    [arrTempChinese insertObject:strHuman atIndex:0];
    
    // 计算出一个例词中拼音的个数,相当于同时计算出例词中字的个数.
    NSInteger pinYinCount  = [arrTempPinyin count];
    NSInteger chineseCount = [arrTempChinese count];
    
    // 选出最小的那个
    NSInteger count = pinYinCount > chineseCount ? chineseCount : pinYinCount;
    
    CGFloat alreadWidth  = 0;
    CGFloat alreadHeight = 0;
    
    //[arrShowData removeAllObjects];
    // 计算出每一个拼音的位置以及对应的字的位置
    for (int j = 0; j < count; j++)
    {
        NSString *strTempPinyin = [arrTempPinyin objectAtIndex:j];
        if ([strTempPinyin isEqualToString:@"()"]){
            strTempPinyin = [NSString stringWithFormat:@" "];
        }
        CGSize pSize = [strTempPinyin sizeWithFont:self.font];
        
        NSString *strTempChinese = [arrTempChinese objectAtIndex:j];
        if ([strTempChinese isEqualToString:@"()"]){
            strTempChinese = [NSString stringWithFormat:@"(    )"];
        }
        
        CGSize cSize = [strTempChinese sizeWithFont:self.font];
        
        CGFloat cWidth = pSize.width > cSize.width ? pSize.width : cSize.width;
        
        if (alreadWidth+cWidth > width+kXDistance)
        {
            // 换行的时候字符开始出现的位置为男：或女：之后
            alreadWidth = startFactor;
            pinyinOriginY += cSize.height+pSize.height+kYDistance;
        }
        
        CGRect pinyinRect  = CGRectMake(pinyinOriginX + alreadWidth, pinyinOriginY, cWidth, pSize.height);
        NSValue *pinyinValue = [NSValue valueWithCGRect:pinyinRect];
        
        chineseOriginY = pinyinOriginY+pSize.height+kYDistance;
        CGRect chineseRect = CGRectMake(CGRectGetMidX(pinyinRect) - cSize.width*0.5f, chineseOriginY , cSize.width, cSize.height);
        NSValue *chineseValue = [NSValue valueWithCGRect:chineseRect];
        
        //NSLog(@"chinese: %@, rect: %@", strTempChinese, chineseValue);
        
        NSDictionary *dicAChar = [NSDictionary dictionaryWithObjectsAndKeys:chineseValue, strTempChinese,pinyinValue, strTempPinyin, nil];
        
        [arrShowData addObject:dicAChar];
        
        // 男：或女：之后可以不带间隔宽度
        alreadWidth += cWidth + (0 == j ? 0 : kXDistance);
        totalWidth = alreadWidth > totalWidth ? alreadWidth : totalWidth;
        alreadHeight = chineseOriginY+cSize.height;
    }
    //NSLog(@"arrShowData: %@", arrShowData);
    totalHeight = alreadHeight;
}

// 单纯的拼音句子
- (void)decodePinyinSentenceWithText:(NSString *)aText
{
    CGFloat width = self.bounds.size.width;
    CGFloat pinyinOriginX  = 0.0f;
    CGFloat pinyinOriginY  = 0.0f;
    
    //CGFloat chineseOriginX = 0.0f;
    CGFloat chineseOriginY = 0.0f;
    
    NSArray *arrText = [aText componentsSeparatedByString:kSperator];
    
    // 取出中文
    NSString *strTempChinese = [arrText objectAtIndex:0];
    
    // 取出拼音
    NSString *strTempPinyin = [arrText objectAtIndex:1];
    
    // 分割拼音
    NSArray *arrTPinyin  = [strTempPinyin componentsSeparatedByString:kApartor];
    // 分割中文
    NSArray *arrTChinese = [strTempChinese componentsSeparatedByString:kApartor];
    
    // 分割拼音
    NSMutableArray *arrTempPinyin  = [[NSMutableArray alloc] initWithCapacity:2];
    // 分割中文
    NSMutableArray *arrTempChinese = [[NSMutableArray alloc] initWithCapacity:2];
    
    [arrTempPinyin setArray:arrTPinyin];
    [arrTempChinese setArray:arrTChinese];
    
    // 一、二、三、四级的提问那里会出现带★号开头的，如果放到了带有拼音的里面，那么会造成中文和英文不匹配。
    // 所以要把这种情况提取出来处理掉.
    NSString *strStar = [arrTempChinese objectAtIndex:0];
    BOOL star = [strStar isEqualToString:@"★"];
    CGSize sSize = CGSizeZero;
    if (star)
    {
        [arrTempPinyin insertObject:@" " atIndex:0];
        sSize = [strStar sizeWithFont:self.font];
    }
    
    //NSLog(@"arrTempPinyin: %@; arrTempChinese: %@", arrTempPinyin, arrTempChinese);
    
    // 计算出一个例词中拼音的个数,相当于同时计算出例词中字的个数.
    NSInteger pinYinCount  = [arrTempPinyin count];
    NSInteger chineseCount = [arrTempChinese count];
    
    // 选出最小的那个
    NSInteger count = pinYinCount > chineseCount ? chineseCount : pinYinCount;
    
    CGFloat alreadWidth  = 0;
    CGFloat alreadHeight = 0;
    
    //[arrShowData removeAllObjects];
    // 计算出每一个拼音的位置以及对应的字的位置
    for (int j = 0; j < count; j++)
    {
        NSString *strTempPinyin = [arrTempPinyin objectAtIndex:j];
        if ([strTempPinyin isEqualToString:@"()"]){
            strTempPinyin = [NSString stringWithFormat:@" "];
        }
        // ios 7 以下的会发生错误
        if ([strTempPinyin isEqualToString:@""]){
            strTempPinyin = [NSString stringWithFormat:@" "];
        }
        CGSize pSize = [strTempPinyin sizeWithFont:self.font];
        
        NSString *strTempChinese = [arrTempChinese objectAtIndex:j];
        if ([strTempChinese isEqualToString:@"()"]){
            strTempChinese = [NSString stringWithFormat:@"(    )"];
        }
        CGSize cSize = [strTempChinese sizeWithFont:self.font];
        
        //NSLog(@"strTempPinyin: %@; strTempChinese: %@", strTempPinyin, strTempChinese);
        
        CGFloat cWidth = pSize.width > cSize.width ? pSize.width : cSize.width;
        
        if (alreadWidth+cWidth > width+kXDistance)
        {
            alreadWidth = star ? sSize.width+kXDistance : 0;
            pinyinOriginY += cSize.height+pSize.height+kYDistance;
        }
        
        CGRect pinyinRect  = CGRectMake(pinyinOriginX + alreadWidth, pinyinOriginY, cWidth, pSize.height);
        NSValue *pinyinValue = [NSValue valueWithCGRect:pinyinRect];
        
        chineseOriginY = pinyinOriginY+pSize.height+kYDistance*0.5f;
        CGRect chineseRect = CGRectMake(CGRectGetMidX(pinyinRect) - cSize.width*0.5f, chineseOriginY , cSize.width, cSize.height);
        NSValue *chineseValue = [NSValue valueWithCGRect:chineseRect];
        
        NSDictionary *dicAChar = [NSDictionary dictionaryWithObjectsAndKeys:chineseValue, strTempChinese,pinyinValue, strTempPinyin, nil];
        [arrShowData addObject:dicAChar];
        
        alreadWidth += cWidth + kXDistance;
        totalWidth = alreadWidth > totalWidth ? alreadWidth : totalWidth;
        alreadHeight = chineseOriginY+cSize.height;
    }
    //NSLog(@"arrShowData: %@", arrShowData);
    totalHeight = alreadHeight;
    //totalWidth = alreadWidth > totalWidth ? alreadWidth : totalWidth;
}


// 解析正常的对话（没有拼音）
- (void)decodeNormalTalkSentenceWithTalk:(NSString *)aTalk index:(NSInteger)index
{
    CGFloat width = self.bounds.size.width;
    CGFloat strOriginX  = 0.0f;
    CGFloat strOriginY  = totalHeight + (index == 0 ? 0 : kXDistance);
    
    // 取出中文状态中的男：或女：
    NSString *strHuman = [aTalk substringToIndex:2];
    aTalk = [aTalk stringByReplacingOccurrencesOfString:strHuman withString:@""];
    //NSLog(@"Human: %@", strHuman);
    
    CGSize mSize = [strHuman sizeWithFont:self.font];
    CGFloat startFactor = mSize.width;

    // 分割中文
    NSMutableArray *arrTalk = [[NSMutableArray alloc] initWithCapacity:2];
    size_t length = [aTalk length];
    for (size_t i = 0; i < length; i++)
    {
        //UniChar c = [strTempChinese characterAtIndex:i];
        NSString *strC = [aTalk substringWithRange:NSMakeRange(i, 1)];
        [arrTalk addObject:strC];
    }

    // 将一开始的男：或女：插入到中文数组的第一个中。
    [arrTalk insertObject:strHuman atIndex:0];
    
    // 计算出一个例词中拼音的个数,相当于同时计算出例词中字的个数.
    NSInteger talkCount = [arrTalk count];
    
    CGFloat alreadWidth  = 0;
    CGFloat alreadHeight = 0;
    
    //[arrShowData removeAllObjects];
    // 计算出每一个拼音的位置以及对应的字的位置
    for (int j = 0; j < talkCount; j++)
    {
        NSString *strTalk = [arrTalk objectAtIndex:j];
        
        CGSize cSize = [strTalk sizeWithFont:self.font];
        
        CGFloat cWidth = cSize.width;
        
        if (alreadWidth+cWidth > width+kXDistance)
        {
            // 换行的时候字符开始出现的位置为男：或女：之后
            alreadWidth = startFactor;
            strOriginY += cSize.height + kYDistance;
        }
        
        CGRect talkRect  = CGRectMake(strOriginX + alreadWidth, strOriginY, cWidth, cSize.height);
        NSValue *talkValue = [NSValue valueWithCGRect:talkRect];
        
        NSDictionary *dicAChar = [NSDictionary dictionaryWithObjectsAndKeys:talkValue, strTalk, nil];
        [arrShowData addObject:dicAChar];
        
        // 男：或女：之后可以不带间隔宽度
        alreadWidth += cWidth + (0 == j ? 0 : kXDistance);
        totalWidth = alreadWidth > totalWidth ? alreadWidth : totalWidth;
        alreadHeight = strOriginY + cSize.height;
    }
    //NSLog(@"arrShowData: %@", arrShowData);
    totalHeight = alreadHeight;
    //totalWidth = alreadWidth > totalWidth ? alreadWidth : totalWidth;
}

- (void)decodeChoiceSentenceWithText:(NSString *)aText
{
    //NSLog(@"aText: %@", aText);
    CGFloat width = self.bounds.size.width;
    CGFloat pinyinOriginX  = 0.0f;
    CGFloat pinyinOriginY  = totalHeight + (index == 0 ? 0 : kXDistance);
    
    //CGFloat chineseOriginX = 0.0f;
    CGFloat chineseOriginY = 0.0f;
    
    NSArray *arrText = [aText componentsSeparatedByString:kSperator];
    
    // 取出中文
    NSString *strTempChinese = [arrText objectAtIndex:0];
    // 取出拼音
    NSString *strTempPinyin = [arrText objectAtIndex:1];
    
    // 取出中文状态中的男：或女：
    NSString *strHuman = [strTempChinese substringToIndex:3];
    strTempChinese = [strTempChinese stringByReplacingOccurrencesOfString:strHuman withString:@""];
    //NSLog(@"Human: %@", strHuman);
    
    CGSize mSize = [strHuman sizeWithFont:self.font];
    CGFloat startFactor = mSize.width;
    
    // 分割拼音
    NSArray *arrTempPinyin  = [strTempPinyin componentsSeparatedByString:kApartor];
    // 分割中文
    NSArray *arrTempChinese = [strTempChinese componentsSeparatedByString:kApartor];
    
    NSMutableArray *arrTPinyin = [[NSMutableArray alloc] initWithCapacity:2];
    NSMutableArray *arrTChinese = [[NSMutableArray alloc] initWithCapacity:2];
    [arrTPinyin setArray:arrTempPinyin];
    [arrTChinese setArray:arrTempChinese];
    // 将一开始的男：或女：插入到中文数组的第一个中，将空插入到拼音数组的第一个中。
    [arrTPinyin insertObject:@"" atIndex:0];
    [arrTChinese insertObject:strHuman atIndex:0];
    
    //NSLog(@"arrTPinyin: %@, arrTChinese: %@", arrTPinyin, arrTChinese);
    
    // 计算出一个例词中拼音的个数,相当于同时计算出例词中字的个数.
    NSInteger pinYinCount  = [arrTPinyin count];
    NSInteger chineseCount = [arrTChinese count];
    
    // 选出最小的那个
    NSInteger count = pinYinCount > chineseCount ? chineseCount : pinYinCount;
    
    CGFloat alreadWidth  = 0;
    CGFloat alreadHeight = 0;
    
    //[arrShowData removeAllObjects];
    // 计算出每一个拼音的位置以及对应的字的位置
    for (int j = 0; j < count; j++)
    {
        NSString *strTempPinyin = [arrTPinyin objectAtIndex:j];
        CGSize pSize = [strTempPinyin sizeWithFont:self.font];
        
        NSString *strTempChinese = [arrTChinese objectAtIndex:j];
        CGSize cSize = [strTempChinese sizeWithFont:self.font];
        
        CGFloat cWidth = pSize.width > cSize.width ? pSize.width : cSize.width;
        
        if (alreadWidth+cWidth > width+kXDistance)
        {
            // 换行的时候字符开始出现的位置为男：或女：之后
            alreadWidth = startFactor;
            pinyinOriginY += cSize.height+pSize.height+kYDistance;
        }
        
        CGRect pinyinRect  = CGRectMake(pinyinOriginX + alreadWidth, pinyinOriginY, cWidth, pSize.height);
        NSValue *pinyinValue = [NSValue valueWithCGRect:pinyinRect];
        
        chineseOriginY = pinyinOriginY+pSize.height+kYDistance*0.5f;
        CGRect chineseRect = CGRectMake(CGRectGetMidX(pinyinRect) - cSize.width*0.5f, chineseOriginY , cSize.width, cSize.height);
        NSValue *chineseValue = [NSValue valueWithCGRect:chineseRect];
        
        NSDictionary *dicAChar = [NSDictionary dictionaryWithObjectsAndKeys:chineseValue, strTempChinese,pinyinValue, strTempPinyin, nil];
        [arrShowData addObject:dicAChar];
        
        // 男：或女：之后可以不带间隔宽度
        alreadWidth += cWidth + (0 == j ? 0 : kXDistance);
        totalWidth = alreadWidth > totalWidth ? alreadWidth : totalWidth;
        alreadHeight = chineseOriginY+cSize.height;
    }
    //NSLog(@"arrShowData: %@", arrShowData);
    totalHeight = alreadHeight;
    //totalWidth = alreadWidth > totalWidth ? alreadWidth : totalWidth;
}

- (void)decodeTextSentenceWithText:(NSString *)aText
{
    NSInteger startLeft = [aText rangeOfString:@"("].location;
    NSInteger endRight = [aText rangeOfString:@")"].location;
    NSRange range = NSMakeRange(startLeft+1, endRight-startLeft-1);
    
    NSString *strText = [aText stringByReplacingCharactersInRange:range withString:@""];
    //NSLog(@"strText: %@", strText);
    
    CGFloat width = self.bounds.size.width;
    CGFloat pinyinOriginX  = 0.0f;
    CGFloat pinyinOriginY  = 0.0f;
    
    //CGFloat chineseOriginX = 0.0f;
    CGFloat chineseOriginY = 0.0f;
    
    NSArray *arrText = [strText componentsSeparatedByString:kSperator];
    
    // 取出中文
    NSString *strTempChinese = [arrText objectAtIndex:0];
    
    NSPredicate *CTest = [NSPredicate predicateWithFormat:@"SELF LIKE %@", kTextRegex];
    BOOL isCText = [CTest evaluateWithObject:strTempChinese];
    
    if (isCText)
    {
        // 对去除的中文的中括号作加小括号的处理
        startLeft = [strTempChinese rangeOfString:@"["].location;
        endRight = [strTempChinese rangeOfString:@"]"].location;
        range = NSMakeRange(startLeft, (endRight-startLeft)+1);
        strTempChinese = [strTempChinese stringByReplacingCharactersInRange:range withString:@"()"];
    }
    
    // 取出拼音
    NSString *strTempPinyin = [arrText objectAtIndex:1];
    
    NSPredicate *PTest = [NSPredicate predicateWithFormat:@"SELF LIKE %@", kTextRegex];
    BOOL isPText = [PTest evaluateWithObject:strTempPinyin];
    
    if (isPText)
    {
        // 对取出的拼音作加空格处理
        startLeft = [strTempPinyin rangeOfString:@"["].location;
        endRight = [strTempPinyin rangeOfString:@"]"].location;
        range = NSMakeRange(startLeft, (endRight-startLeft)+1);
        strTempPinyin = [strTempPinyin stringByReplacingCharactersInRange:range withString:@""];
    }
    
    // 分割拼音
    NSArray *arrTempPinyin  = [strTempPinyin componentsSeparatedByString:kApartor];
    // 分割中文
    NSArray *arrTempChinese = [strTempChinese componentsSeparatedByString:kApartor];
    
    //NSLog(@"arrTempPinyin: %@; arrTempChinese: %@", arrTempPinyin, arrTempChinese);
    
    // 计算出一个例词中拼音的个数,相当于同时计算出例词中字的个数.
    NSInteger pinYinCount  = [arrTempPinyin count];
    NSInteger chineseCount = [arrTempChinese count];
    
    // 选出最小的那个
    NSInteger count = pinYinCount > chineseCount ? chineseCount : pinYinCount;
    
    CGFloat alreadWidth  = 0;
    CGFloat alreadHeight = 0;
    
    //[arrShowData removeAllObjects];
    // 计算出每一个拼音的位置以及对应的字的位置
    for (int j = 0; j < count; j++)
    {
        NSString *strTempPinyin = [arrTempPinyin objectAtIndex:j];
        CGSize pSize = [strTempPinyin sizeWithFont:self.font];
        
        NSString *strTempChinese = [arrTempChinese objectAtIndex:j];
        if ([strTempChinese isEqualToString:@"()"]){
            strTempChinese = [NSString stringWithFormat:@"(    )"];
        }
        CGSize cSize = [strTempChinese sizeWithFont:self.font];
        
        CGFloat cWidth = pSize.width > cSize.width ? pSize.width : cSize.width;
        
        if (alreadWidth+cWidth > width+kXDistance)
        {
            alreadWidth = 0;
            pinyinOriginY += cSize.height+pSize.height+kYDistance;
        }
        
        CGRect pinyinRect  = CGRectMake(pinyinOriginX + alreadWidth, pinyinOriginY, cWidth, pSize.height);
        NSValue *pinyinValue = [NSValue valueWithCGRect:pinyinRect];
        
        chineseOriginY = pinyinOriginY+pSize.height+kYDistance;
        CGRect chineseRect = CGRectMake(CGRectGetMidX(pinyinRect) - cSize.width*0.5f, chineseOriginY , cSize.width, cSize.height);
        NSValue *chineseValue = [NSValue valueWithCGRect:chineseRect];
        
        NSDictionary *dicAChar = [NSDictionary dictionaryWithObjectsAndKeys:chineseValue, strTempChinese,pinyinValue, strTempPinyin, nil];
        [arrShowData addObject:dicAChar];
        
        alreadWidth += cWidth + kXDistance;
        totalWidth = alreadWidth > totalWidth ? alreadWidth : totalWidth;
        alreadHeight = chineseOriginY+cSize.height;
    }
    //NSLog(@"arrShowData: %@", arrShowData);
    totalHeight = alreadHeight;
    //totalWidth = alreadWidth > totalWidth ? alreadWidth : totalWidth;
}

#pragma mark - Memory Manager
- (void)dealloc
{
    [arrPinyin removeAllObjects];
    [arrChinese removeAllObjects];
    [arrShowData removeAllObjects];
    
    arrPinyin = nil;
    arrChinese = nil;
    arrShowData = nil;
    
    [lblNTalk removeFromSuperview];
    lblNTalk = nil;
}

@end
