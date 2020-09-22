require 'rails_helper'

RSpec.describe DosingTime, type: :model do
  let(:care_receiver_a) { create(:care_receiver) }
  let(:care_receiver_b) { create(:care_receiver) }

  shared_examples '有効' do
    it { expect(dosing_time).to be_valid }
  end

  context 'time, timeframe, care_receiver_id がある場合' do
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
      let(:time) { Faker::Time.between(from: Time.now - 1, to: Time.now, format: :short) }

      before do
        create(:dosing_time, time: time, care_receiver_id: care_receiver_a.id)
      end

      context 'care_recever_id が同じ場合' do
        it '無効であること' do
          dosing_time = build(:dosing_time, time: time, care_receiver_id: care_receiver_a.id)
          dosing_time.valid?
          expect(dosing_time.errors[:time]).to include('has already been taken')
        end
      end

      context 'care_recever_id が違う場合' do
        let(:dosing_time) { build(:dosing_time, time: time, care_receiver_id: care_receiver_b.id) }
        it_behaves_like '有効'
      end
    end
  end

  describe 'column: timeframe' do
    context '空の場合' do
      it '無効であること' do
        dosing_time = build_stubbed(:dosing_time, timeframe: '')
        dosing_time.valid?
        expect(dosing_time.errors[:timeframe]).to include("can't be blank")
      end
    end

    context '重複する場合' do
      let(:timeframe) { '朝食後' }

      before do
        create(:dosing_time, timeframe: timeframe, care_receiver_id: care_receiver_a.id)
      end

      context 'care_recever_id が同じ場合' do
        it '無効であること' do
          dosing_time = build(:dosing_time, timeframe: timeframe, care_receiver_id: care_receiver_a.id)
          dosing_time.valid?
          expect(dosing_time.errors[:timeframe]).to include('has already been taken')
        end
      end

      context 'care_recever_id が違う場合' do
        let(:dosing_time) { build(:dosing_time, timeframe: timeframe, care_receiver_id: care_receiver_b.id) }
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
end
