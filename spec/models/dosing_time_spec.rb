require 'rails_helper'

RSpec.describe DosingTime, type: :model do
  let(:care_receiver_a) { create(:care_receiver) }
  let(:care_receiver_b) { create(:care_receiver) }

  shared_examples '有効' do
    it { expect(dosing_time).to be_valid }
  end

  context 'time, timeframe_id, care_receiver_id がある場合' do
    let(:dosing_time) { build_stubbed(:dosing_time) }
    it_behaves_like '有効'
  end

  describe 'column: time' do
    context '空の場合' do
      it '無効であること' do
        dosing_time = build_stubbed(:dosing_time, time: '')
        dosing_time.valid?
        expect(dosing_time.errors[:time]).to include("can't be blank")
      end
    end

    context '重複する場合' do
      before do
        create(:dosing_time, time: '10:00', care_receiver_id: care_receiver_a.id)
      end

      context 'care_recever_id が同じ場合' do
        it '無効であること' do
          dosing_time = build(:dosing_time, time: '10:00', care_receiver_id: care_receiver_a.id)
          dosing_time.valid?
          expect(dosing_time.errors[:time]).to include('has already been taken')
        end
      end

      context 'care_recever_id が違う場合' do
        let(:dosing_time) { build(:dosing_time, time: '10:00', care_receiver_id: care_receiver_b.id) }
        it_behaves_like '有効'
      end
    end
  end

  describe 'column: timeframe_id' do
    context '空の場合' do
      it '無効であること' do
        dosing_time = build_stubbed(:dosing_time, timeframe_id: '')
        dosing_time.valid?
        expect(dosing_time.errors[:timeframe_id]).to include("can't be blank")
      end
    end

    context '重複する場合' do
      before do
        create(:dosing_time, timeframe_id: 1, care_receiver_id: care_receiver_a.id)
      end

      context 'care_recever_id が同じ場合' do
        it '無効であること' do
          dosing_time = build(:dosing_time, timeframe_id: 1, care_receiver_id: care_receiver_a.id)
          dosing_time.valid?
          expect(dosing_time.errors[:timeframe_id]).to include('has already been taken')
        end
      end

      context 'care_recever_id が違う場合' do
        let(:dosing_time) { build(:dosing_time, timeframe_id: '朝食後', care_receiver_id: care_receiver_b.id) }
        it_behaves_like '有効'
      end
    end
  end

  describe 'column: care_receiver_id' do
    context '空の場合' do
      it '無効であること' do
        dosing_time = build_stubbed(:dosing_time, care_receiver_id: '')
        dosing_time.valid?
        expect(dosing_time.errors[:care_receiver_id]).to include("can't be blank")
      end
    end
  end

  describe 'active_medicines' do
    subject { DosingTime.includes(:active_medicines).map(&:active_medicines).flatten }

    context 'DosingTimeに関連するMedicineのデータが複数あった場合' do
      let(:care_receiver) { create(:care_receiver) }
      let(:dosing_time) { create(:dosing_time, care_receiver_id: care_receiver.id) }
      let!(:medicine_a) { create(:medicine) }
      let!(:medicine_b) { create(:medicine) }
      let!(:medicine_c) { create(:medicine) }

      before do
        create(:medicine_dosing_time, dosing_time_id: dosing_time.id, medicine_id: medicine_a.id)
        create(:medicine_dosing_time, dosing_time_id: dosing_time.id, medicine_id: medicine_c.id)
        create(:medicine_dosing_time, dosing_time_id: dosing_time.id, medicine_id: medicine_b.id)
      end

      it { is_expected.to match [medicine_a, medicine_b, medicine_c] }
    end

    context 'MedicineDosingTimeに論理削除されたデータがあった場合' do
      let(:care_receiver) { create(:care_receiver) }
      let(:dosing_time) { create(:dosing_time, care_receiver_id: care_receiver.id) }
      let(:medicine_a) { create(:medicine) }
      let(:medicine_b) { create(:medicine) }
      let(:medicine_c) { create(:medicine) }

      before do
        create(:medicine_dosing_time, dosing_time_id: dosing_time.id, medicine_id: medicine_a.id)
        create(:medicine_dosing_time, dosing_time_id: dosing_time.id, medicine_id: medicine_b.id)
        mdt = create(:medicine_dosing_time, dosing_time_id: dosing_time.id, medicine_id: medicine_c.id)
        mdt.discard
      end

      it '論理削除された関連データは取得されないこと' do
        aggregate_failures do
          is_expected.to include medicine_a
          is_expected.to include medicine_b
          is_expected.not_to include medicine_c
        end
      end
    end
  end

  describe 'scope' do
    describe 'list_fetch' do
      subject { DosingTime.list_fetch(care_receiver) }

      context 'DosingTimeに複数のデータがあった場合' do
        let(:care_receiver) { create(:care_receiver) }
        let(:after_breakfast) { create(:dosing_time, timeframe_id: 5, care_receiver_id: care_receiver.id) }
        let(:after_lunch) { create(:dosing_time, timeframe_id: 10, care_receiver_id: care_receiver.id) }
        let(:after_dinner) { create(:dosing_time, timeframe_id: 15, care_receiver_id: care_receiver.id) }
        let(:before_sleeping) { create(:dosing_time, timeframe_id: 17, care_receiver_id: care_receiver.id) }
        let(:medicine_a) { create(:medicine) }
        let(:medicine_b) { create(:medicine) }
        let(:medicine_c) { create(:medicine) }

        before do
          create(:medicine_dosing_time, dosing_time_id: after_lunch.id, medicine_id: medicine_a.id)
          create(:medicine_dosing_time, dosing_time_id: after_dinner.id, medicine_id: medicine_a.id)
          create(:medicine_dosing_time, dosing_time_id: after_dinner.id, medicine_id: medicine_b.id)
          create(:medicine_dosing_time, dosing_time_id: after_dinner.id, medicine_id: medicine_c.id)
          create(:medicine_dosing_time, dosing_time_id: after_breakfast.id, medicine_id: medicine_b.id)
          create(:medicine_dosing_time, dosing_time_id: before_sleeping.id, medicine_id: medicine_b.id)
        end

        it { expect(subject.length).to eq 4 }

        it { is_expected.to match [after_breakfast, after_lunch, after_dinner, before_sleeping] }

        it '関連したMedicineのデータも取得されること' do
          aggregate_failures do
            expect(subject[0].medicines).to match_array [medicine_b]
            expect(subject[1].medicines).to match_array [medicine_a]
            expect(subject[2].medicines).to match_array [medicine_a, medicine_b, medicine_c]
            expect(subject[3].medicines).to match_array [medicine_b]
          end
        end
      end

      context 'DosingTimeに論理削除されたデータがあった場合' do
        let(:care_receiver) { create(:care_receiver) }
        let(:after_breakfast) { create(:dosing_time, timeframe_id: 5, care_receiver_id: care_receiver.id) }
        let(:after_lunch) { create(:dosing_time, timeframe_id: 10, care_receiver_id: care_receiver.id) }
        let(:medicine_a) { create(:medicine) }
        let(:medicine_b) { create(:medicine) }

        before do
          create(:medicine_dosing_time, dosing_time_id: after_breakfast.id, medicine_id: medicine_a.id)
          create(:medicine_dosing_time, dosing_time_id: after_lunch.id, medicine_id: medicine_b.id)
          after_lunch.discard
        end

        it { is_expected.to include after_breakfast }
        it { is_expected.not_to include after_lunch }
        it { expect(subject.map(&:active_medicines).flatten).to include medicine_a }
        it { expect(subject.map(&:active_medicines).flatten).not_to include medicine_b }
      end

      context 'DosingTimeに他のCareReceiverのデータがあった場合' do
        let(:care_receiver) { create(:care_receiver) }
        let(:other_care_receiver) { create(:care_receiver) }
        let(:dosing_time) { create(:dosing_time, timeframe_id: 5, care_receiver_id: care_receiver.id) }
        let(:other_dosing_time) { create(:dosing_time, care_receiver_id: other_care_receiver.id) }
        let(:medicine_a) { create(:medicine) }
        let(:medicine_b) { create(:medicine) }

        before do
          create(:medicine_dosing_time, dosing_time_id: dosing_time.id, medicine_id: medicine_a.id)
          create(:medicine_dosing_time, dosing_time_id: other_dosing_time.id, medicine_id: medicine_b.id)
        end

        it { is_expected.to include dosing_time }
        it { is_expected.not_to include other_dosing_time }
        it { expect(subject.map(&:active_medicines).flatten).to include medicine_a }
        it { expect(subject.map(&:active_medicines).flatten).not_to include medicine_b }
      end
    end
  end
end
