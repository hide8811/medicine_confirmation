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
| name | string | NOT NULL |
| image | string ||
| url | string ||

### dosing_times
| Field | Type | Constraint |
|---|---|---|
| time | time | NOT NULL |
| timeframe | string | NOT NULL |
| care_receiver_id | references | FOREIGN KEY |

### medicine_dosing_times
| Field | Type | Constraint |
|---|---|---|
| medicine_id | references | FOREIGN KEY |
| dosing_time_id | references | FOREIGN KEY |

### takes
| Field | Type | Constraint |
|---|---|---|
| ececute | boolean | NOT NULL |
| date | date | NOT NULL |
| time | time | NOT NULL |
| dosing_time_id | references | FOREIGN KEY |
| user_id | references | FOREIGN KEY |

