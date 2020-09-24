require 'rails_helper'

RSpec.describe Take, type: :model do
  shared_examples '有効' do
    it { expect(take).to be_valid }
  end

  context 'execute, dosing_timeframe, dosing_time, user_id, care_receiver_id に値がある場合' do
    let(:take) { build_stubbed(:take) }
    it_behaves_like '有効'
  end

  describe 'column: execute' do
    context 'trueの場合' do
      let(:take) { build_stubbed(:take, execute: true) }
      it_behaves_like '有効'
    end

    context 'falseの場合' do
      let(:take) { build_stubbed(:take, execute: false) }
      it_behaves_like '有効'
    end

    context 'nilの場合' do
      it '無効であること' do
        take = build_stubbed(:take, execute: nil)
        take.valid?
        expect(take.errors[:execute]).to include('is not included in the list')
      end
    end
  end

  describe 'column: dosing_timeframe' do
    context '空の場合' do
      it '無効であること' do
        take = build_stubbed(:take, dosing_timeframe: '')
        take.valid?
        expect(take.errors[:dosing_timeframe]).to include("can't be blank")
      end
    end
  end

  describe 'column: dosing_time' do
    context '空の場合' do
      it '無効であること' do
        take = build_stubbed(:take, dosing_time: '')
        take.valid?
        expect(take.errors[:dosing_time]).to include("can't be blank")
      end
    end
  end

  describe 'column: user_id' do
    context '空の場合' do
      it '無効であること' do
        take = build_stubbed(:take, user_id: '')
        take.valid?
        expect(take.errors[:user_id]).to include("can't be blank")
      end
    end
  end

  describe 'column: care_receiver_id' do
    context '空の場合' do
      it '無効であること' do
        take = build_stubbed(:take, care_receiver_id: '')
        take.valid?
        expect(take.errors[:care_receiver_id]).to include("can't be blank")
      end
    end
  end
end
