

import SwiftUI
import OpenAISwift


 class ViewMOdel: ObservableObject {

//    OpenAI APIへのアクセスを管理するためのオプショナルなプロパティ
    private var client:OpenAISwift?
    
    func setUp () {
        client = OpenAISwift(authToken:"your_auth_token_here")
    }
    

     
     func send(text: String, completion: @escaping (String) -> Void) {
         // OpenAI APIを使って、入力テキストに対するGPTモデルの応答を取得します。
         client?.sendCompletion(with: text, model:.gpt3(.davinci), maxTokens: 500, completionHandler: { result in
             // 成功と失敗の両方のケースを処理します。
             switch result {
             case .success(let model):
                        // 成功した場合、取得したテキストをoutputに格納し、completionクロージャで返します。
                        if let output = model.choices.first?.text {
                            completion(output)
                        } else {
                            // choices.first?.text が nil の場合、エラーメッセージをcompletionクロージャに渡します。
                            completion("エラー: 応答テキストが取得できませんでした。")
                        }
             case .failure(let error):
                       // 失敗した場合、エラーメッセージをcompletionクロージャに渡します。
                       completion("エラー: \(error.localizedDescription)")
                   
             }
         })
     }
}




// ContentViewは、UIの主要部分を表す構造体で、NavigationViewとVStackを含んでいます。
struct ContentView: View {
    
    // プロパティ
    @ObservedObject var viewModel = ViewMOdel() // ViewMOdelクラスのインスタンス
    @State var text = "" // 入力フィールドに入力されたテキスト
    @State var models = [String]() // 表示するメッセージの配列

    // bodyは、アプリのUIを定義しています。
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        // models配列内の各文字列を繰り返し、UIに表示します。
                        ForEach(models, id: \.self) { string in
                            Text(string)
                                .padding(8)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                                .foregroundColor(Color.black)
                                .font(.system(size: 16))
                        }
                    }
                }.padding(.top)
                
                Spacer()
                
                // 入力フィールドと送信ボタンが含まれるHStackです。
                HStack() {
                    TextField("入力する", text: $text)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    
                    Button(action: {
                        // 送信ボタンがタップされた時のアクションです。
                        send()
                    }) {
                        Text("送信")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
                .padding()
                // 画面表示時にViewModelをセットアップします。
                .onAppear {
                    viewModel.setUp()
                }
            }
            .navigationBarTitle("GPT-3 Chat(davinci)", displayMode: .inline)
        }
    }
    
    // send()関数は、入力テキストをGPTモデルに送信し、結果を表示するための関数です。
    func send() {
        // 入力フィールドが空白でないことを確認します。
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        // メッセージをmodels配列に追加します。
        models.append("私: \(text)")
        // GPTモデルにテキストを送信し、結果を処理します。
        viewModel.send(text: text) { response in
            DispatchQueue.main.async {
                self.models.append("ChatGTP:" + response)
                self.text = ""
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
