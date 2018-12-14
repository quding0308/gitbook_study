### 音频处理

``` Swift

两套framework：
 #import <AVFoundation/AVFoundation.h>
    处理音频、视频多媒体内容，负责 capturing, processing, synthesizing, controlling 四个过程。
Audio分为 和 App内Audio处理
    AVAudioSession负责interact with system audio

    AVAudioPlayer
    AVAudioRecorder

 
#import <AudioToolbox/AudioToolbox.h>
提供了 record、play audio，convert formats，parse audio streams，configure audio session

Audio Queue Service
  一个queue负责连接audio硬件，管理内存，管理音频格式，管理 录音和播放。

  queue创建和销毁：
    AudioQueueNewOutput
    AudioQueueNewInput
    AudioQueueDispose // 销毁

  queue管理：
    AudioQueueStart
    AudioQueuePrime // 做准备
    AudioQueueFlush
    AudioQueueStop  // stop 会reset queue，并且会停止queue，断开连接的硬件设备。重新调用start也没用。
    AudioQueuePause // pause不会影响buffers，也不会reset queue，调用AudioQueueStart则会重新resume
    AudioQueueReset

  管理queue的属性
    AudioQueueSetProperty
    AudioQueueGetProperty

  AudioQueueRef
```