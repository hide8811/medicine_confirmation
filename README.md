# Medicine Confirmation
**URL:**
https://www.medicine-confirmation.tk

## 作成背景

前職(介護職)での問題であった、服薬情報をまとめるためのアプリです。<br>

前の職場で、施設ご利用者様への服薬ミスが問題点として上がっていました。<br>
その時は、服薬時間帯ごとに薬を準備することや、服薬する薬の情報をまとめて提示することで改善しました。<br>

上記の方法で服薬のミスは減少しました。<br>
しかし、紙ベースであったことや、薬の変更が頻繁にあったことなどから、情報修正に手間がかかっていました。<br>
その手間を減らせないか考えながら作成したのが、こちらのアプリになります。

### 想定アプリ利用者層

- 介護現場の職員
- 性別： 男女
- 年齢： 20代〜60代
- パソコンが苦手な職員もいる。

### 機能

- 職員登録
- 服薬者登録
- 薬登録
- 服薬時間帯(いつ服薬するのか)の表示・追加・削除
- 服薬する薬の表示・追加・削除

## 使用技術

- Rails6
  - haml
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
| first_name_kana | string | NOT NULL |
| last_name_kana | string | NOT NULL |
| first_name_kana | string | NOT NULL |
| birthday | date | NOT NULL |
| enroll | boolean | NOT NULL |

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

## 反省点

- 理解が浅く、無理矢理繋げたような機能がある。
- 新しい知識を追加していったため、コードに統一性がなくなってしまった。
- 設計段階での構成が甘く、変更になることが多々あった。

## 今後、修正・追加したい機能

- 職員の編集・削除機能
- 服薬者の編集・削除機能
- 論理削除に関連したデータ取得の改善
- Takesテーブルを使用した、服薬チェック機能
- コードの統一化

