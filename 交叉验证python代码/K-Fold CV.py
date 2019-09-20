from sklearn import linear_model
from sklearn.model_selection import KFold
import numpy as np
import pandas as pd
import math

test = pd.DataFrame(pd.read_excel('D:\\testtwr.xlsx'))
X = np.array(test[['Observed']])
Y = np.array(test['Predicted'])

accuracy = 0
r2 = 0
rmse = 0
me = 0
b = 0

kf = KFold(n_splits=10)
for train_index, test_index in kf.split(X):
    print("TRAIN:", train_index, "TEST:", test_index)
    X_train, X_test = X[train_index], X[test_index]
    y_train, y_test = Y[train_index], Y[test_index]
    print(X_train.shape,y_train.shape)
    clf = linear_model.LinearRegression()
    clf.fit(X_train, y_train)
    print('斜率：', clf.coef_)
    print('截距：', clf.intercept_)
    print('R2：', clf.score(X_train, y_train))
    list(clf.predict(X_test))
    print('准确率：', clf.score(X_test, y_test))
    print('平均误差：', (abs((y_test - clf.predict(X_test)))).sum()/len(X_test))
    print('误差平方和：', ((y_test - clf.predict(X_test)) ** 2).sum())
    print('均方根误差：', math.sqrt(((y_test - clf.predict(X_test)) ** 2).sum()/len(X_test)))
    accuracy = accuracy + clf.score(X_test, y_test)
    r2 = r2 + clf.score(X_train, y_train)
    rmse = rmse + math.sqrt(((y_test - clf.predict(X_test)) ** 2).sum()/len(X_test))
    me = me + (abs((y_test - clf.predict(X_test)))).sum()/len(X_test)
    b = b + 1

print('R2平均值：', r2 / b)
print('平均误差平均值：', me / b)
print('准确率平均值：', accuracy / b)
print('均方根误差平均值：', rmse / b)

