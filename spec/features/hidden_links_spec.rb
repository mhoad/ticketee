require 'rails_helper'

RSpec.feature 'Users can only see the appropriate links' do
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:user, :admin) }
  let(:project) { FactoryGirl.create(:project) }

  context 'anonymous users' do
    scenario 'cannot see the new project link' do
      visit '/'
      expect(page).not_to have_link 'New Project'
    end

    scenario 'cannot see the delete project link' do
      visit project_path(project)
      expect(page).not_to have_link 'Delete Project'
    end
  end

  context 'regular users' do
    before do
      login_as(user)
    end

    scenario 'cannot see the new project link' do
      visit '/'
      expect(page).not_to have_link 'New Project'
    end

    scenario 'cannot see the delete project link' do
      visit project_path(project)
      expect(page).not_to have_link 'Delete Project'
    end
  end

  context 'admin users' do
    before do
      login_as(admin)
    end

    scenario 'can see the new project link' do
      visit '/'
      expect(page).to have_link 'New Project'
    end

    scenario 'cannot see the delete project link' do
      visit project_path(project)
      expect(page).to have_link 'Delete Project'
    end
  end
end