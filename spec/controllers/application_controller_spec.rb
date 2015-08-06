# encoding : utf-8
require 'rails_helper'

describe ApplicationController do

  describe '#current_user' do
    context 'when invalid parameters' do
      context 'and session is nil' do
        it "returns nil, empty session" do
          session.delete(:user_id)
          expect(controller.current_user.nil?).to be_truthy
          expect(session[:user_id].nil?).to be_truthy
        end
      end
      context "and user doesn't exist" do
        it "returns nil, empty session" do
          email    = 'john_smith@gmail.net'; password = "123456"
          user     = User.create( email: email, password: password )
          session[:user_id] = 9999
          expect(controller.current_user.nil?).to be_truthy
          expect(session[:user_id].nil?).to be_truthy
        end
      end
    end
    context 'when valid parameters' do
      context 'and session is filled' do
        before do
          email    = 'john_smith@gmail.net'; password = "123456"
          @user    = User.create( email: email, password: password )
          session[:user_id] = @user.id
          @result  = controller.current_user
        end
        it "returns User instance" do
          expect(@result).to be_kind_of(User)
        end
        it "returns current user with correct attributes" do
          expect(@result.id).to eq @user.id
        end
      end
    end
  end

end
