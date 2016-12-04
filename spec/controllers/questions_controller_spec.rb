require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  let!(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all questions' do 
      expect(assigns(:questions)).to match_array(Question.all)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end

  end

  describe 'GET #show' do 
    before { get :show, params: {id: question} }

    it 'assigns the requested question to @question' do 
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do 
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user #modul ControllerMacros

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user #modul ControllerMacros
    before { get :edit, params: {id: question} }

    it 'assigns the requested question to @question' do 
      expect(assigns(:question)).to eq question
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end

  end

  describe 'POST #create' do 
    sign_in_user #modul ControllerMacros
    context 'with valid attributes' do
      it 'save the new question in the database' do 
        expect { post :create, params: {question: attributes_for(:question)} }.to change(Question, :count).by(1)
      end

      it 'associates current user with question' do
        post :create, params: {question: attributes_for(:question)}
        expect(assigns(:question).user_id).to eq @user.id
      end

      it 'redirect to create view' do 
        post :create, params: {question: attributes_for(:question)}

        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do 
      it 'does not save the question' do 
        expect { post :create, params: {question: attributes_for(:invalid_question)} }.to_not change(Question, :count)
      end

      it 're-render new view' do
        post :create, params: {question: attributes_for(:invalid_question)}
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do 
    sign_in_user #modul ControllerMacros
    context 'valid attributes' do
      it 'assigns the requested question to @question' do 
        patch :update, params: {id: question, question: attributes_for(:question)}
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: {id: question, question: {title: 'new title', body: 'new body'}}
        question.reload
        expect(question.title).to eq 'new title'        
        expect(question.body).to eq 'new body'
      end

      it 'redirects to the updates question' do
        patch :update, params: {id: question, question: attributes_for(:question)}
        expect(response).to redirect_to question
      end
    end

    context 'invalid attributes' do
      before { patch :update, params: {id: question, question: {title: 'new title', body: nil }} }

      it 'does not change question attributes' do
        question.reload
        expect(question.title).to eq question.title        
        expect(question.body).to eq question.body        
      end

      it 're-render edit view' do
        expect(response).to render_template :edit
      end

    end
  end

  describe 'DELETE #destroy' do
    let(:delete_action) { delete :destroy, params: {id: question} }
    before { question }
    
    context 'delete author' do
      before { sign_in question.user }
      
      it 'delete question' do
        expect { delete_action }.to change(Question, :count).by(-1)
      end

      it 'redirect to questions' do
        delete_action
        expect(response).to redirect_to questions_path
      end
    end
    
    context 'delete not author' do
      sign_in_user
      it 'does not delete question' do
        expect { delete_action }.not_to change(Question, :count)
      end
    end
  end
end
