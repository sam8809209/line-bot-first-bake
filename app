# -*- coding: utf-8 -*-
"""
Created on Thu Mar 24 01:03:51 2022

@author: sam88
"""

from flask import Flask
app = Flask(__name__)

from flask import request, abort
from flask_sqlalchemy import SQLAlchemy
from linebot import  LineBotApi, WebhookHandler
from linebot.exceptions import InvalidSignatureError
from linebot.models import MessageEvent, TextMessage, TextSendMessage,QuickReply,QuickReplyButton, MessageAction,  URITemplateAction, ButtonComponent, FlexSendMessage, BubbleContainer, ImageComponent, BoxComponent, TextComponent, MessageTemplateAction, CarouselContainer

import http.client, json

line_bot_api = LineBotApi()
handler = WebhookHandler()

@app.route("/callback", methods=['POST'])
def callback():
    signature = request.headers['X-Line-Signature']
    body = request.get_data(as_text=True)
    try:
        handler.handle(body, signature)
    except InvalidSignatureError:
        abort(400)
    return 'OK'

host = 'firstbakequest.azurewebsites.net'#主機
endpoint_key = "447ae0ca-943b-42a8-83c6-f3ab54d0bab5"#授權碼
qnakb="cb0d616f-bf18-44f8-9923-4bbd0858fc22"#GUID碼
qnamethod= "/qnamaker/knowledgebases/" + qnakb + "/generateAnswer"

recipekb="94885fb2-f47f-4b9d-92db-1908d34f0cf3"#GUID碼
recipemethod= "/qnamaker/knowledgebases/" + recipekb + "/generateAnswer"

app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://sam880920:58775487@127.0.0.1:5432/firstbake'
db = SQLAlchemy(app)

@handler.add(MessageEvent, message=TextMessage)
def handle_message(event):
    mtext =event.message.text
    if mtext =='問問題':
        sendQUse(event)
    elif mtext=='問題目錄':
        sendQnAmenu(event)
    elif mtext=='替代材料的問題':
         QnA_M(event)
    elif  mtext == '食譜':
        sendRUse(event)
    elif  mtext == '食譜目錄':
        Rmenu(event)
    elif mtext == '作法的問題':
        QnA_Ma(event)
    elif mtext == '設備的問題':
        QnA_E(event)
    elif  mtext == '麵包食譜':     
           sendBrecipe(event)
    elif  mtext == '蛋糕食譜':     
           sendCrecipe(event)
    elif  mtext == '派類食譜':     
           sendPrecipe(event)
    elif  mtext == '塔類食譜':     
           sendTrecipe(event)
    elif  mtext == '餅乾食譜':     
           sendCOOKIErecipe(event)
    elif  mtext ==  '我想問'+ mtext[3:]:
        sendQnA(event, mtext)
    elif  mtext == '我想查'+ mtext[3:]:
        sendRecipe(event, mtext)
    elif  mtext == '問題回報':
        sendMistake(event, mtext)
    elif  mtext == '地圖':
        sendMap(event)
    elif  mtext == '商店':
        sendStore(event)
    else:
        senderror(event)
        
def sendQUse(event): #問題說明
    try:
        message = TextSendMessage(
            text='這邊可以用來查詢烘焙問題\n\n查詢方式：\n 我想問+問題 \n\n範例：我想問蛋白\n\n如果不知道我們有甚麼問題種類的話，\n可以點選底下的問題目錄看看。',
            quick_reply= QuickReply(
                items=[
                    QuickReplyButton(
                        action=MessageTemplateAction(label="問題目錄",text="問題目錄")
                            )
                    ]
                )
            )
        line_bot_api.reply_message(event.reply_token,message)
    except:
        line_bot_api.reply_message(event.reply_token,TextSendMessage(Text='發生錯誤!'))

def sendQnAmenu(event):#問題目錄
    try:
        bubble = BubbleContainer(
            direction='ltr',
            body=BoxComponent(
                layout='vertical',
                contents=[
                    ImageComponent(
                        url = 'https://upload.cc/i1/2022/03/23/uVeCd0.jpg', 
                        size = 'full',
                        aspect_mode= 'cover'),
                        BoxComponent(
                            layout = 'vertical',
                            contents = [TextComponent(text = '我可以解答的問題有這些~',
                                                      size = 'xl',
                                                      weight='bold'
                                                        ),
                                        BoxComponent(
                                            layout = 'horizontal',
                                            contents= [
                                                ButtonComponent(
                                                    action = MessageAction (label = '作法', 
                                                                            text = '作法的問題')
                                                       ),
                                                ButtonComponent(
                                                    action =MessageAction(label = '設備',
                                                                          text = '設備的問題')
                                                       )
                                                   ]
                                               ),
                                         BoxComponent(
                                            layout = 'horizontal',
                                            contents= [
                                                ButtonComponent(
                                                    action = MessageAction(label='替代材料',
                                                                           text = '替代材料的問題')
                                                    ),
                                            ]
                                         )
                        ],
                            padding_start= '10px',
                            padding_top='20px'
                            )
                        ],
                padding_all='0px'
                )
            )
        message = FlexSendMessage(alt_text = "食譜主選單",contents = bubble)
        line_bot_api.reply_message(event.reply_token,message)
    except:
        line_bot_api.reply_message(event.reply_token,TextSendMessage(text='發生錯誤！'))

def QnA_M(event): #替代材料
    try:
         carousel = CarouselContainer(
            contents = [
               BubbleContainer(
                direction='ltr',
                body=BoxComponent(
                    layout='vertical',
                    contents=[
                        ImageComponent(
                            url = 'https://upload.cc/i1/2022/03/24/VWgZ9q.jpg', 
                            size = 'full',
                            aspect_mode= 'cover'),
                            BoxComponent(
                                layout = 'vertical',
                                contents = [TextComponent(text = '麵粉問題類',
                                                          size = 'lg',
                                                          weight='bold'
                                                            ),
                                            BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='麵粉',
                                                                               text = '我想問麵粉')
                                                        ),
                                                    ButtonComponent(
                                                        action = MessageAction(label='高筋麵粉',
                                                                               text = '我想問高筋麵粉')
                                                    )
                                                  ]
                                                ),
                                             BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='中筋麵粉',
                                                                               text = '我想問中筋麵粉')
                                                        ),
                                                    ButtonComponent(
                                                        action = MessageAction(label='低筋麵粉',
                                                                               text = '我想問低筋麵粉')
                                                    )
                                                  ]
                                                ),
                                               ],
                                padding_start= '10px',
                                padding_top='20px'
                                )
                            ],
                    padding_all='0px'
                    )
                ),
               BubbleContainer(
                direction='ltr',
                body=BoxComponent(
                    layout='vertical',
                    contents=[
                        ImageComponent(
                            url = 'https://upload.cc/i1/2022/03/24/IzpXsY.jpg', 
                            size = 'full',
                            aspect_mode= 'cover'),
                            BoxComponent(
                                layout = 'vertical',
                                contents = [TextComponent(text = '法國粉問題類',
                                                          size = 'lg',
                                                          weight='bold'
                                                            ),
                                            BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='法國粉',
                                                                               text = '我想問法國粉')
                                                        ),
                                                    ButtonComponent(
                                                        action = MessageAction(label='法國粉T45',
                                                                               text = '我想問法國粉T45')
                                                    )
                                                  ]
                                                ),
                                             BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='法國粉T55',
                                                                               text = '我想問法國粉T55')
                                                        ),
                                                    ButtonComponent(
                                                        action = MessageAction(label='法國粉T65',
                                                                               text = '我想問法國粉T65')
                                                    )
                                                  ]
                                                ),
                                             BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='專業級法國粉',
                                                                               text = '我想問法國粉T80/T110/T150')
                                                      )
                                                  ]
                                                ),
                                               ],
                                padding_start= '10px',
                                padding_top='20px'
                                )
                            ],
                    padding_all='0px'
                    )
                ),
               BubbleContainer(
                direction='ltr',
                body=BoxComponent(
                    layout='vertical',
                    contents=[
                        ImageComponent(
                            url = 'https://upload.cc/i1/2022/03/24/1ExK2T.jpg', 
                            size = 'full',
                            aspect_mode= 'cover'),
                            BoxComponent(
                                layout = 'vertical',
                                contents = [TextComponent(text = '牛奶/奶油的問題類',
                                                          size = 'lg',
                                                          weight='bold'
                                                            ),
                                            BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='奶油如何保存',
                                                                               text = '我想問奶油如何保存')
                                                        ),
                                                    ButtonComponent(
                                                        action = MessageAction(label='奶水',
                                                                               text = '我想問奶水')
                                                    )
                                                  ]
                                                ),
                                             BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='牛奶脂肪區別',
                                                                               text = '我想問牛奶高脂/低脂差別在哪')
                                                        ),
                                                    ButtonComponent(
                                                        action = MessageAction(label='奶油差別在哪',
                                                                               text = '我想問奶油差別在哪')
                                                    )
                                                  ]
                                                ),
                                             BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='鮮奶油與牛奶的差別',
                                                                               text = '我想問鮮奶油與牛奶的差別')
                                                     )
                                                  ]
                                                )
                                               ],
                                padding_start= '10px',
                                padding_top='20px'
                                )
                            ],
                    padding_all='0px'
                    )
                ),
               BubbleContainer(
                direction='ltr',
                body=BoxComponent(
                    layout='vertical',
                    contents=[
                        ImageComponent(
                            url = 'https://upload.cc/i1/2022/03/24/kYcBxC.jpg', 
                            size = 'full',
                            aspect_mode= 'cover'),
                            BoxComponent(
                                layout = 'vertical',
                                contents = [TextComponent(text = '雞蛋的問題種類',
                                                          size = 'lg',
                                                          weight='bold'
                                                            ),
                                            BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='一顆雞蛋多重',
                                                                               text = '我想問一顆雞蛋多重')
                                                        )
                                                     
                                                  ]
                                                ),
                                            BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='蛋白打發分為幾種階段',
                                                                               text = '我想問蛋白打發分為幾種階段')
                                                     )
                                                  ]
                                                )
                                               ],
                                padding_start= '10px',
                                padding_top='20px'
                                )
                            ],
                    padding_all='0px'
                )
               )
            ]
         )
         message = FlexSendMessage(alt_text = "替代材料目錄",contents = carousel)
         line_bot_api.reply_message(event.reply_token,message)
    except:
        line_bot_api.reply_message(event.reply_token,TextSendMessage(text='發生錯誤！'))

def QnA_Ma(event): #作法
    try:
         carousel = CarouselContainer(
            contents = [
               BubbleContainer(
                direction='ltr',
                body=BoxComponent(
                    layout='vertical',
                    contents=[
                        ImageComponent(
                            url = 'https://upload.cc/i1/2022/03/24/sUYrto.jpg', 
                            size = 'full',
                            aspect_mode= 'cover'),
                            BoxComponent(
                                layout = 'vertical',
                                contents = [TextComponent(text = '無法打發問題類',
                                                          size = 'lg',
                                                          weight='bold'
                                                            ),
                                            BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='蛋白',
                                                                               text = '我想問蛋白打不發')
                                                        ),
                                                    ButtonComponent(
                                                        action = MessageAction(label='鮮奶油',
                                                                               text = '我想問鮮奶油打不發')
                                                    )
                                                  ]
                                                ),
                                             BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='無鹽奶油',
                                                                               text = '我想問無鹽奶油打不發')
                                                        ),
                                                    ButtonComponent(
                                                        action = MessageAction(label='全蛋',
                                                                               text = '我想問全蛋打不發')
                                                    )
                                                  ]
                                                ),
                                               ],
                                padding_start= '10px',
                                padding_top='20px'
                                )
                            ],
                    padding_all='0px'
                    )
                ),
               BubbleContainer(
                direction='ltr',
                body=BoxComponent(
                    layout='vertical',
                    contents=[
                        ImageComponent(
                            url = 'https://upload.cc/i1/2022/03/23/FxLWVg.jpg', 
                            size = 'full',
                            aspect_mode= 'cover'),
                            BoxComponent(
                                layout = 'vertical',
                                contents = [TextComponent(text = '攪打問題類',
                                                          size = 'lg',
                                                          weight='bold'
                                                            ),
                                            BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='成品流出奶油',
                                                                               text = '我想問烤焙後流出奶油')
                                                        ),
                                                    ButtonComponent(
                                                        action = MessageAction(label='成品不夠蓬鬆',
                                                                               text = '我想問成品無法澎起來')
                                                    )
                                                  ]
                                                ),
                                             BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='奶油軟化後與雞蛋攪打',
                                                                               text = '我想問奶油軟化後與雞蛋攪打')
                                                        )
                                                  ]
                                                ),
                                               ],
                                padding_start= '10px',
                                padding_top='20px'
                                )
                            ],
                    padding_all='0px'
                    )
                ),
               BubbleContainer(
                direction='ltr',
                body=BoxComponent(
                    layout='vertical',
                    contents=[
                        ImageComponent(
                           url = 'https://upload.cc/i1/2022/03/24/6TgSQV.jpg',
                            size = 'full',
                            aspect_mode= 'cover'),
                            BoxComponent(
                                layout = 'vertical',
                                contents = [TextComponent(text = '配方問題類',
                                                          size = 'lg',
                                                          weight='bold'
                                                            ),
                                            BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='配方減量',
                                                                               text = '我想問只用一半的配方')
                                                        ),
                                                    ButtonComponent(
                                                        action = MessageAction(label='冷藏雞蛋',
                                                                               text = '我想問使用冷藏雞蛋')
                                                    )
                                                  ]
                                                ),
                                             BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='市售手指餅乾',
                                                                               text = '我想問市售手指餅乾差別在哪')
                                                        )
                                                  ]
                                                ),
                                               ],
                                padding_start= '10px',
                                padding_top='20px'
                                )
                            ],
                    padding_all='0px'
                    )
                ),
               BubbleContainer(
                direction='ltr',
                body=BoxComponent(
                    layout='vertical',
                    contents=[
                        ImageComponent(
                            url = 'https://upload.cc/i1/2022/03/24/E8RO3g.jpg', 
                            size = 'full',
                            aspect_mode= 'cover'),
                            BoxComponent(
                                layout = 'vertical',
                                contents = [TextComponent(text = '製作順序問題類',
                                                          size = 'lg',
                                                          weight='bold'
                                                            ),
                                            BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='可可粉裝飾',
                                                                               text = '我想問可可粉先灑可以嗎')
                                                     )
                                                  ]
                                                ),
                                            BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='麵包麵團放奶油的順序',
                                                                               text ='我想問麵包麵團放奶油的順序')
                                                        ),
                                                ]
                                            )
                                               ],
                                padding_start= '10px',
                                padding_top='20px'
                                )
                            ],
                    padding_all='0px'
                )
               )
            ]
         )
         message = FlexSendMessage(alt_text = "作法目錄",contents = carousel)
         line_bot_api.reply_message(event.reply_token,message)
    except:
        line_bot_api.reply_message(event.reply_token,TextSendMessage(text='發生錯誤！'))

def QnA_E(event): #設備
    try:
         carousel = CarouselContainer(
            contents = [
               BubbleContainer(
                direction='ltr',
                body=BoxComponent(
                    layout='vertical',
                    contents=[
                        ImageComponent(
                            url = 'https://upload.cc/i1/2022/03/23/Etpzim.jpg', 
                            size = 'full',
                            aspect_mode= 'cover'),
                            BoxComponent(
                                layout = 'vertical',
                                contents = [TextComponent(text = '設備問題分類',
                                                          size = 'lg',
                                                          weight='bold'
                                                            ),
                                            BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='沒有發酵箱',
                                                                               text = '我想問沒有發酵箱')
                                                        ),
                                                    ButtonComponent(
                                                        action = MessageAction(label='烤模種類',
                                                                               text = '我想問烤模種類')
                                                    )
                                                  ]
                                                ),
                                             BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='沒有攪拌機',
                                                                               text = '我想問沒有攪拌機')
                                                        )
                                                  ]
                                                ),
                                               ],
                                padding_start= '10px',
                                padding_top='20px'
                                )
                            ],
                    padding_all='0px'
                    )
                ),
            ]
         )
         message = FlexSendMessage(alt_text = "設備目錄",contents = carousel)
         line_bot_api.reply_message(event.reply_token,message)
    except:
        line_bot_api.reply_message(event.reply_token,TextSendMessage(text='發生錯誤！'))
def sendRUse(event): #食譜說明
    try:
        message = TextSendMessage(
                text = '這邊可以用來查詢烘焙食譜\n\n查詢方式：\n我想查 + 問題 \n\n範例：我想查紅豆麵包\n\n如果不知道我們有甚麼食譜的話，\n可以點選底下的食譜目錄看看喔。',
                quick_reply=QuickReply(
                    items = [
                        QuickReplyButton(
                            action= MessageTemplateAction(label="食譜目錄",text='食譜目錄')
                            ),
                        ]
                    )
                )
        line_bot_api.reply_message(event.reply_token,message)
    except:
        line_bot_api.reply_message(event.reply_token,TextSendMessage(Text='發生錯誤!'))

def Rmenu(event): #食譜目錄
    try:
        bubble = BubbleContainer(
            direction='ltr',
            body=BoxComponent(
                layout='vertical',
                contents=[
                    ImageComponent(
                        url = 'https://upload.cc/i1/2022/03/19/lcoItw.jpg', 
                        size = 'full',
                        aspect_mode= 'cover'),
                        BoxComponent(
                            layout = 'vertical',
                            contents = [TextComponent(text = '我蒐集的食譜有這些種類',
                                                      size = 'xl',
                                                      weight='bold'
                                                        ),
                                        BoxComponent(
                                            layout = 'horizontal',
                                            contents= [
                                                ButtonComponent(
                                                    action = MessageAction(label='蛋糕',
                                                                           text = '蛋糕食譜')
                                                    ),
                                                ButtonComponent(
                                                    action = MessageAction (label = '派類', 
                                                                            text = '派類食譜')
                                                       ),
                                                ButtonComponent(
                                                    action =MessageAction(label = '餅乾',
                                                                          text = '餅乾食譜')
                                                       ),
                                                   ]
                                               ),
                                        BoxComponent(
                                            layout = 'horizontal',
                                            contents= [
                                                ButtonComponent(
                                                    action = MessageAction(label='塔類',
                                                                           text = '塔類食譜')
                                                    ),
                                                ButtonComponent(
                                                    action =MessageAction(label = '麵包', 
                                                                          text = '麵包食譜')
                                                    )
                                                ]
                                            )
                                           ],
                            padding_start= '10px',
                            padding_top='20px'
                            )
                        ],
                padding_all='0px'
                )
            )
        message = FlexSendMessage(alt_text = "食譜主選單",contents = bubble)
        line_bot_api.reply_message(event.reply_token,message)
    except:
        line_bot_api.reply_message(event.reply_token,TextSendMessage(text='發生錯誤！'))

def sendBrecipe(event): #麵包食譜
    try:
        carousel = CarouselContainer(
            contents = [
               BubbleContainer(
                direction='ltr',
                body=BoxComponent(
                    layout='vertical',
                    contents=[
                        ImageComponent(
                            url = 'https://upload.cc/i1/2022/03/19/Ix3neW.jpg', 
                            size = 'full',
                            aspect_mode= 'cover'),
                            BoxComponent(
                                layout = 'vertical',
                                contents = [TextComponent(text = '吐司食譜分類',
                                                          size = 'lg',
                                                          weight='bold'
                                                            ),
                                            BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='日式生吐司',
                                                                               text = '我想查日式生吐司')
                                                        ),
                                                    ButtonComponent(
                                                        action = MessageAction (label = '巧克力雙色吐司', 
                                                                                text = '我想查巧克力雙色吐司')
                                                           ),
                                                       ]
                                                   ),
                                            BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='湯種豆漿芝麻',
                                                                               text = '我想查湯種豆漿芝麻吐司')

                                                        )
                                                    ]
                                                )
                                               ],
                                padding_start= '10px',
                                padding_top='20px'
                                )
                            ],
                    padding_all='0px'
                    )
                ),
                BubbleContainer(
                direction='ltr',
                body=BoxComponent(
                    layout='vertical',
                    contents=[
                        ImageComponent(
                            url = 'https://upload.cc/i1/2022/03/19/KcH5rm.jpg', 
                            size = 'full',
                            aspect_mode= 'cover'),
                            BoxComponent(
                                layout = 'vertical',
                                contents = [TextComponent(text = '牛角麵包食譜分類',
                                                          size = 'lg',
                                                          weight='bold'
                                                            ),
                                            BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='牛角麵包',
                                                                               text = '我想查牛角麵包')
                                                        ),
                                                    ButtonComponent(
                                                        action = MessageAction (label = '可頌', 
                                                                                text = '我想查可頌')
                                                           ),
                                                       ]
                                                   ),
                                            BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='巧克力鹽可頌',
                                                                               text = '我想查巧克力鹽可頌')

                                                        )
                                                    ]
                                                )
                                               ],
                                padding_start= '10px',
                                padding_top='20px'
                                )
                            ],
                    padding_all='0px'
                    )
                ),
                BubbleContainer(
                direction='ltr',
                body=BoxComponent(
                    layout='vertical',
                    contents=[
                        ImageComponent(
                            url = 'https://upload.cc/i1/2022/03/19/Gw2PpE.jpg',
                            size = 'full',
                            aspect_mode= 'cover'),
                            BoxComponent(
                                layout = 'vertical',
                                contents = [TextComponent(text = '甜麵包食譜分類',
                                                          size = 'lg',
                                                          weight='bold'
                                                            ),
                                            BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='奶酥麵包',
                                                                               text = '我想查奶酥麵包')
                                                        ),
                                                    ButtonComponent(
                                                        action = MessageAction (label = '紅豆麵包', 
                                                                                text = '我想查紅豆麵包')
                                                           ),
                                                    ButtonComponent(
                                                        action = MessageAction (label = '波蘿麵包', 
                                                                                text = '我想查波蘿麵包')
                                                        ),
                                                       ]
                                                   ),
                                            BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='布丁餡麵包',
                                                                               text = '我想查布丁餡麵包')

                                                        )
                                                    ]
                                                )
                                               ],
                                padding_start= '10px',
                                padding_top='20px'
                                )
                            ],
                    padding_all='0px'
                    )
                ),
                BubbleContainer(
                    direction='ltr',
                    body=BoxComponent(
                        layout='vertical',
                        contents=[
                            ImageComponent(
                                url = 'https://upload.cc/i1/2022/03/19/lcoItw.jpg', 
                                size = 'full',
                                aspect_mode= 'cover'),
                                BoxComponent(
                                    layout = 'vertical',
                                    contents = [TextComponent(text = '我蒐集的其他食譜...',
                                                              size = 'xl',
                                                              weight='bold'
                                                                ),
                                                BoxComponent(
                                                    layout = 'horizontal',
                                                    contents= [
                                                        ButtonComponent(
                                                            action = MessageAction(label='蛋糕',
                                                                                   text = '蛋糕食譜')
                                                            ),
                                                        ButtonComponent(
                                                            action = MessageAction (label = '派類', 
                                                                                    text = '派類食譜')
                                                               ),
                                                           ]
                                                       ),
                                                BoxComponent(
                                                    layout = 'horizontal',
                                                    contents= [
                                                        ButtonComponent(
                                                            action = MessageAction(label='塔類',
                                                                                   text = '塔類食譜')
                                                            ),
                                                        ButtonComponent(
                                                            action =MessageAction(label = '餅乾', 
                                                                                  text = '餅乾食譜')
                                                            )
                                                        ]
                                                    )
                                                   ],
                                    padding_start= '10px',
                                    padding_top='20px'
                                    )
                                ],
                        padding_all='0px'
                        )
                    )
              ]
            )
        
        message = FlexSendMessage(alt_text = "麵包食譜目錄",contents = carousel)
        line_bot_api.reply_message(event.reply_token,message)
    except:
        line_bot_api.reply_message(event.reply_token,TextSendMessage(text='發生錯誤！'))

def sendCOOKIErecipe(event): #餅乾食譜
    try:
        carousel = CarouselContainer(
            contents = [
               BubbleContainer(
                direction='ltr',
                body=BoxComponent(
                    layout='vertical',
                    contents=[
                        ImageComponent(
                            url = 'https://upload.cc/i1/2022/03/19/wTpxig.jpg', 
                            size = 'full',
                            aspect_mode= 'cover'),
                            BoxComponent(
                                layout = 'vertical',
                                contents = [TextComponent(text = '擠花餅乾食譜分類',
                                                          size = 'lg',
                                                          weight='bold'
                                                            ),
                                            BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='法式手指餅乾',
                                                                               text = '我想查法式手指餅乾')
                                                        ),
                                                    ButtonComponent(
                                                        action = MessageAction (label = '曲奇餅乾', 
                                                                                text = '我想查曲奇餅乾')
                                                           ),
                                                       ]
                                                   ),
                                            BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='羅蜜亞杏仁餅乾',
                                                                               text = '我想查羅蜜亞杏仁餅乾')

                                                        )
                                                    ]
                                                )
                                               ],
                                padding_start= '10px',
                                padding_top='20px'
                                )
                            ],
                    padding_all='0px'
                    )
                ),
                BubbleContainer(
                direction='ltr',
                body=BoxComponent(
                    layout='vertical',
                    contents=[
                        ImageComponent(
                            url = 'https://upload.cc/i1/2022/03/19/bWvTJz.jpg', 
                            size = 'full',
                            aspect_mode= 'cover'),
                            BoxComponent(
                                layout = 'vertical',
                                contents = [TextComponent(text = '美式簡易餅乾食譜分類',
                                                          size = 'lg',
                                                          weight='bold'
                                                            ),
                                            BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='巧克力豆餅乾',
                                                                               text = '我想查巧克力豆餅乾')
                                                        ),
                                                    ButtonComponent(
                                                        action = MessageAction (label = '巧克力玉米脆片', 
                                                                                text = '我想查巧克力玉米脆片')
                                                           ),
                                                       ]
                                                   ),
                                            BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='花生醬酥餅',
                                                                               text = '我想查花生醬酥餅')

                                                        ),
                                                    ButtonComponent(
                                                        action = MessageAction(label='麥片酥餅',
                                                                               text = '我想查麥片酥餅')
                                                        )
                                                    ]
                                                )
                                               ],
                                padding_start= '10px',
                                padding_top='20px'
                                )
                            ],
                    padding_all='0px'
                    )
                ),
                BubbleContainer(
                direction='ltr',
                body=BoxComponent(
                    layout='vertical',
                    contents=[
                        ImageComponent(
                            url = 'https://upload.cc/i1/2022/03/19/41YJvs.jpg', 
                            size = 'full',
                            aspect_mode= 'cover'),
                            BoxComponent(
                                layout = 'vertical',
                                contents = [TextComponent(text = '手工塑型餅乾食譜分類',
                                                          size = 'lg',
                                                          weight='bold'
                                                            ),
                                            BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='桃酥',
                                                                               text = '我想查桃酥')
                                                        ),
                                                    ButtonComponent(
                                                        action = MessageAction (label = '椰蓉小酥球', 
                                                                                text = '我想查椰蓉小酥球')
                                                           )
                                                    ]
                                                )
                                               ],
                                padding_start= '10px',
                                padding_top='20px'
                                )
                            ],
                    padding_all='0px'
                    )
                ),
                BubbleContainer(
                    direction='ltr',
                    body=BoxComponent(
                        layout='vertical',
                        contents=[
                            ImageComponent(
                                url = 'https://upload.cc/i1/2022/03/19/lcoItw.jpg', 
                                size = 'full',
                                aspect_mode= 'cover'),
                                BoxComponent(
                                    layout = 'vertical',
                                    contents = [TextComponent(text = '我蒐集的其他食譜...',
                                                              size = 'xl',
                                                              weight='bold'
                                                                ),
                                                BoxComponent(
                                                    layout = 'horizontal',
                                                    contents= [
                                                        ButtonComponent(
                                                            action = MessageAction(label='蛋糕',
                                                                                   text = '蛋糕食譜')
                                                            ),
                                                        ButtonComponent(
                                                            action = MessageAction (label = '派類', 
                                                                                    text = '派類食譜')
                                                               ),
                                                           ]
                                                       ),
                                                BoxComponent(
                                                    layout = 'horizontal',
                                                    contents= [
                                                        ButtonComponent(
                                                            action = MessageAction(label='塔類',
                                                                                   text = '塔類食譜')
                                                            ),
                                                        ButtonComponent(
                                                            action =MessageAction(label = '麵包', 
                                                                                  text = '麵包食譜')
                                                            )
                                                        ]
                                                    )
                                                   ],
                                    padding_start= '10px',
                                    padding_top='20px'
                                    )
                                ],
                        padding_all='0px'
                        )
                    )
              ]
            )
        message = FlexSendMessage(alt_text = "餅乾食譜目錄",contents = carousel)
        line_bot_api.reply_message(event.reply_token,message)
    except:
        line_bot_api.reply_message(event.reply_token,TextSendMessage(text='發生錯誤！'))

def sendCrecipe(event): #蛋糕食譜
    try:
        carousel = CarouselContainer(
            contents = [
               BubbleContainer(
                direction='ltr',
                body=BoxComponent(
                    layout='vertical',
                    contents=[
                        ImageComponent(
                            url = 'https://upload.cc/i1/2022/03/19/7PubZw.jpg', 
                            size = 'full',
                            aspect_mode= 'cover'),
                            BoxComponent(
                                layout = 'vertical',
                                contents = [TextComponent(text = '磅蛋糕食譜分類...',
                                                          size = 'lg',
                                                          weight='bold'
                                                            ),
                                            BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='原味磅蛋糕',
                                                                               text = '我想查原味磅蛋糕')
                                                        ),
                                                    ButtonComponent(
                                                        action = MessageAction (label = '檸檬糖霜磅蛋糕', 
                                                                                text = '我想查檸檬糖霜磅蛋糕')
                                                           ),
                                                       ]
                                                   ),
                                            BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='巧克力大理石磅蛋糕',
                                                                               text = '我想查巧克力大理石磅蛋糕')

                                                        )
                                                    ]
                                                )
                                               ],
                                padding_start= '10px',
                                padding_top='20px'
                                )
                            ],
                    padding_all='0px'
                    )
                ),
                BubbleContainer(
                direction='ltr',
                body=BoxComponent(
                    layout='vertical',
                    contents=[
                        ImageComponent(
                            url = 'https://upload.cc/i1/2022/03/19/whmqIp.jpg', 
                            size = 'full',
                            aspect_mode= 'cover'),
                            BoxComponent(
                                layout = 'vertical',
                                contents = [TextComponent(text = '天使蛋糕食譜分類',
                                                          size = 'lg',
                                                          weight='bold'
                                                            ),
                                            BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='香草天使蛋糕',
                                                                               text = '我想查香草天使蛋糕')
                                                        ),
                                                       ]
                                                   ),
                                            BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='黑豆漿芝麻天使蛋糕',
                                                                               text = '我想查黑豆漿芝麻天使蛋糕')

                                                        )
                                                    ]
                                                )
                                               ],
                                padding_start= '10px',
                                padding_top='20px'
                                )
                            ],
                    padding_all='0px'
                    )
                ),
                BubbleContainer(
                direction='ltr',
                body=BoxComponent(
                    layout='vertical',
                    contents=[
                        ImageComponent(
                            url = 'https://upload.cc/i1/2022/03/19/KCjO67.jpg', 
                            size = 'full',
                            aspect_mode= 'cover'),
                            BoxComponent(
                                layout = 'vertical',
                                contents = [TextComponent(text = '海綿蛋糕食譜分類',
                                                          size = 'lg',
                                                          weight='bold'
                                                            ),
                                            BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='巧克力海綿蛋糕',
                                                                               text = '我想查巧克力海綿蛋糕')
                                                        ),
                                                       ]
                                                   ),
                                            BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='芋泥海綿蛋糕',
                                                                               text = '我想查芋泥海綿蛋糕')

                                                        )
                                                    ]
                                                )
                                               ],
                                padding_start= '10px',
                                padding_top='20px'
                                )
                            ],
                    padding_all='0px'
                    )
                ),
                BubbleContainer(
                direction='ltr',
                body=BoxComponent(
                    layout='vertical',
                    contents=[
                        ImageComponent(
                            url = 'https://upload.cc/i1/2022/03/19/faD1hb.jpg', 
                            size = 'full',
                            aspect_mode= 'cover'),
                            BoxComponent(
                                layout = 'vertical',
                                contents = [TextComponent(text = '戚風蛋糕食譜分類',
                                                          size = 'lg',
                                                          weight='bold'
                                                            ),
                                            BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='藍莓戚風蛋糕',
                                                                               text = '我想查藍莓戚風蛋糕')
                                                        ),
                                                    ButtonComponent(  
                                                        action = MessageAction(label='香草戚風蛋糕',
                                                                               text = '我想查香草戚風蛋糕')
                                                        ),
                                                ]
                                                )
                                            ],
                                padding_start= '10px',
                                padding_top='20px'
                                )
                            ],
                    padding_all='0px'
                    )
                ),
                BubbleContainer(
                    direction='ltr',
                    body=BoxComponent(
                        layout='vertical',
                        contents=[
                            ImageComponent(
                                url = 'https://upload.cc/i1/2022/03/19/lcoItw.jpg', 
                                size = 'full',
                                aspect_mode= 'cover'),
                                BoxComponent(
                                    layout = 'vertical',
                                    contents = [TextComponent(text = '我蒐集的其他食譜...',
                                                              size = 'xl',
                                                              weight='bold'
                                                                ),
                                                BoxComponent(
                                                    layout = 'horizontal',
                                                    contents= [
                                                        ButtonComponent(
                                                            action = MessageAction(label='麵包',
                                                                                   text = '麵包食譜')
                                                            ),
                                                        ButtonComponent(
                                                            action = MessageAction (label = '派類', 
                                                                                    text = '派類食譜')
                                                               ),
                                                           ]
                                                       ),
                                                BoxComponent(
                                                    layout = 'horizontal',
                                                    contents= [
                                                        ButtonComponent(
                                                            action = MessageAction(label='塔類',
                                                                                   text = '塔類食譜')
                                                            ),
                                                        ButtonComponent(
                                                            action =MessageAction(label = '餅乾', 
                                                                                  text = '餅乾食譜')
                                                            )
                                                        ]
                                                    )
                                                   ],
                                    padding_start= '10px',
                                    padding_top='20px'
                                    )
                                ],
                        padding_all='0px'
                        )
                    )
              ]
            )
        message = FlexSendMessage(alt_text = "蛋糕食譜目錄",contents = carousel)
        line_bot_api.reply_message(event.reply_token,message)
    except:
        line_bot_api.reply_message(event.reply_token,TextSendMessage(text='發生錯誤！'))
        
def sendTrecipe(event): #塔類食譜
    try:
        carousel = CarouselContainer(
            contents = [
               BubbleContainer(
                direction='ltr',
                body=BoxComponent(
                    layout='vertical',
                    contents=[
                        ImageComponent(
                            url = 'https://upload.cc/i1/2022/03/19/e4A3s8.jpg', 
                            size = 'full',
                            aspect_mode= 'cover'),
                            BoxComponent(
                                layout = 'vertical',
                                contents = [TextComponent(text = '鹹塔食譜分類',
                                                          size = 'lg',
                                                          weight='bold'
                                                            ),
                                            BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='法式義式培根風味鹹塔',
                                                                               text = '我想查法式義式培根風味鹹塔')

                                                        )
                                                    ]
                                                )
                                               ],
                                padding_start= '10px',
                                padding_top='20px'
                                )
                            ],
                    padding_all='0px'
                    )
                ),
                BubbleContainer(
                direction='ltr',
                body=BoxComponent(
                    layout='vertical',
                    contents=[
                        ImageComponent(
                            url = 'https://upload.cc/i1/2022/03/19/VXHdx4.jpg', 
                            size = 'full',
                            aspect_mode= 'cover'),
                            BoxComponent(
                                layout = 'vertical',
                                contents = [TextComponent(text = '甜塔食譜分類',
                                                          size = 'lg',
                                                          weight='bold'
                                                            ),
                                            BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='法式檸檬塔',
                                                                               text = '我想查法式檸檬塔')
                                                        ),
                                                    ButtonComponent(
                                                        action = MessageAction(label='草莓塔',
                                                                               text = '我想查草莓塔"')
                                                        )
                                                       ]
                                                )
                                            ],
                                padding_start= '10px',
                                padding_top='20px'
                                )
                            ],
                    padding_all='0px'
                    )
                ),
                BubbleContainer(
                    direction='ltr',
                    body=BoxComponent(
                        layout='vertical',
                        contents=[
                            ImageComponent(
                                url = 'https://upload.cc/i1/2022/03/19/lcoItw.jpg', 
                                size = 'full',
                                aspect_mode= 'cover'),
                                BoxComponent(
                                    layout = 'vertical',
                                    contents = [TextComponent(text = '我蒐集的其他食譜...',
                                                              size = 'xl',
                                                              weight='bold'
                                                                ),
                                                BoxComponent(
                                                    layout = 'horizontal',
                                                    contents= [
                                                        ButtonComponent(
                                                            action = MessageAction(label='蛋糕',
                                                                                   text = '蛋糕食譜')
                                                            ),
                                                        ButtonComponent(
                                                            action = MessageAction (label = '派類', 
                                                                                    text = '派類食譜')
                                                               ),
                                                           ]
                                                       ),
                                                BoxComponent(
                                                    layout = 'horizontal',
                                                    contents= [
                                                        ButtonComponent(
                                                            action = MessageAction(label='麵包',
                                                                                   text = '麵包食譜')
                                                            ),
                                                        ButtonComponent(
                                                            action =MessageAction(label = '餅乾', 
                                                                                  text = '餅乾食譜')
                                                            )
                                                        ]
                                                    )
                                                   ],
                                    padding_start= '10px',
                                    padding_top='20px'
                                    )
                                ],
                        padding_all='0px'
                        )
                    )
              ]
            )
        message = FlexSendMessage(alt_text = "塔類食譜目錄",contents = carousel)
        line_bot_api.reply_message(event.reply_token,message)
    except:
        line_bot_api.reply_message(event.reply_token,TextSendMessage(text='發生錯誤！'))
        
def sendPrecipe(event): #派類食譜
    try:
        carousel = CarouselContainer(
            contents = [
               BubbleContainer(
                direction='ltr',
                body=BoxComponent(
                    layout='vertical',
                    contents=[
                        ImageComponent(
                            url = 'https://upload.cc/i1/2022/03/19/tdKvCS.jpg', 
                            size = 'full',
                            aspect_mode= 'cover'),
                            BoxComponent(
                                layout = 'vertical',
                                contents = [TextComponent(text = '鹹派食譜分類',
                                                          size = 'lg',
                                                          weight='bold'
                                                            ),
                                            BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='法式蘑菇鹹派',
                                                                               text = '我想查法式蘑菇鹹派')

                                                        )
                                                    ]
                                                )
                                               ],
                                padding_start= '10px',
                                padding_top='20px'
                                )
                            ],
                    padding_all='0px'
                    )
                ),
                BubbleContainer(
                direction='ltr',
                body=BoxComponent(
                    layout='vertical',
                    contents=[
                        ImageComponent(
                            url = 'https://upload.cc/i1/2022/03/19/XgaC8Q.jpg', 
                            size = 'full',
                            aspect_mode= 'cover'),
                            BoxComponent(
                                layout = 'vertical',
                                contents = [TextComponent(text = '甜派食譜分類',
                                                          size = 'lg',
                                                          weight='bold'
                                                            ),
                                            BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='蘋果派',
                                                                               text = '我想查蘋果派')
                                                        ),
                                                       ]
                                                   ),
                                            BoxComponent(
                                                layout = 'horizontal',
                                                contents= [
                                                    ButtonComponent(
                                                        action = MessageAction(label='藍莓派',
                                                                               text = '我想查藍莓派"')

                                                        )
                                                    ]            
                                                )
                                            ],
                                padding_start= '10px',
                                padding_top='20px'
                                )
                            ],
                    padding_all='0px'
                    )
                ),
                BubbleContainer(
                    direction='ltr',
                    body=BoxComponent(
                        layout='vertical',
                        contents=[
                            ImageComponent(
                                url = 'https://upload.cc/i1/2022/03/19/lcoItw.jpg', 
                                size = 'full',
                                aspect_mode= 'cover'),
                                BoxComponent(
                                    layout = 'vertical',
                                    contents = [TextComponent(text = '我蒐集的其他食譜...',
                                                              size = 'xl',
                                                              weight='bold'
                                                                ),
                                                BoxComponent(
                                                    layout = 'horizontal',
                                                    contents= [
                                                        ButtonComponent(
                                                            action = MessageAction(label='蛋糕',
                                                                                   text = '蛋糕食譜')
                                                            ),
                                                        ButtonComponent(
                                                            action = MessageAction (label = '麵包', 
                                                                                    text = '麵包食譜')
                                                               ),
                                                           ]
                                                       ),
                                                BoxComponent(
                                                    layout = 'horizontal',
                                                    contents= [
                                                        ButtonComponent(
                                                            action = MessageAction(label='塔類',
                                                                                   text = '塔類食譜')
                                                            ),
                                                        ButtonComponent(
                                                            action =MessageAction(label = '餅乾', 
                                                                                  text = '餅乾食譜')
                                                            )
                                                        ]
                                                    )
                                                   ],
                                    padding_start= '10px',
                                    padding_top='20px'
                                    )
                                ],
                        padding_all='0px'
                        )
                    )
              ]
            )
        message = FlexSendMessage(alt_text = "派類食譜目錄",contents = carousel)
        line_bot_api.reply_message(event.reply_token,message)
    except:
        line_bot_api.reply_message(event.reply_token,TextSendMessage(text='發生錯誤！'))

def sendQnA(event, mtext):  #問與答
    question = {
        'question': mtext[3:]
    }
    content = json.dumps(question)
    headers = {
        'Authorization': 'EndpointKey ' + endpoint_key,
        'Content-Type': 'application/json',
        'Content-Length': len(content)
    }
    conn = http.client.HTTPSConnection(host)
    conn.request ("POST", qnamethod, content, headers)
    response = conn.getresponse ()
    qanresult = json.loads(response.read())
    qanresult1 = qanresult['answers'][0]['answer']
    if 'No good match' in  qanresult1:
        text = '很抱歉，資料庫中無適當解答！\n請再輸入問題。'

    else:
        qanresult2 = qanresult1[2:]
        text =qanresult2
    message = TextSendMessage(
        text 
    )
    line_bot_api.reply_message(event.reply_token,message)
    
def sendRecipe(event, mtext):  #問食譜
    question = {
        'question': mtext[3:]
    }
    content = json.dumps(question)
    headers = {
        'Authorization': 'EndpointKey ' + endpoint_key,
        'Content-Type': 'application/json',
        'Content-Length': len(content)
    }
    conn = http.client.HTTPSConnection(host)
    conn.request ("POST", recipemethod, content, headers)
    response = conn.getresponse ()
    reciperesult = json.loads(response.read())
    reciperesult1 = reciperesult['answers'][0]['answer']
    if 'No good match' in reciperesult1:
        text= '很抱歉，資料庫中找不到你想找的食譜！\n再輸入看看其他食譜看看吧。'

    else:
        reciperesult2 = reciperesult1[2:]
        text =reciperesult2
    message = TextSendMessage(
        text 
    )
    line_bot_api.reply_message(event.reply_token,message)
    
def sendMistake(event, mtext): #回報問題
    try:
        message=TextSendMessage(
            text='發生問題了嗎？ \n趕快手刀來這邊回報！！',
            quick_reply=QuickReply(
                items = [
                    QuickReplyButton(
                        action= URITemplateAction(label="回報問題",uri='https://docs.google.com/forms/d/1Y8lfl142AZ0VvvUVsvNVRKXiJAhPIH9gDfMlwbnWqc0/edit?usp=sharing')
                        ),
                    ]
                )
            )
        line_bot_api.reply_message(event.reply_token,message)
    except:
        line_bot_api.reply_message(event.reply_token,TextSendMessage(Text='發生錯誤!'))

def sendMap (event): #地圖
    try:
        text1='以下這是屏東地區的食品材料行:\n https://www.google.com/maps/search/%E5%B1%8F%E6%9D%B1%E9%A3%9F%E5%93%81%E6%9D%90%E6%96%99%E8%A1%8C/@22.6482888,120.5469776,12z/data=!3m1!4b1'

        message = TextSendMessage(
                text = text1
                )
        line_bot_api.reply_message(event.reply_token,message)
    except:
        line_bot_api.reply_message(event.reply_token,TextSendMessage(Text='發生錯誤!'))
        
def sendStore(event): #商店提示
    try:
        text1='正在施工，即將推出，敬請期待！！'
        message = TextSendMessage(
                text = text1
                )
        line_bot_api.reply_message(event.reply_token,message)
    except:
        line_bot_api.reply_message(event.reply_token,TextSendMessage(Text='發生錯誤!')) 
        
def senderror(event): #錯誤警告
    try:
        text1='請使用範例之方式尋找食譜與問題解答\n還是有錯誤的話...\n請按「問題回報」將問題回報給我們！'
        message = TextSendMessage(
                text = text1
                )
        line_bot_api.reply_message(event.reply_token,message)
    except:
        line_bot_api.reply_message(event.reply_token,TextSendMessage(Text='發生錯誤!'))    

if __name__ == '__main__':
    app.run()
