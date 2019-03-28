# 路漫漫其修远兮，吾将上下而求索
# 天行健，君子以自强不息；地势坤，君子以厚德载物



# Texture源码修改：
一、
##### 使用Texture过程中，发现在ASTextNode中富文本高亮的高亮框有问题，经过研究源码，改动了以下两处地方:
1、```ASTextKitRenderer+Positioning.mm```  （改动目的：高亮框位置不对）
找到_internalRectForGlyphAtIndex:measureOption:layoutManager:textContainer:textStorage方法,
在大约252行处，把
```
properGlyphRect = CGRectMake(glyphCenter.x - advance * 0.5,
                            glyphCenter.y - glyphHeight * 0.5 + (ascent - capHeight) - topPadding + leading,
                            advance,
                            capHeight + topPadding + bottomPadding);
```
改为
```
properGlyphRect = CGRectMake(
                            glyphRect.origin.x,
                            glyphRect.origin.y,
                            advance,
                            glyphHeight - descent / 2.0
);
```
或者
```
properGlyphRect = CGRectMake(
                            glyphRect.origin.x,
                            glyphRect.origin.y,
                            advance,
                            CGRectGetHeight(glyphRect) - (descent)
);
```

2、```ASHighlightOverlayLayer.mm```  （改动目的：修改偏移量）
找到定义padding的地方，在顶部18行位置处，把原来的padding改为```static const UIEdgeInsets padding = {2, 2, 1, 2};```，当然，这个值可以根据自己的实际情况进行修改


3、```ASTextNode.mm``` （改动目的：高亮颜色透明度自己设置）
在文件顶部找到
```
static const CGFloat ASTextNodeHighlightLightOpacity = 0.11;
static const CGFloat ASTextNodeHighlightDarkOpacity = 0.22;
```
改为
```
static const CGFloat ASTextNodeHighlightLightOpacity = 1;
static const CGFloat ASTextNodeHighlightDarkOpacity = 1;
```


2、ASTextNode的高亮颜色只有两种，如果想用其他高亮，其并没有提供接口，为了解决这个问题，我新建了分类，利用runtime的方式来设置高亮颜色，请看```ASTextNode+YHHighlight.h```


插入图片不能用yytext的方法
NSTextAttachment *attch = [[NSTextAttachment alloc] init];
attch.image = [UIImage imageNamed:@"qaq_login_sn"];
attch.bounds = CGRectMake(0, 0, 40, 40);
NSAttributedString *attchAtr = [NSAttributedString  attributedStringWithAttachment:attch];
