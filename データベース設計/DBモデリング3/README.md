# 課題１

### ER 図

```mermaid
erDiagram
User {
  bigint user_id PK "ユーザーID"
  text user_name "ユーザー名"
}

User }|--|| Document : ""
User }|--|| Directory : ""

Document {
  text document_id PK "ドキュメントID ,uuid"
  text document_content "内容"
  text created_by "作成ユーザー"
  text updated_by "最終更新ユーザー"
  datetime created_at "作成日"
  datetime updated_by "最終更新日"
}

Directory {
  text directory_id PK "ディレクトリID ,uuid"
  text directory_name "ディレクトリ名"
  text created_by "作成ユーザー"
  text updated_by "最終更新ユーザー"
  datetime created_at "作成日"
  datetime updated_by "最終更新日"
}

Directory ||..o{ DocumentPath :""

DocumentPath {
  text document_id FK "ドキュメントID"
  text directory_id FK "ディレクトリID"
}

ListDirectory {
  text directory_id FK "ディレクトリID"
  text document_id FK "ドキュメントID"
}

Document ||--|{ ListDirectory : ""
Directory ||--|{ ListDirectory : ""


DirectoryPath {
  text parent_directory_id FK "親ディレクトリID"
  text child_direcotory_id FK "子ディレクトリID"
  int depth "階層"
}

DirectoryPath }|--|| Directory : ""
DirectoryPath }|--|| Directory : ""

```

### 仕様要件

- ドキュメント
  - いつ、誰が、どんなテキスト情報を保存したのか管理する
  - ドキュメントは必ず何らかのディレクトリに属する
- ディレクトリ
  - 一つ以上のドキュメントを含む階層構造
  - ディレクトリは無制限にサブディレクトリを持つことができる
  - ディレクトリ構造は柔軟に変更可能。ディレクトリが移動してサブディレクトリになることもあり得る
- ユーザ
  - ドキュメントを CRUD（作成、参照、更新、削除）できる
  - ディレクトリを CRUD できる
