require 'rails_helper'

RSpec.describe Admin::ApplicationController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:admin_user) { FactoryGirl.create(:user, :admin) }

  context 'Non-admin users' do
    before do
      allow(controller).to receive(:authenticate_user!)
      allow(controller).to receive(:current_user).and_return(user)
    end

    it 'are not able to access the index action' do
      get :index

      expect(response).to redirect_to '/'
      expect(flash[:alert]).to eq 'You must be an admin to do that.'
    end
  end

  context 'Non signed-in user' do
    it 'are not able to access the index action' do
      get :index

      expect(response).to redirect_to '/users/sign_in'
    end
  end

  context 'Admin user' do
    before do
      allow(controller).to receive(:authenticate_user!)
      allow(controller).to receive(:current_user).and_return(admin_user)
    end

    it 'are not able to access the index action' do
      get :index

      expect(response.status).to eq 200
    end
  end
end
