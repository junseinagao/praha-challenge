# DB モデリング 1

## 課題 1

### 完成 ER 図

```mermaid
erDiagram
    ORDER-SHEET ||--|{ ORDER-SHEET_ORDER : has-many
    ORDER-SHEET_ORDER }|--|| ORDER : has-the
    ORDER-SHEET }|--|| CUSTOMER-INFO : has-the
    ORDER-SHEET }|--|| TAX-INFO : has-the
    ORDER ||--|| MENU-ITEM : is
    MENU-ITEM ||--|| MENU-CATEGORY : is
    MENU-ITEM ||--|| PRICE-TYPE : is

    ORDER-SHEET {
        int id
        int customerInfoId
        int taxId
        bool isPaid
        date orderAt
    }

    ORDER-SHEET_ORDER {
        ind orderSheetId
        ind orderId
    }

    ORDER {
        int id
        int menuItemId
        int count
        bool isExcludeWasabi
    }

    MENU-ITEM {
        int id
        string name
        int priceTypeId
        int menuCategoryId
    }

    PRICE-TYPE {
        int id
        int price
    }

    MENU-CATEGORY {
        int id
        string name
    }

    CUSTOMER-INFO {
        int id
        string name
        string phoneNumber
    }

    TAX-INFO {
        int id
        float tax
    }
```

### 仕様要件

https://github.com/praha-inc/praha-challenge-templates/blob/master/db/design/sushi.png

### 物理モデルと論理モデルについて

(後述)

## 課題２

### 完成 ER 図

```mermaid
erDiagram
    ORDER-SHEET ||--|{ ORDER-SHEET_ORDER : has-many
    ORDER-SHEET }|--|| CUSTOMER-INFO : has-the
    ORDER-SHEET }|--|| TAX-INFO : has-the
    ORDER-SHEET_ORDER }|--|| ORDER : has-the
    ORDER ||--|{ ORDER_MENU-ITEM : has-many
    ORDER }|--|| SHARI-TYPE : is
    ORDER_MENU-ITEM }|--|| MENU-ITEM : has-the
    MENU-ITEM ||--|| MENU-CATEGORY : is
    MENU-ITEM ||--|| PRICE-TYPE : is
    MENU-ITEM ||--|| MENU-NAME: is

    ORDER-SHEET {
        int id
        int customerInfoId
        int taxId
        bool isPaid
        date orderAt
    }

    ORDER-SHEET_ORDER {
        ind orderSheetId
        ind orderId
    }

    ORDER {
        int id
        int count
        bool isExcludeWasabi
    }

    ORDER_MENU-ITEM {
        int orderId
        int menuItemId
    }

    MENU-ITEM {
        int id
        id menuNameId
        int priceTypeId
        int menuCategoryId
    }

    MENU-NAME {
        int id
        string name
    }

    SHARI-TYPE {
        int id
        string name
    }

    PRICE-TYPE {
        int id
        int price
    }

    MENU-CATEGORY {
        int id
        string name
    }

    CUSTOMER-INFO {
        int id
        string name
        string phoneNumber
    }

    TAX-INFO {
        int id
        float tax
    }
```

### 仕様変更要件

- しゃりの大小を選べるようにする
- セットの持つネタを特定できるようにする
- ネタ毎に集計できるようにする

## 課題 3

- 現場では、ワサビ「ぬき」の欄に ✓ マークに加えて、ワサビ抜きの枚数を数字で書く運用がされていました。それに対応して、ワサビを抜く枚数を指定できるようにしてください。
- 某人気店「Plate of silver」に対抗して、セットメニューを入れ替えれるようにしたいとシャッチョーがお達ししました。それに対応して、セットメニューのネタを自由に入れ替えた注文を保存できるようにしてください。(ここでは、セットメニューの金額はセットメニューの持つネタの金額の合計とします。また、入れ替える前のネタと入れ替えた後のネタの履歴を保存しておく必要があります。)
