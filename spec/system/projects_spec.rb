require 'rails_helper'

RSpec.describe "Projects", type: :system do
  let(:user) { FactoryBot.create(:user) }

  # ユーザーは新しいプロジェクトを作成する
  scenario "user creates a new project" do
    sign_in user
    # Deviseのヘルパーメソッドを使用してるので、root_pathを指定しないとエラーになる！！
    
    expect {
      create_project(user)
    }.to change(user.projects, :count).by(1)

    aggregate_failures do
      expect(page).to have_content "Project was successfully created"
      expect(page).to have_content "Test Project"
      expect(page).to have_content "Owner: #{ user.name }"
    end
  end

  # プロジェクトを編集する
  scenario "user updates a project" do

    sign_in user
    create_project(user)

    expect {
      visit root_path
      click_link "Test Project"
      click_link "Edit"
      fill_in "project_name", with: "update Test Project"
      fill_in "project_description", with: "updated"
      click_button "Update Project"
    }.to_not change(user.projects, :count)

    aggregate_failures do
      expect(page).to have_content "Project was successfully updated."
      expect(page).to have_content "update Test Project"
      expect(page).to have_content "Owner: #{ user.name }"
    end
  end

  # ユーザーはプロジェクトを完了済みにする
  scenario "user completes a project" do
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project, owner: user)
    
    login_as user

    visit project_path(project)
    click_button "Complete"
    
    expect(project.reload.completed?).to be true
    expect(page).to have_content "Congratulations, this project is complete!"
    expect(page).to have_content "Completed"
    expect(page).to_not have_button "Complete"
  end
end
