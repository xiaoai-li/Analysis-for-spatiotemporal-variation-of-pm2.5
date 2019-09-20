 ;;===============================================================================================
 ;;;  该程序是通过6s辐射校正模型生成查找表，以便进行气溶胶反演
 ;    该程序参数设置较为简单，如果要详细的参数，请自行设置
 ;    改进方法：1、读取每一个影像的角度信息建立查找表，这样精度更高
 ;             2、利用IDL直接调用Fortran语言的6S源程序，并行生成查找表，速度提高20倍左右
 ;             3、将所有参数都设置好，缩小步长，构建一个庞大的查找表，构建神经网络，一劳永逸
 ;;;==============================================================================================
 PRO MODIS_LUT;,month,day,iwave,idatm,iaer,lutpath,lutname
   igeom=0;自定义几何条件
   phi0=0;卫星方位角++++
   month=5;；月份
   day=17;；日期
   idatm=2;：大气模式中纬度夏季
   iaer=1;：气溶胶模式大陆型
   v=0;；能见度
   xps=0;；目标物高度
   xpp=-1000;；星测
   iwave=42;：自定义1输入波段范围和反射相函数42为modis的red
   inhomo=0;；地表反射率均一地表
   idirect=0;；无方向效应
   igroun=1;：绿色植被
   rapp=-2;：无大气校正
   tao=[0.0001,0.25,0.5,1.0,1.5,1.95];；550nm气溶胶光学厚度
   asol=[0,12,24,36,48,60];；太阳天顶角
   avis=[0,12,24,36,48,60];；卫星天顶角
   phiv=[0,24,48,72,96,120,144,168,180];；太阳方位角(卫星方位角为0，即相对方位角为O．180)
   ; CD,lutpath
   cd,'C:\Users\Administrator\Desktop\6s_lut';自己更改6s.exe所在的文件夹路径
   lutname='modis_lut.txt'
   OPENW,lutlun,lutname,/get_lun
   ;设置循环过程
   ;for a=0,2 do begin;蓝红两个通道
   FOR b=0,5 DO BEGIN;550nm气溶胶光学厚度
     FOR c=0,5 DO BEGIN;太阳天顶角
       FOR d=0,5 DO BEGIN;；卫星天顶角
         FOR e=0,8 DO BEGIN;；太阳方位角(卫星方位角为0，即相对方位角为O．180)
           txtname='in.txt'
           OPENW,lun,txtname,/get_lun
           PRINTF,lun,igeom
           PRINTF,lun,asol[c],phiv[e],avis[d],phi0,month,day
           PRINTF,lun,idatm
           PRINTF,lun,iaer
           PRINTF,lun,v
           PRINTF,lun,tao[b]
           PRINTF,lun,xps
           PRINTF,lun,xpp
           PRINTF,lun,iwave
           PRINTF,lun,inhomo
           PRINTF,lun,idirect
           PRINTF,lun,igroun
           PRINTF,lun,rapp
           FREE_LUN,lun
           SPAWN,'6s.exe<in.txt>out.txt',/hide ;调用6s <>符号为dos系统下的重定向符号     <从文件读取命令输入>将输出结果写入文件
           txtname='out.txt'
           OPENR,lun,txtname,/get_lun
           temp=STRARR(1,120)
           READF,lun,temp
           tt=STRMID(temp[0,105],61,8)
           sA=STRMID(temp[0,111],61,8)
           rou=STRMID(temp[0,114],61,8)
           FREE_LUN,lun
           ;依次为辐射方程中的P T S参数、太阳天顶角，卫星天顶角，相对方位角、气溶胶光学厚度
           PRINTF,lutlun,sA,tt,rou,asol[c],avis[d],phiv[e],tao[b]
         ENDFOR
       ENDFOR
     ENDFOR
   ENDFOR
   ;  endfor
   FREE_LUN,lutlun
 END
 
 
 
 
