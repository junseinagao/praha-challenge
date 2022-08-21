# DB モデリング 2

## 課題 1

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

### 物理モデル

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

  User }|..o| ThreadMessage : "may have many"
  User }|..o| Message : "may have many"
  ThreadMessage }|..o| Message : "may have many"
  Channel }|--|{ User : "has many"
  Channel }|--|{ Message : "has many"
  Channel }|--|{ ThreadMessage : "has many"
```

### 仕様

- メッセージ

  - 誰が、どのチャネルに、いつ、どんな内容を投稿したのか分かること

- スレッドメッセージ

  - 誰が、どのメッセージに、いつ、どんな内容をスレッドとして投稿したのか分かること

- チャネル

  - そのチャネルに所属しているユーザにしか、メッセージ・スレッドメッセージが見えないこと

- ユーザ

  - ワークスペースに参加・脱退できること
  - チャネルに参加・脱退できること

- 横断機能
  - メッセージとスレッドメッセージを横断的に検索できること（例えば「hoge」と検索したら、この文字列を含むメッセージとスレッドメッセージを両方とも取得できること）
  - 参加していないチャネルのメッセージ・スレッドメッセージは検索できないこと
