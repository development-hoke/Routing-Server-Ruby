# encoding: utf-8
# ------------------------------
# モデルへのアクセス時点以外でバリデーションを行うためのモジュール
# @author kotatanaka
# ------------------------------
module ValidateOnController
  extend ActiveSupport::Concern

  # ------------------------------
  # 1DIDのバリデーション
  # ------------------------------
  def validate_1did(onedate_id, required)
    results = Array.new

    if required && onedate_id.nil?
      results.push("1DIDは必須です")
    elsif !required && onedate_id.nil?
      return results
    else
      unless onedate_id =~ /\A[a-zA-Z0-9]+\z/
        results.push("1DIDは半角英数を入力してください")
      end
      unless onedate_id.length.between?(6, 20)
        results.push("1DIDは6文字以上20文字以下です")
      end
    end

    return results
  end

  # ------------------------------
  # メールアドレスのバリデーション
  # ------------------------------
  def validate_email(mail_address, required)
    results = Array.new

    if required && mail_address.nil?
      results.push("Mail Addressは必須です")
    elsif !required && mail_address.nil?
      return results
    else
      unless mail_address =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
        results.push("Mail Addressはメールアドレスを入力してください")
      end
    end

    return results
  end

  # ------------------------------
  # パスワードのバリデーション
  # ------------------------------
  def validate_password(password)
    results = Array.new

    if password.nil?
      results.push("Passwordは必須です")
    else
      unless password =~ /\A[a-zA-Z0-9]+\z/
        results.push("Passwordは半角英数を入力してください")
      end
      unless password.length.between?(6, 20)
        results.push("Passwordは6文字以上20文字以下です")
      end
    end

    return results
  end

  # ------------------------------
  # Spot登録パラメータのバリデーション
  # ------------------------------
  def validate_spots_params(spot_params_list)
    results = Array.new

    if plan_params[:spots].blank?
      results.push("Spotsは必須です")
      return results
    end

    spot_params_list.each do |spot_params|
      # spot_id があればその他項目不要のためスルー
      if spot_params[:spot_id].present?
        next
      end

      # spot_name
      if spot_params[:spot_name].nil?
        message = "SpotsのSpot Nameは必須です"
        next if results.include?(message)
        results.push(message)
      else
        unless spot_params[:spot_name].length.between?(1, 100)
          message = "SpotsのSpot Nameは1文字以上100文字以下です"
          next if results.include?(message)
          results.push(message)
        end
      end

      # latitude
      if spot_params[:latitude].nil?
        message = "SpotsのLatitudeは必須です"
        next if results.include?(message)
        results.push(message)
      else
        unless spot_params[:latitude].to_s =~ /^[0-9]+\.[0-9]+$/
          message = "SpotsのLatitudeは少数点数を入力してください"
          next if results.include?(message)
          results.push(message)
        end
      end

      # longitude
      if spot_params[:longitude].nil?
        message = "SpotsのLongitudeは必須です"
        next if results.include?(message)
        results.push(message)
      else
        unless spot_params[:longitude].to_s =~ /^[0-9]+\.[0-9]+$/
          message = "SpotsのLongitudeは少数点数を入力してください"
          next if results.include?(message)
          results.push(message)
        end
      end

      # order
      if spot_params[:order].nil?
        message = "SpotsのOrderは必須です"
        next if results.include?(message)
        results.push(message)
      else
        unless spot_params[:order].to_s =~ /^[0-9]+$/
          message = "SpotsのOrderは整数を入力してください"
          next if results.include?(message)
          results.push(message)
        end
      end

      # need_time
      if spot_params[:need_time].nil?
        message = "SpotsのNeed Timeは必須です"
        next if results.include?(message)
        results.push(message)
      else
        unless spot_params[:need_time].to_s =~ /^[0-9]+$/
          message = "SpotsのNeed Timeは整数を入力してください"
          next if results.include?(message)
          results.push(message)
        end
      end
    end

    return results
  end

  # ------------------------------
  # 回答のバリデーション
  # ------------------------------
  def validate_answer(answer)
    results = Array.new

    if answer.nil?
      results.push("Answerは必須です")
    else
      unless answer.length.between?(1, 500)
        results.push("Answerは1文字以上500文字以下です")
      end
    end

    return results
  end
end
