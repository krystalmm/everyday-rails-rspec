module CreateProjects
  def create_project(user)
    visit root_path
    click_link "New Project"
    fill_in "project_name", with: "Test Project"
    fill_in "project_description", with: "Trying out Capybara"
    click_button "Create Project"
  end
end

RSpec.configure do |config|
  config.include CreateProjects
end