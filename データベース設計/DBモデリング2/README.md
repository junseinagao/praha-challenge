# DB モデリング 2

## 課題 1

### 物理モデル

[https://dbdiagram.io/d/63084a02f1a9b01b0fe8767d](https://dbdiagram.io/d/63084a02f1a9b01b0fe8767d)

### 論理モデル

```mermaid
erDiagram
  User }|..o| ThreadMessage : "ユーザーはスレッドを0個以上投稿できる"
  User }|..o| Message : "ユーザーはメッセージを0個以上投稿できる"
  ThreadMessage }|..o| Message : "スレッドはメッセージを0個以上持つ/メッセージはスレッドなしには存在しない"
  Channel }|--|{ User : "チャネルはユーザーを1個以上持つ/ユーザーはチャネルを1個以上持つ"
  Channel }|--|{ Message : "チャネルはメッセージを1個以上持つ/メッセージはチャネルを1個以上持つ"
  Channel ||..o{ ThreadMessage : "チャネルはスレッドを0個以上持つ/スレッドはTHEチャネルを持つ"
  Workspace |o--|{ User : "ワークスペースはユーザーを1個以上持つ/ユーザーはワークスペースを0個以上持つ"
  Workspace ||--|{ Channel : "ワークスペースはTHEチャネルを持つ"
```

```mermaid
erDiagram
  Workspace ||--|{ Workspace_User : "has many"
  Workspace_User }|--|| User : "has the"
  Workspace ||--|{ Workspace_Channel : "has many"
  Workspace_Channel }|--|| Channel : "has the"

  Workspace {
    bigint workspaceId PK "ワークスペースID"
    varchar workspaceName "ワークスペース名"
  }

  Workspace_User {
    bigint workspaceId "ワークスペースID"
    bigint userId "ユーザID"
    boolean isActiveUser "有効ユーザーフラグ"
  }

  User {
    bigint userId PK "ユーザID"
    varchar userName "ユーザ名"
  }

  Workspace_Channel {
    bigint workspaceId "ワークスペースID"
    bigint channelId "チャンネルID"
    boolean isActiveChannel "有効チャンネルフラグ"
  }

  Channel {
    bigint channelId PK "チャンネルID"
    varchar channelName "チャンネル名"
    bigint workspaceId "ワークスペースID"
  }

  ThreadMessage {
    bigint threadMessageId PK "スレッドメッセージID"
    bigint channelId FK "チャンネルID"
    bigint userId FK "ユーザID"
    varchar threadMessageContent "スレッドメッセージ内容"
    timestamp threadMessageCreatedAt "スレッドメッセージ作成日時"
  }

  Message {
    bigint messageId PK "メッセージID"
    bigint threadMessageId FK "スレッドメッセージID"
    bigint userId FK "ユーザID"
    varchar messageContent "メッセージ内容"
    timestamp messageCreatedAt "メッセージ作成日時"
  }

  User }|..o| ThreadMessage : "may have many"
  User }|..o| Message : "may have many"
  ThreadMessage }|..o| Message : "may have many"
  Channel }|--|{ User : "has many"
  Channel }|--|{ Message : "has many"
  Channel }|--|{ ThreadMessage : "has many"
```

### 仕様

自分で付け足した仕様は `(add.)` で記載します。

- メッセージ

  - 誰が、どのチャネルに、いつ、どんな内容を投稿したのか分かること
  - (add.) メッセージの形式はテキストのみ
  - (add.) メッセージを投稿した日時を記録している
  - (add.) メッセージはスレッドメッセージがないと存在しない。

- スレッドメッセージ

  - 誰が、どのメッセージに、いつ、どんな内容をスレッドとして投稿したのか分かること
  - (add.) スレッドメッセージはメッセージを 0 個以上持つ
  - (add.) スレッドメッセージとスレッドの違いは子を持てるかどうか
  - (add.) スレッドメッセージのみを簡単に取得できる
  - (add.) スレッドメッセージはチャネルに紐付いている

- チャネル

  - そのチャネルに所属しているユーザにしか、メッセージ・スレッドメッセージが見えないこと

- ユーザ

  - (add.) ユーザーはユーザー名を設定できる
  - (add.) ユーザーはユーザー名を変更できる
  - ワークスペースに参加・脱退できること
  - チャネルに参加・脱退できること

- ワークスペース

  - (add.) ワークスペースは名前を設定できる
  - (add.) ワークスペースの名前は更新できる
  - (add.) ワークスペースは過去に参加したユーザーの情報を持っている。

- 横断機能
  - メッセージとスレッドメッセージを横断的に検索できること（例えば「hoge」と検索したら、この文字列を含むメッセージとスレッドメッセージを両方とも取得できること）
  - 参加していないチャネルのメッセージ・スレッドメッセージは検索できないこと

### 検討事項

- スレッドメッセージとメッセージは上手くやれば１つにまとめることができる
  - 自己参照にするとリレーションシップが複雑になりそうなので、別テーブルにする
