# encoding: utf-8
# ------------------------------
# ユーザーコントローラー
# ------------------------------
class Public::UsersController < Public::ApplicationController
  include JwtAuthenticator
  include ValidateOnController
  include RenderUsersResponse
  include ActionView::Helpers::NumberHelper

  BASE_DIRECTORY = ENV["BASE_DIRECTORY"] || "."

  before_action :set_base_url
  prepend_before_action -> {
                          jwt_authenticate(request.headers["Authorization"])
                        }, except: [:create, :login]

  # ------------------------------
  # [U-1] ユーザー登録
  # POST /users
  # ------------------------------
  def create
    user = User.new(
      name: user_create_params[:name],
      sex: user_create_params[:sex],
      age: user_create_params[:age],
      area: user_create_params[:area],
      mail_address: user_create_params[:mail_address],
      password: user_create_params[:password],
      onedate_id: user_create_params[:onedate_id],
      user_attr: "ordinary",
      status: "public",
      login_num: 0,
    )

    # メールアドレスのバリデーション
    results_validate_mail = validate_email(user_update_params[:mail_address], required = true)
    unless results_validate_mail.empty?
      render_validation_error(results_validate_mail) and return
    end

    # パスワードのバリデーション
    results_validate_password = validate_password(user_create_params[:password])
    unless results_validate_password.empty?
      render_validation_error(results_validate_password) and return
    end

    # メールアドレスの重複チェック
    if User.find_by(mail_address: user_create_params[:mail_address]).present?
      render_validation_error(Array.new.push("Mail Addressは既に使用されています")) and return
    end

    # 1DIDの重複チェック
    if user_create_params[:onedate_id].present? && User.find_by(onedate_id: user_create_params[:onedate_id]).present?
      render_validation_error(Array.new.push("OnedateIDは既に使用されています")) and return
    end

    if user.save
      # ユーザー設定データをデフォルト値で作成
      Setting.create(user_id: user.id)
      # JWTトークンをユーザーIDから生成、レスポンスヘッダーに格納し、返却
      jwt_token = encode(user.id)
      response.headers["X-Authentication-Token"] = jwt_token
      # render_success(:user, :create, user.id)
      render_signup_user(user)
    else
      render_validation_error(user.errors.full_messages)
    end
  end

  # ------------------------------
  # [U-2] ユーザー情報取得
  # GET /users/:id
  # ------------------------------
  def show
    # IDが無ければ、JWTからIDを取得
    if params[:id].present?
      user = User.find_by!(id: params[:id])
    else
      user = User.find_by!(id: @current_user.id)
    end

    if user.status == "canceled"
      render_validation_error(Array.new.push("退会したユーザーです")) and return
    end

    counts = {
      plan_count: Plan.where(user_id: user.id).count,
      favored_plan_count: Favorite.where(user_id: user.id).count,
      follow_count: Follow.where(user_id: user.id).count,
      follower_count: Follow.where(follow_user_id: user.id).count,
    }

    # 自分が対象ユーザーをフォローしているか
    is_follow = Follow.find_by(user_id: @current_user.id, follow_user_id: user.id).present?

    render_user_detail(user, counts, is_follow)
  end

  # ------------------------------
  # [U-3] プロフィール編集
  # PUT /users
  # ------------------------------
  def update
    user = User.find_by!(id: @current_user.id)

    if user.status == "canceled"
      render_validation_error(Array.new.push("退会したユーザーです")) and return
    end

    # メールアドレスの重複チェック
    if User.where(mail_address: user_update_params[:mail_address]).where.not(id: @current_user.id).present?
      render_validation_error(Array.new.push("Mail Addressは既に使用されています")) and return
    end

    # メールアドレスのバリデーション
    results_validate_mail = validate_email(user_update_params[:mail_address], required = true)
    unless results_validate_mail.empty?
      render_validation_error(results_validate_mail) and return
    end

    # 1DIDの重複チェック
    if User.where(onedate_id: user_update_params[:onedate_id]).where.not(id: @current_user.id).present?
      render_validation_error(Array.new.push("OnedateIDは既に使用されています")) and return
    end

    if user.update(user_update_params)
      render_success(:user, :update, user.id)
    else
      render_validation_error(user.errors.full_messages)
    end
  end

  # ------------------------------
  # [U-4] ユーザー退会
  # DELETE /users/:id
  # ------------------------------
  def destroy
    user = User.find_by!(id: @current_user.id)

    if user.status == "canceled"
      render_validation_error(Array.new.push("既に退会済みです")) and return
    end

    user.name = ""
    user.onedate_id = nil
    user.profile = nil
    user.address = nil
    user.mail_address = ""
    user.status = "canceled"
    user.password_digest = ""

    if user.save(validate: false)
      render_success(:user, "退会", user.id)
    else
      render_validation_error(user.errors.full_messages)
    end
  end

  # ------------------------------
  # [U-5] パスワード変更
  # PUT /users/:id/password
  # ------------------------------
  def update_password
    user = User.find_by!(id: @current_user.id)

    if user.status == "canceled"
      render_validation_error(Array.new.push("退会したユーザーです")) and return
    end

    if params[:id] != @current_user.id
      render_validation_error(Array.new.push("他者の画像は変更できません")) and return
    end

    # 古いパスワードが正しいかのチェック
    unless user.authenticate(params[:old_password])
      render_validation_error(Array.new.push("Old Passwordが間違っています")) and return
    end

    # パスワードのバリデーション
    results_validate_password = validate_password(params[:new_password])
    unless results_validate_password.empty?
      render_validation_error(results_validate_password) and return
    end

    user.password_digest = BCrypt::Password.create(params[:new_password])

    if user.save
      # JWTトークンをユーザーIDから生成、レスポンスヘッダーに格納し、返却
      jwt_token = encode(user.id)
      response.headers["X-Authentication-Token"] = jwt_token
      render_success(:user, :update, user.id)
    else
      render_validation_error(user.errors.full_messages)
    end
  end

  # ------------------------------
  # [U-6] 1DID更新
  # PUT /users/:id/1did
  # ------------------------------
  def update_1did
    user = User.find_by!(id: @current_user.id)

    if user.status == "canceled"
      render_validation_error(Array.new.push("退会したユーザーです")) and return
    end

    # 1DIDのバリデーション
    results_validate_1did = validate_1did(params[:"1did"], true)
    unless results_validate_1did.empty?
      render_validation_error(results_validate_1did) and return
    end

    # 1DIDの重複チェック
    if User.find_by(onedate_id: params[:"1did"]).present?
      render_validation_error(Array.new.push("1DIDは既に使用されています")) and return
    end

    user.onedate_id = params[:"1did"]

    if user.save
      render_success(:user, :update, user.id)
    else
      render_validation_error(user.errors.full_messages)
    end
  end

  # ------------------------------
  # [U-7] アプリにログイン
  # POST /users/login
  # ------------------------------
  def login
    results_validation = Array.new
    results_validation.concat(validate_email(params[:mail_address], false))
    results_validation.concat(validate_1did(params[:"1did"], false))
    results_validation.concat(validate_password(params[:password]))

    if (params[:mail_address] && params[:"1did"]) || (!params[:mail_address] && !params[:"1did"])
      results_validation.push("Mail Addressと1DIDはどちらか一方必須です")
    end

    unless results_validation.empty?
      render_validation_error(results_validation) and return
    end

    if (params[:mail_address].present?)
      user = User.find_by!(mail_address: params[:mail_address])

      if user.status == "canceled"
        render_validation_error(Array.new.push("退会したユーザーです")) and return
      end

      if user.authenticate(params[:password])
        jwt_token = encode(user.id)
        response.headers["X-Authentication-Token"] = jwt_token
        log = Log.create!(user_id: user.id)
        user.login_num = user.login_num + 1
        user.updated_at = Time.now
        if user.save
          render_login_user(user)
        else
          render_validation_error(user.errors.full_messages)
        end
      else
        render_validation_error(Array.new.push("Passwordが間違っています"))
      end
    end

    if (params[:"1did"].present?)
      user = User.find_by!(onedate_id: params[:"1did"])
      if user.authenticate(params[:password])
        jwt_token = encode(user.id)
        response.headers["X-Authentication-Token"] = jwt_token
        log = Log.create!(user_id: user.id)
        user.login_num = user.login_num + 1
        user.updated_at = Time.now
        if user.save
          render_login_user(user)
        else
          render_validation_error(user.errors.full_messages)
        end
      else
        render_validation_error(Array.new.push("Passwordが間違っています"))
      end
    end
  end

  # ------------------------------
  # [U-8] ユーザー公開・非公開
  # PUT /users/:id/status
  # ------------------------------
  def update_status
    user = User.find_by!(id: @current_user.id)

    if user.status == "canceled"
      render_validation_error(Array.new.push("退会したユーザーです")) and return
    end

    # ユーザーステータスのバリデーション
    new_status = params[:status]
    if new_status.nil?
      render_validation_error(Array.new.push("Statusは必須です")) and return
    end
    unless new_status == "public" || new_status == "private"
      render_validation_error(Array.new.push("Statusはpublic/privateを入力してください")) and return
    end
    if user.status == new_status
      render_validation_error(Array.new.push("Statusは既に" + new_status + "です")) and return
    end

    user.status = new_status

    if user.save
      render_success(:user, :update, user.id)
    else
      render_validation_error(user.errors.full_messages)
    end
  end

  # ------------------------------
  # [U-9] プロフィール画像アップロードAPI
  # POST /users/:user_id/profimage
  # TODO インフラ対応・リファクタ
  # ------------------------------
  def upload_profimage
    user = User.find_by!(id: @current_user.id)

    if params[:file].nil?
      render_validation_error(Array.new.push("Fileは必須です")) and return
    end

    file_val = params[:file]
    con_type = file_val.content_type

    if !con_type.include? "image"
      render_validation_error(Array.new.push("Image は画像ファイルを指定してください")) and return
    end

    uploader = ImageUploader.new
    uploader.set_user_id(@current_user.id)
    uploader.store!(file_val)
    image_url = root_url.chop + uploader.url

    if !image_url
      render_validation_error(Array.new.push("予期せぬエラーが発生しました")) and return
    end

    user.update!(
      image_url: image_url,
    )

    render_success(:user, :update, params[:user_id])
  end

  # ------------------------------
  # [U-10] プロフィール画像ダウンロードAPI
  # GET /users/:user_id/profimage
  # TODO インフラ対応・リファクタ
  # ------------------------------
  def show_profimage
    if params[:user_id].present?
      userImage = User.select(:image_url, :id).where(id: params[:user_id]).limit(1)
    else
      userImage = User.select(:image_url, :id).where(id: @current_user.id).limit(1)
    end

    if userImage[0][:image_url].nil?
      render_validation_error(Array.new.push("プロフィール画像が登録されていません")) and return
    end

    render json: {
      image_url: userImage[0][:image_url],
    }
  end

  # ------------------------------
  # [U-10] プロフィール画像ダウンロードAPI
  # GET 使用なし
  # TODO インフラ対応・リファクタ
  # ------------------------------
  def download_profimage
    if params[:user_id].present?
      profimageFile = User.select(:image_url, :id).where(id: params[:user_id]).limit(1)
    else
      profimageFile = User.select(:image_url, :id).where(id: @current_user.id).limit(1)
    end

    if profimageFile[0][:image_url].nil?
      render_validation_error(Array.new.push("プロフィール画像が登録されていません")) and return
    end

    send_file profimageFile[0][:image_url], :type => "image/png", :x_sendfile => true
  end

  private

  # ユーザー登録リクエストパラメータ
  def user_create_params
    params.permit(:name, :sex, :age, :area, :mail_address, :onedate_id, :password)
  end

  # プロフィール編集リクエストパラメータ
  def user_update_params
    params.permit(:name, :profile, :sex, :age, :area, :address, :mail_address, :onedate_id)
  end

  # 画像 登録/編集 リクエストパラメータ
  def user_image_params
    params.permit(:image_url)
  end

  def safe_expand_path(path)
    current_directory = File.expand_path(BASE_DIRECTORY)
    tested_path = File.expand_path(path, BASE_DIRECTORY)

    unless tested_path.starts_with?(current_directory)
      raise ArgumentError, "Should not be parent of root"
    end

    tested_path
  end

  def check_path_exist(path)
    @absolute_path = safe_expand_path(path)
    @relative_path = path
    raise ActionController::RoutingError, "Not Found" unless File.exists?(@absolute_path)
    @absolute_path
  end

  def set_base_url
    @base_url = ENV["BASE_URL"] || "."
  end
end
