require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project, name: "RSpec tutorial", owner: user) }
  let!(:task) { project.tasks.create!(name: "Finish RSpec tutorial") }

  # ユーザーがタスクの状態を切り替える
  scenario "user toggles a task", js: true do
    sign_in user
    go_to_project "RSpec tutorial"
    
    complete_task "Finish RSpec tutorial"
    expect_complete_task "Finish RSpec tutorial"

    undo_complete_task "Finish RSpec tutorial"
    expect_incomplete_task "Finish RSpec tutorial"
  end

  def go_to_project(name)
    visit root_path
    click_link name
  end

  def complete_task(name)
    check name
  end

  def undo_complete_task(name)
    uncheck name
  end

  def expect_complete_task(name)
    aggregate_failures do
      expect(page).to have_css "label.completed", text: name
      expect(task.reload).to be_completed
    end
  end

  def expect_incomplete_task(name)
    aggregate_failures do
      expect(page).to_not have_css "label.completed", text: name
      expect(task.reload).to_not be_completed
    end
  end


  # 新しいタスクを作成できること
  scenario "user creates a new task" do
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project, name: "RSpec tutorial", owner: user)

    visit root_path
    click_link "Sign in"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"

    click_link "RSpec tutorial"

    expect {
      click_link "Add Task"
      fill_in "task_name", with: "task"
      click_button "Create Task"

      expect(page).to have_content "Task was successfully created."
      expect(page).to have_content "task"
    }.to change(project.tasks, :count).by(1)
  end
end
