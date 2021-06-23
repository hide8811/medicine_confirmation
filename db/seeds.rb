require 'csv'

User.create(employee_id: 'testUserID1234',
            password: 'testUserPass1234',
            last_name: 'テスト',
            first_name: 'ユーザー',
            last_name_kana: 'てすと',
            first_name_kana: 'ゆーざー')

CSV.foreach('db/seed/csv/care_receiver_demo_data.csv', headers: true) do |care_receiver|
  CareReceiver.create(
    last_name: care_receiver['last_name'],
    first_name: care_receiver['first_name'],
    last_name_kana: care_receiver['last_name_kana'],
    first_name_kana: care_receiver['first_name_kana'],
    birthday: care_receiver['birthday']
  )
end

CSV.foreach('db/seed/csv/medicine_demo_data.csv', headers: true) do |medicine|
  if medicine['image'].blank?
    Medicine.create(
      name: medicine['name'],
      url: medicine['url']
    )
  else
    Medicine.create(
      name: medicine['name'],
      image: File.open("#{Rails.root}/db/seed/img/medicine/#{medicine['image']}"),
      url: medicine['url']
    )
  end
end

CSV.foreach('db/seed/csv/dosing_time_demo_data.csv', headers: true) do |dosing_time|
  DosingTime.create(
    time: dosing_time['time'],
    timeframe_id: dosing_time['timeframe_id'],
    care_receiver_id: dosing_time['care_receiver_id']
  )
end

CSV.foreach('db/seed/csv/medicine_dosing_time_demo_data.csv', headers: true) do |medicine_dosing_time|
  MedicineDosingTime.create(
    medicine_id: medicine_dosing_time['medicine_id'],
    dosing_time_id: medicine_dosing_time['dosing_time_id']
  )
end
