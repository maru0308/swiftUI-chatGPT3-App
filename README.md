# swiftUI-chatGPT3-App
Communicate with GPT-3 using OpenAISwift library
# SwiftUIを使ってOpenAI GPT-3チャットアプリを作成する

この記事では、SwiftUIを使ってOpenAI GPT-3とのチャットアプリを作成する方法を紹介します。このアプリでは、OpenAISwiftライブラリを使用してGPT-3とコミュニケーションを行います。

## 前提条件

この記事で取り上げるコードは、SwiftUIとOpenAISwiftを利用しています。事前に以下の手順が必要です。

1. Xcodeのインストール
2. SwiftUIの知識
3. OpenAISwiftライブラリのインストール

## コードの説明

### インポート

まず、SwiftUIとOpenAISwiftをインポートします。

```swift
import SwiftUI
import OpenAISwift
```
### ViewModelクラス

次に、ViewModelクラスを作成し、ObservableObjectプロトコルを実装します。このクラスでは、setUp()メソッドでOpenAIクライアントを初期化し、send()メソッドでGPT-3にテキストを送信して応答を受け取ります。

```swift
class ViewMOdel: ObservableObject {
    private var client:OpenAISwift?
    
    func setUp () {
        client = OpenAISwift(authToken: "your_auth_token_here")
    }
    
    func send(text: String, completion: @escaping (String) -> Void) {
        client?.sendCompletion(with: text, model:.gpt3(.davinci), maxTokens: 500, completionHandler: { result in
            switch result {
            case .success(let model):
                if let output = model.choices.first?.text {
                    completion(output)
                } else {
                    completion("エラー: 応答テキストが取得できませんでした。")
                }
            case .failure(let error):
                completion("エラー: \(error.localizedDescription)")
            }
        })
    }
}
```

# ContentView構造体
最後に、ContentView構造体を作成します。この構造体は、テキスト入力フィールドと送信ボタンを作成します。するとユーザーがテキストを入力して送信すると、GPT-3からの応答が表示されます。

# 参考リンク
https://www.youtube.com/watch?v=bUDCW2NeO8Y&t=33

