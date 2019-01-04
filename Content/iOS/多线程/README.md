# Dispath Source Timer 定时器

```Objective-c
- (void)startRoundDispathTimerWithDuration:(CGFloat)duration {
    self.roundLayer.strokeStart = 0;
    // 时间间隔
    NSTimeInterval period = 0.05;
    __block CGFloat roundDuration = duration;
    // 创建一个定时源
    _roundTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    dispatch_source_set_timer(_roundTimer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
    // 指定需要执行的任务
    dispatch_source_set_event_handler(_roundTimer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (roundDuration <= 0) {
                self.roundLayer.strokeStart = 1;
                // 处理结束
                dispatch_source_cancel(self.roundTimer);
                self.roundTimer = nil;
            }
            self.roundLayer.strokeStart += 1 / (duration / period);
            roundDuration -= period;
        });
    });
    // 启动Source
    dispatch_resume(_roundTimer);
}
```

参考：DispathSourceDemo示例项目