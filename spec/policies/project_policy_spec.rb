require 'rails_helper'

RSpec.describe ProjectPolicy do

  let(:user) { FactoryGirl.create(:user) }

  subject { described_class }

  permissions '.scope' do
  end

  context 'policy_scope' do
    subject { Pundit.policy_scope(user, Project) }

    let!(:project) { FactoryGirl.create(:project) }
    let(:user) { FactoryGirl.create(:user) }

    it 'is empty for anonymous users' do
      expect(Pundit.policy_scope(nil, Project)).to be_empty
    end

    it 'includes projects a user is allowed to view' do
      assign_role!(user, :viewer, project)
      expect(subject).to include(project)
    end

    it 'doesnt include projects a user is now allowed to view' do
      expect(subject).to be_empty
    end

    it 'retuns all projects for an admin' do
      user.admin = true
      expect(subject).to include(project)
    end
  end

  permissions :show? do
    let(:project) { FactoryGirl.create(:project) }

    it 'blocks anonymous users' do
      expect(subject).not_to permit(nil, project)
    end

    it 'allows viewers of the project' do
      assign_role!(user, :viewer, project)
      expect(subject).to permit(user, project)
    end

    it 'allows editors of the project' do
      assign_role!(user, :editor, project)
      expect(subject).to permit(user, project)
    end

    it 'allows managers of the project' do
      assign_role!(user, :manager, project)
      expect(subject).to permit(user, project)
    end

    it 'allows administrators' do
      admin = FactoryGirl.create(:user, :admin)
      expect(subject).to permit(admin, project)
    end

    it 'doesnt allow users assigned to other projects' do
      other_project = FactoryGirl.create(:project)
      assign_role!(user, :manager, other_project)
      expect(subject).not_to permit(user, project)
    end
  end

  permissions :create? do
  end

  permissions :update? do
  end

  permissions :destroy? do
  end
end
