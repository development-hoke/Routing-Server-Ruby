# encoding: utf-8
# ------------------------------
# 質問コントローラー
# ------------------------------
class Public::QuestionsController < Public::ApplicationController
  include JwtAuthenticator
  include RenderNotificationsResponse

  prepend_before_action -> {
    jwt_authenticate(request.headers['Authorization'])
  }

  # ------------------------------
  # [Q-1] 質問投稿
  # POST /questions
  # ------------------------------
  def create
    user = User.find_by!(id: question_params[:user_id])

    question = Question.new(
      question: question_params[:question],
      user_id: user.id,
      asked_at: Time.now,
    )

    if question.save
      render_success(:question, :create, question.id)
    else
      render_validation_error(question.errors.full_messages)
    end
  end

  # ------------------------------
  # [Q-2] よくある質問一覧取得
  # GET /questions/faq
  # ------------------------------
  def faq
    questions = Question.where(faq: true).limit(10)

    question_list = questions.map { |q|
      {
        question_id: q.id,
        question: q.question,
        answer: q.answer,
      }
    }

    render json: { question_list: question_list }
  end

  private

  # 質問投稿リクエストボディ
  def question_params
    params.permit(:user_id, :question)
  end
end
