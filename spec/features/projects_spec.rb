require 'rails_helper'

RSpec.feature "Projects", type: :feature do
  # ユーザーは新しいプロジェクトを作成する
  scenario "user creates a new project" do
    user = FactoryBot.create(:user)
    sign_in user
    # Deviseのヘルパーメソッドを使用してるので、root_pathを指定しないとエラーになる！！
    visit root_path

    expect {
      click_link "New Project"
      fill_in "project_name", with: "Test Project"
      fill_in "project_description", with: "Trying out Capybara"
      click_button "Create Project"

      expect(page).to have_content "Project was successfully created"
      expect(page).to have_content "Test Project"
      expect(page).to have_content "Owner: #{ user.name }"
    }.to change(user.projects, :count).by(1)
  end
end
