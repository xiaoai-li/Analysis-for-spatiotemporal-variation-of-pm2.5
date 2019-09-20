from sklearn import linear_model
from sklearn.model_selection import train_test_split
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import math

test=pd.DataFrame(pd.read_excel('D:\\testtwr.xlsx'))
X =np.array(test[['Observed']])
Y =np.array(test['Predicted'])

#设置图表字体为华文细黑，字号15
plt.rc('font', family='STXihei', size=15)
#绘制散点图，广告成本X，点击量Y，设置颜色，标记点样式和透明度等参数
plt.scatter(X,Y,60,color='blue',marker='o',linewidth=3,alpha=0.8)
#添加x轴标题
plt.xlabel('Observed')
#添加y轴标题
plt.ylabel('Predicted')
#添加图表标题
plt.title('Observed and Predicted PM2.5 Analysis')
#设置背景网格线颜色，样式，尺寸和透明度
plt.grid(color='#95a5a6',linestyle='--', linewidth=1,axis='both',alpha=0.4)
#显示图表
plt.show()

X_train, X_test, y_train, y_test= train_test_split(X, Y, test_size=0.2, random_state=42)
print('训练集大小：',X_train.shape,y_train.shape)
print('测试集大小：',X_test.shape,y_test.shape)
clf =linear_model.LinearRegression()
clf.fit (X_train,y_train)
print('斜率：',clf.coef_)
print('截距：',clf.intercept_)
print('R2：',clf.score(X_train,y_train))
list(clf.predict(X_test))
print('准确率：', clf.score(X_test, y_test))
print('平均误差：', (abs((y_test - clf.predict(X_test)))).sum() / len(X_test))
print('误差平方和：',((y_test - clf.predict(X_test))**2).sum())
print('均方根误差：', math.sqrt(((y_test - clf.predict(X_test)) ** 2).sum()/len(X_test)))