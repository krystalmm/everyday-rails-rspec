require 'rails_helper'

RSpec.describe Project, type: :model do

  before do
    @user = User.create(first_name: "joe", last_name: "tester", email: "joetester@example.com", password: "dottle-nouveau-pavilion-tights-furze")
  end

  # プロジェクト名があれば有効な状態であること
  it "is valid with a project name" do
    project = @user.projects.create(name: "Test Project")
    expect(project).to be_valid
  end

  # プロジェクト名がなければ無効な状態であること
  it "is invalid without a project name" do
    project = @user.projects.create(name: nil)
    expect(project.errors[:name]).to include("can't be blank") 
  end

  # ユーザー単位では重複したプロジェクト名を許可しないこと
  it "does not allow duplicate project names per user" do
    @user.projects.create(name: "Test Project")
    new_project = @user.projects.build(name: "Test Project")
    new_project.valid?
    expect(new_project.errors[:name]).to include("has already been taken")
  end 

  # 二人のユーザーが同じ名前を使うことは許可すること
  it "allows two users to share a project name" do
    @user.projects.create(name: "Test Project")
    other_user = User.create(first_name: "jane", last_name: "tester", email: "janetester@example.com", password: "dottle-nouveau-pavilion-tights-furze")
    other_project = other_user.projects.build(name: "Test Project")
    expect(other_project).to be_valid
  end

  describe "late status" do
    
    # 締切日が過ぎていれば遅延していること
    it "is late when the due date is past today" do
      project = FactoryBot.create(:project, :due_yesterday)
      expect(project).to be_late
    end

    # 締切日が今日ならスケジュール通りであること
    it "is on time when the due date is today" do
      project = FactoryBot.create(:project, :due_today)
      expect(project).to_not be_late
    end

    # 締切日が未来ならスケジュール通りであること
    it "is on time when the due date is in the future" do
      project = FactoryBot.create(:project, :due_tomorrow)
      expect(project).to_not be_late
    end
  end
end


