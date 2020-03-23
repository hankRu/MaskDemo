# 口罩公開資料 Demo - Decision 網路抽象層 #

> 來自 Kingfisher 作者「王巍」在2019 iPlayground, 第二天第一場議程所提出的 Decision 網路抽象層概念
強者我同事將此概念實現出來，此為使用範例

### 資料來源 ###
* rickhung76：[ComponentNetworkRouterDemo](https://github.com/rickhung76/ComponentNetworkRouterDemo)
* Open API URL:  [口罩公開資料API](https://raw.githubusercontent.com/kiang/pharmacies/master/json/points.json)
* 王巍:  [網路難，難於上青天 - 用部件化的方式簡化網路程式設計](https://hackmd.io/@iPlayground/rk7P7tTNB)

### 摘要 ###

* SRP 單一職責原則 Single Responsibility principle

> 不要全扔到一個地方。你的代碼庫，不是垃圾場。
> 連垃圾都需要分類！！

* client 的職責

> 1. 配置請求
> 2. 處理回應

### Content Adatpter ###

新增Adapter來處理資料等，像是前面提到的那幾個問題(Httpmedthod & ContentType)
為 Request 配置 [RequestAdapter]

### 抽象： Response Decision ###

用決策 Decision來抽象化

* continue
* restart
* error
* done

### 優勢 ###

* 元件化 清晰
* 純函數 可測試
* 基於protocol 靈活
* 更多決策 可擴展
* 細粒度控制 可操作
* 最後最後的總結

