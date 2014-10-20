//
//  HSWordListCell.m
//  HSWordsPass
//
//  Created by yang on 14-9-15.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSWordListCell.h"
#import "HSCustomVoiceBtn.h"
#import "AudioPlayHelper.h"
#import "WordNet.h"

@interface HSWordListCell()<AudioPlayHelperDelegate>
{
    WordNet *wordNet;
}
@property (nonatomic, strong) HSCustomVoiceBtn *btnVoice;
@end


@implementation HSWordListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.btnVoice.backgroundColor = kClearColor;
        wordNet = [[WordNet alloc] init];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.detailTextLabel.left = self.textLabel.right+22.0f;
    self.detailTextLabel.centerY = self.textLabel.centerY;
    
    if (self.detailTextLabel.right >= self.accessoryView.left){
        self.detailTextLabel.width = self.detailTextLabel.width-22.0f;
    }

    /*
    CGFloat left = self.textLabel.right+22.0f;
    CGFloat width = self.detailTextLabel.width;
    CGFloat height = self.detailTextLabel.height;
    if (width+left >= self.accessoryView.left){
        width = self.detailTextLabel.width-22.0f;
    }
    CGFloat centerX = left+width*0.5f;
    CGFloat centerY = self.textLabel.centerY;
    
    self.detailTextLabel.bounds = CGRectMake(0.0f, 0.0f, width, height);
    self.detailTextLabel.center = CGPointMake(centerX, centerY);
     */
}



-(HSCustomVoiceBtn *)btnVoice{
    if (!_btnVoice) {
        UIImage *imgAccessory = [UIImage imageNamed:@"hsGlobal_ voice_1.png"];
        UIImage *imgAccessoryH = [UIImage imageNamed:@"hsGlobal_ voice_w_1"];
        _btnVoice = [[HSCustomVoiceBtn alloc] initWithFrame:CGRectMake(0.0f, 0.0f, imgAccessory.size.width, 60)];
        [_btnVoice setImage:imgAccessory forState:UIControlStateNormal];
        [_btnVoice setImage:imgAccessoryH forState:UIControlStateHighlighted];
        [_btnVoice addTarget:self action:@selector(playVoice:) forControlEvents:UIControlEventTouchUpInside];
        self.accessoryView = _btnVoice;
    }
    return _btnVoice;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected){
        self.btnVoice.voiceAnimationImgView.highlighted = YES;
    }else{
        self.btnVoice.voiceAnimationImgView.highlighted = NO;
        
    }
     
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)playVoice:(id)sender
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:_tAudio])
    {
        [[AudioPlayHelper sharedManager] playAudioWithName:_tAudio delegate:self];
        [self.btnVoice startAnimating];
    }
    else
    {
        __weak HSWordListCell *weakSelf = self;
        [wordNet downloadWordAudioDataWithEmail:kEmail checkPointID:_cpID audio:_audio completion:^(BOOL finished, id result, NSError *error) {
            
            if (finished)
            {
                [[AudioPlayHelper sharedManager] playAudioWithName:result delegate:weakSelf];
                [weakSelf.btnVoice startAnimating];
            }
        }];
    }
}

#pragma mark - AudioPlayHelper Delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.btnVoice stopAnimating];
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    [self.btnVoice stopAnimating];
}

@end
