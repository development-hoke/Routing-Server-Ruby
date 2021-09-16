# encoding: utf-8
# ------------------------------
# 基底コントローラー
# ------------------------------
class ApplicationController < ActionController::API
  include ErrorHandler
  include RenderCommonResponse

  def index
    render json: {
      message: "Hello, 1Date Planner!",
    }
  end
end
