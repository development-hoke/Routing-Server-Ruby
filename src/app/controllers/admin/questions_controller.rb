# encoding: utf-8
# ------------------------------
# [管理用] 質問コントローラー
# ------------------------------
class Admin::QuestionsController < Admin::ApplicationController
  include ValidateOnController
  include RenderNotificationsResponse

  # ------------------------------
  # [AD-2] 質問回答登録
  # PUT /admin/questions/:id
  # ------------------------------
  def update
    question = Question.find_by!(id: params[:id])

    # 回答のバリデーション
    results_validate_answer = validate_answer(answer_params[:answer])
    unless results_validate_answer.empty?
      render_validation_error(results_validate_answer) and return
    end

    question.answer = answer_params[:answer]
    question.resolved = true
    question.answered_at = Time.now

    if question.save
      render status: 200, json: {
        code: 200,
        message: "質問に回答を登録しました",
        id: question.id,
      }
    else
      render_validation_error(question.errors.full_messages)
    end
  end

  # ------------------------------
  # [AD-3] よくある質問に登録
  # PUT /admin/questions/:question_id/faq
  # ------------------------------
  def faq
    question = Question.find_by!(id: params[:question_id])

    unless question.resolved
      render_validation_error(Array.new.push("未解決の質問です")) and return
    end

    question.faq = true

    if question.save
      render status: 200, json: {
        code: 200,
        message: "よくある質問に登録しました",
        id: question.id,
      }
    else
      render_validation_error(question.errors.full_messages)
    end
  end

  private

  # 質問回答登録リクエストボディ
  def answer_params
    params.permit(:answer)
  end
end
