require 'rails_helper'

RSpec.feature "Projects", type: :feature do
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
end
