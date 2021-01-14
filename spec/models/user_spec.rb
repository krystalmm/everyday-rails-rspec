require 'rails_helper'

RSpec.describe User, type: :model do

  # 有効なファクトリを持つこと
  it "has a valid factory" do
    expect(FactoryBot.build(:user)).to be_valid
  end

  # 姓、名、メール、パスワードがあれば有効な状態であること
  # it "is valid with a first name, last name, email, and password" do
  #   user = User.new(first_name: "Aaron", last_name: "Sumner", email: "tester@example.com", password: "dottle-nouveau-pavilion-tights-furze")
  #   expect(user).to be_valid
  # end

  # 名がなければ無効な状態であること
  # it "is invalid without a first name" do
  #   user = FactoryBot.build(:user, first_name: nil)
  #   user.valid?
  #   expect(user.errors[:first_name]).to include("can't be blank")
  # end
  it { is_expected.to validate_presence_of :first_name }

  # 姓がなければ無効な状態であること
  # it "is invalid without a last name" do
  #   user = FactoryBot.build(:user, last_name: nil)
  #   user.valid?
  #   expect(user.errors[:last_name]).to include("can't be blank")
  # end
  it { is_expected.to validate_presence_of :last_name }

  # メールアドレスがなければ無効な状態であること
  # it "is invalid without an email address" do
  #   user = FactoryBot.build(:user, email: nil)
  #   user.valid?
  #   expect(user.errors[:email]).to include("can't be blank")
  # end
  it { is_expected.to validate_presence_of :email }

  # 重複したメールアドレスなら無効な状態であること
  # it "is invalid with a duplicate email address" do
  #   FactoryBot.create(:user, email: "aaron@example.com")
  #   user = FactoryBot.build(:user, email: "aaron@example.com")
  #   user.valid?
  #   expect(user.errors[:email]).to include("has already been taken")
  # end
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  # ユーザーのフルネームを文字列として返すこと
  it "returns a user's full name as a string" do
    user = FactoryBot.build(:user, first_name: "john", last_name: "doe")
    expect(user.name).to eq "john doe"
  end

  # アカウントが作成された時にウェルカムメールを送信すること
  it "sends a welcome email on account creation" do
    allow(UserMailer).to receive_message_chain(:welcome_email, :deliver_later)
    user = FactoryBot.create(:user)
    expect(UserMailer).to have_received(:welcome_email).with(user)
  end

  # ジオコーディングを実行すること
  it "performs geocoding", vcr: true do
    user = FactoryBot.create(:user, last_sign_in_ip: "161.185.207.20")
    expect {
      user.geocode
    }.to change(user, :location).from(nil).to("New York City, New York, US")
  end
end
