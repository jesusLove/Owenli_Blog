# 介绍

## 数据清除

### 数据缺失

```
mean = df('view_duration').mean() // 平均值

df('view_duration').fillna(mean, inplace=True) // 替换缺失空数据

```

### 数据重复

```
df.duplicated() // 重复的行返回True
```

```
df.drop_duplicates(inplace=True) // 删除重复行，并替换
```

### 类型转换

```
df['timestamp'] = pd.to_datetime(df['timestamp']) //转为datetime类型
```

### 修改列名的几种方法

* `columns`属性

```
# ①暴力
df.columns = ['a', 'b', 'c', 'd', 'e']

# ②修改
df.columns = df.columns.str.strip('$')

# ③修改
df.columns = df.columns.map(lambda x:x[1:])

```

* `rename`方法, `columns`参数

```
# ④暴力（好处：也可只修改特定的列）
df.rename(columns=('$a': 'a', '$b': 'b', '$c': 'c', '$d': 'd', '$e': 'e'}, inplace=True) 

# ⑤修改
df.rename(columns=lambda x:x.replace('$',''), inplace=True)
```

## 绘图

```
%matplotlib inline // 显示图形

```
可以使用 `hist()`绘制直方图

```
df.hist() // 绘制所有列的直方图
df.hist(figsize=(8, 8)) // 设置大小
```

也可以使用`plot`绘制

```
df['列名'].plot(kind='hist')
/*
‘bar’ or ‘barh’ 条形图
‘hist’ 直方图
‘box’ for boxplot
‘kde’ or 'density' for density plots
‘area’ for area plots
‘scatter’ for scatter plots
‘hexbin’ for hexagonal bin plots
‘pie’ for pie plots
*/
```
绘制饼状图

```
df['AT'].value_counts().plot(kind='pie', figsize=(8,8))

```

绘制关系图

```
pd.plotting.scatter_matrix(df, figsize=(15, 15))
// 绘制所有关系图

```

密度图（某一项的分布范围）

```
df['RH'].plot.kde() // 单列密度图

df.plot.kde() // 所有列分布图
```

散点图

```
df.plot.scatter(x='a', y='b') // a， b代表不同的列
# or
df.plot(x='a', y='b', kind='scatter')

```

箱线图

```
# 绘制每个变量的箱线图
df.plot(kind='box')
```