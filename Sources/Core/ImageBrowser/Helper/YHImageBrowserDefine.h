//
//  YHImageBrowserDefine.h
//  HiFanSmooth
//
//  Created by 银河 on 2019/5/17.
//  Copyright © 2019 yinhe. All rights reserved.
//

#ifndef YHImageBrowserDefine_h
#define YHImageBrowserDefine_h


static void YHImageBrowserAsync(dispatch_queue_t queue, dispatch_block_t block) {
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(queue)) == 0) {
        block();
    } else {
        dispatch_async(queue, block);
    }
}



#endif /* YHImageBrowserDefine_h */
