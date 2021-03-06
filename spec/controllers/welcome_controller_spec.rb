# frozen_string_literal: true

require 'spec_helper'

describe ::WelcomeController do
  describe 'GET index' do
    it 'renders index' do
      get :index

      expect(response).to render_template(:index)
    end
  end
end
