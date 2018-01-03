library(RCurl)
library(bitops)
library(XML)
library(tuneR)
library(rvest)
options(warn =-1)#去除警告
CODE=read.csv("E:\\exl\\lof.csv", header = FALSE)#读取LOF编号列表

UU = gsub("([N ])", "",paste("http://hq.sinajs.cn/list=sz",CODE[,1]))#读取新浪的LOF场内实时报价
headers=basicTextGatherer()
aa=getURL(UU,headerfunction=headers$update)
aa=strsplit(as.character(aa),",")
len=length(CODE[,1])
bb=aa
cc=aa
dd=aa
for(i in 1:len){
  bb=as.numeric(aa[][4])#现价。其他方法library(rlist) list.map(mylist,1)
  cc=as.numeric(aa[][7])#买价
  dd=as.numeric(aa[][8])#卖价
}
NOW=paste(bb)
BUY=paste(cc)
SELL=as.double(paste(dd))
LOF<- data.frame(CODE,NOW,BUY,SELL)

#doc <-htmlParse(getURL("http://fund.eastmoney.com/LOF_fundguzhi3.html"), 
#                asText = TRUE,encoding="UTF-8",ignoreBlanks = TRUE)
#读取天天基金的LOF估???
tables <- readHTMLTable("http://fund.eastmoney.com/LOF_fundguzhi3.html",
                        header=NA, trim = TRUE,as.data.frame = TRUE,which = 1,
                        colClasses =NULL, skip.rows =170:173)
#tables <- html_table("http://fund.eastmoney.com/LOF_fundguzhi3.html",
#                    header = NA, trim = TRUE, fill = FALSE)
#tables <- readHTMLTable(doc, header=F, which = 1)
LOF$GUZHI=tables[match(LOF[,1],tables[,3]),5]#比对数据找出对应的估值数???
LOF$GUZHI=as.double(paste(LOF$GUZHI))
LOF=transform(LOF,ZHEJIA=round((100-SELL/GUZHI*100),2))
new<-subset(LOF,ZHEJIA>=1)
if (nrow(new)==0)
{
  print("NO!")
} else {  print(new)
  timestamp()
  play("E:/exl/1.wma")#报警声音
}


#final.R
for(k in 1:50)
{
  source("E:\\exl\\quantmod.R")
  Sys.sleep(60)
  print(k)
}
print("end")
timestamp()
