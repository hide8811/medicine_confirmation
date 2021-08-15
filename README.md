# 服薬確認アプリ

**URL:**
https://www.medicine-confirmation.tk

Basic認証<br>
ユーザー名: portfolio<br>
パスワード: popa8110

<br>

- [作成背景](#creation)
- [想定アプリ利用者](#user)
- [機能](#function)
- [使用技術](#technology)
- [DB設計](#db)
- [課題点](#reflection)
- [今後、修正・追加したい機能](#addition)
- [フィードバックと今後の対応](#feedback)

<br>

<span id='creation'></span>
## 作成背景

　前職(介護職)での問題であった、服薬のミスをなくすことを目的としたアプリです。<br>

　前の職場で、施設ご利用者様への薬の飲ませ忘れなどの”服薬ミス”が問題点として上がっていました。<br>
　服薬する薬の情報をまとめるなどの対策は取っていたのですが、紙ベースであったことや薬の変更が頻繁にあったことなどから、
情報の伝達や修正にも手間がかかっていました。

　そのため、誰がいつ何を飲むのかが一目でわかり、簡単に情報の修正をすることができれば服薬のミスがなくなるのではないかと考え、このアプリを作成しました。

<span id='user'></span>
### 想定アプリ利用者層

- 介護現場の職員
- 性別： 男女
- 年齢： 20代〜60代
- パソコンが苦手な職員もいる。

<span id='function'></span>
## 機能

### 職員登録・バリデーションエラー

![職員登録 バリデーションエラー](https://user-images.githubusercontent.com/65598351/128631460-f3ca828f-6efb-498c-a34c-5da0c4c476b2.gif)

### 服薬者 登録

※名前は全て仮名です。

![利用者 新規登録](https://user-images.githubusercontent.com/65598351/128632795-d4bbbff5-13df-48cb-829f-3d9cc6f2126b.gif)

### 服薬者 編集

![利用者 編集](https://user-images.githubusercontent.com/65598351/128632846-2a6b4f0d-086c-49af-a8e9-114922647757.gif)

### 服薬者 削除

![利用者 削除](https://user-images.githubusercontent.com/65598351/128632865-a8201c58-df9a-4b2f-b621-e9c5768a1a05.gif)

### 薬 登録

![薬 新規登録](https://user-images.githubusercontent.com/65598351/128632895-599d4f84-b060-4222-9aa2-cadddbb09190.gif)

### 参考サイト・薬 削除

![薬 削除](https://user-images.githubusercontent.com/65598351/128632905-8bbc5701-5b87-4ec5-9ee0-6933c03ffbcb.gif)

### 服薬時間・薬 登録

![服薬時間 新規登録](https://user-images.githubusercontent.com/65598351/128632915-7580bd69-d67b-483e-9fcc-dbf81afd97e1.gif)

### 服薬時間・薬 編集

![服薬時間 編集](https://user-images.githubusercontent.com/65598351/128632971-0981aea4-aeaa-4122-a62d-fe94c06dd796.gif)

### 服薬時間・薬 削除

![服薬時間 削除](https://user-images.githubusercontent.com/65598351/128633004-ab73fb49-5625-4b52-99be-2390f7896b00.gif)

### 薬 追加登録

![服薬時間 薬 新規登録](https://user-images.githubusercontent.com/65598351/128633058-c0fc5998-0afb-4e19-b4a5-ebff2becbc69.gif)

<span id='technology'></span>
## 使用技術

- Rails6
  - Haml
  - SCSS
  - jQuery
  - Device
  - Active Hash
  - Discard
  - Carrierwave
  - fog-aws
  - Rspec
  - Factory Bot
  - Capybara
  - Selenium WebDoriver
  - Pry
  - RuboCop
- MySQL
- Docker
  - docker-compose
- CircleCI
- AWS
  - EC2
  - RDS
  - S3
  - VPC
  - IAM
  - Certificate Manager
  - CLI
- Freenom

<span id='db'></span>
## DB設計

### users
| Field | Type | Constraint |
|---|---|---|
| employee_id | string | NOT NULL, UNIQUE |
| password | string | NOT NULL |
| last_name | string | NOT NULL |
| first_name | string | NOT NULL |
| last_name_kana | string | NOT NULL |
| first_name_kana | string | NOT NULL |
| status | string ||

### care_receivers
| Field | Type | Constraint |
|---|---|---|
| last_name | string | NOT NULL |
| first_name | string | NOT NULL |
| last_name_kana | string | NOT NULL |
| first_name_kana | string | NOT NULL |
| birthday | date | NOT NULL |
| discarded_at | datetime ||

### medicines
| Field | Type | Constraint |
|---|---|---|
| name | string | NOT NULL, UNIQUE |
| image | string ||
| url | string ||
| discarded_at | datetime ||

### dosing_times
| Field | Type | Constraint |
|---|---|---|
| time | time | NOT NULL |
| timeframe_id | smallint | NOT NULL |
| care_receiver_id | references | NOT NULL, FOREIGN KEY |
| discarded_at | datetime ||

### medicine_dosing_times
| Field | Type | Constraint |
|---|---|---|
| medicine_id | references | NOT NULL, FOREIGN KEY |
| dosing_time_id | references | NOT NULL, FOREIGN KEY |
| discarded_at | datetime ||

### takes
| Field | Type | Constraint |
|---|---|---|
| ececute | boolean | NOT NULL |
| dosing_timeframe | string | NOT NULL |
| dosing_time | time | NOT NULL |
| user_id | references | NOT NULL, FOREIGN KEY |
| care_receiver_id | references | NOT NULL, FOREIGN KEY |

※ Takesテーブルを使用した機能は未実装です。

<span id='reflection'></span>
## 課題点

- 理解が浅く、無理矢理繋げたような機能がある。
- 新しい知識を追加していったため、コードに統一性がなくなってしまった。
- 設計段階での構成が甘く、変更になることが多々あった。

<span id='addition'></span>
## 今後、修正・追加したい機能

- 職員の編集・削除機能
- Takesテーブルを使用した、服薬チェック機能
- コードの統一化
- 服薬者の家族の閲覧権限

<span id='feedback'></span>
## フィードバックと今後の対応

前職の同僚やもくもく会で知り合った方に試しに使用していただき、
フィードバックをいただきました。

- ご利用者様の顔写真が欲しい。<br><br>
  - 理由：<br>
服薬ミスの原因の一つに、人の名前と顔が一致しないというものがあった。名前だけでなく、顔でも確認できたほうが良いのではないか。<br><br>
  - 【今後の対応】<br>
`care_receivers`テーブルに`image`カラムを追加し、顔写真の登録・表示ができるように機能追加。

<br>

- 権限の付与があったほうが良い。<br><br>
  - 理由：<br>
今のアプリの状態では、どの職員でも編集・削除ができてしまう。一般職員は閲覧のみ、管理者は編集可能など、権限を分けたほうが良いのではないか。<br><br>
  - 【今後の対応】<br>
`users`テーブルに`authority`カラムを追加し、権限を付与する。
    - `admin`: 全権
    - `manager`: 薬の追加・削除、服薬の編集
    - `staff`: 閲覧のみ

<br>

- 時間帯ごとに絞り込み・ソートができたらいい。<br><br>
  - 理由：<br>
その時間帯に誰が服薬するのかをわかりやすくしたほうが良いのではないか。<br><br>
  - 【今後の対応】<br>
`dosing_times`コントローラーに`search`アクションを追加し、検索・絞り込みの機能を追加する。

<br>

- 通知機能があったほうが良い。<br><br>
  - 理由：<br>
"服薬のミスをなくす" ことを目的とするアプリであるならば、服薬の通知をするのも一つの方法であると思う。<br>
  - 【今後の対応】<br>
アプリを開いたとき、次の服薬予定を表示。`care_receivers#index`<br>
アプリを開く　→　現在時刻を取得　→　DB(`doisng_time`)から直近のデータを取得　→　ダイアログボックスで表示
