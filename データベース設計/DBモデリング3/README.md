# 課題１

### ER 図

```mermaid
erDiagram
User {
  bigint user_id PK "ユーザーID"
  text user_name "ユーザー名"
  datetime created_at "作成日時"
}

User }|--|| Document : "N:1"
User }|--|| Directory : "N:1"

Document {
  text document_id PK "ドキュメントID ,uuid"
  text directory_id FK "所属するディレクトリID"
  text document_content "内容"
  text created_by "作成ユーザー"
  text updated_by "最終更新ユーザー"
  datetime created_at "作成日"
  datetime updated_at "最終更新日"
}

DocumentChangedLog {
  text document_id PK "ドキュメントID ,uuid"
  text directory_id FK "所属するディレクトリID"
  text document_content "内容"
  text updated_by "最終更新ユーザー"
  datetime updated_at "最終更新日"
}

DocumentChangedLog }|--|| Document : "N:1"

Document }|--|| Directory : "N:1"

Directory {
  text directory_id PK "ディレクトリID ,uuid"
  text directory_name "ディレクトリ名"
  text created_by "作成ユーザー"
  text updated_by "最終更新ユーザー"
  datetime created_at "作成日"
  datetime updated_at "最終更新日"
}

Directory_Directory {
  text parent_directory_id FK "親ディレクトリID"
  text child_direcotory_id FK "子ディレクトリID"
  int depth "階層"
}

Directory_Directory }|--|| Directory : "N:1 (1)"
Directory_Directory }|--|| Directory : "N:1 (2)"

```

### 仕様要件

- ドキュメント
  - いつ、誰が、どんなテキスト情報を保存したのか管理する
    - (add.) 履歴を取得することができる
    - (add.) 変更した差分を取得することができる
  - ドキュメントは必ず何らかのディレクトリに属する
- ディレクトリ
  - 一つ以上のドキュメントを含む階層構造
  - ディレクトリは無制限にサブディレクトリを持つことができる
  - ディレクトリ構造は柔軟に変更可能。ディレクトリが移動してサブディレクトリになることもあり得る
    - (add.) ディレクトリは 0 個以上のドキュメントまたはディレクトリを持つ
- ユーザ
  - ドキュメントを CRUD（作成、参照、更新、削除）できる
  - ディレクトリを CRUD できる
    - (add.) ディレクトリが Delete された場合、そのディレクトリに属する全てのドキュメントとディレクトリが削除される

# 課題 2

### 仕様要件

- ディレクトリ内のドキュメントの順番を変更できる
  - (add.) ドキュメントの順番を保持する
- 順番はユーザー間で共有される

```mermaid
erDiagram
User {
  bigint user_id PK "ユーザーID"
  text user_name "ユーザー名"
  datetime created_at "作成日時"
}

User }|--|| Document : "N:1"
User }|--|| Directory : "N:1"

Document {
  text document_id PK "ドキュメントID ,uuid"
  text directory_id FK "所属するディレクトリID"
  text document_content "内容"
  text created_by "作成ユーザー"
  text updated_by "最終更新ユーザー"
  text prev_document_id FK "前のドキュメントID,nullable"
  text next_document_id FK "次のドキュメントID,nullable"
  datetime created_at "作成日"
  datetime updated_at "最終更新日"
}

DocumentChangedLog {
  text document_id PK "ドキュメントID ,uuid"
  text directory_id FK "所属するディレクトリID"
  text document_content "内容"
  text updated_by "最終更新ユーザー"
  datetime updated_at "最終更新日"
}

DocumentChangedLog }|--|| Document : "N:1"

Document ||--|| Document : "1:1 (1)"
Document ||--|| Document : "1:1 (2)"

Document }|--|| Directory : "N:1"

Directory {
  text directory_id PK "ディレクトリID ,uuid"
  text directory_name "ディレクトリ名"
  text created_by "作成ユーザー"
  text updated_by "最終更新ユーザー"
  datetime created_at "作成日"
  datetime updated_at "最終更新日"
}

Directory_Directory {
  text parent_directory_id FK "親ディレクトリID"
  text child_direcotory_id FK "子ディレクトリID"
  int depth "階層"
}

Directory_Directory }|--|| Directory : "N:1 (1)"
Directory_Directory }|--|| Directory : "N:1 (2)"

```

### food for thought

- Todoist はおそらく `child_order` を親に持たせてる。

![](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/386b66ec-2d80-4479-9c4c-69624c9d65c0/todoist-food-for-thought.mp4?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20220908%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20220908T054123Z&X-Amz-Expires=86400&X-Amz-Signature=afe90d6ff0d01552b53a38e077ae13ab12c2151fba6248e37240ab42dcc9974e&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22todoist-food-for-thought.mp4%22&x-id=GetObject)
