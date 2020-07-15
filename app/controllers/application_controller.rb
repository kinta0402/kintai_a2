class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper # 親contに定義先を記載する事で、どのcontでも定義したメソッドが使える 6.3
                         # SessionHelperに定義したメソッドは、users_cont等、sessions_cont以外でも使用出来る
                         # ↑参考6.6 log_outメソッドをusers_contのdestroyアクションで使用している!!

  $days_of_the_week = %w{日 月 火 水 木 金 土} # 10.2 ｸﾞﾛｰﾊﾞﾙ変数を使用

  # beforフィルター

  # paramsハッシュからユーザーを取得します。
  
  def set_user
    @user = User.find(params[:id])
  end

  # ログイン済みのユーザーか確認します。
  def logged_in_user
    unless logged_in?
      store_location # ﾌﾚﾝﾄﾞﾘｰﾌｫﾜｰﾃﾞｨﾝｸﾞ
      flash[:danger] = "ログインしてください。"
      redirect_to login_url
    end
  end
  
  # アクセスしたユーザーが現在ログインしているユーザーか確認します。
  def correct_user
    # @user = User.find(params[:id])
    # redirect_to(root_url) unless @user == current_user ↓へ 8.2.2
    redirect_to(root_url) unless current_user?(@user)
  end
  
  # システム管理権限所有かどうか判定します。
  def admin_user
    redirect_to root_url unless current_user.admin?
  end
  
  # ページ出力前に1ヶ月分のデータの存在を確認・セットします。10.3
  def set_one_month 
    # @first_day = Date.current.beginning_of_month 10.4により下記へ
    @first_day = params[:date].nil? ? # URL記載の日時を取得 ← ひらめいた!! 三項演算子を使用
    Date.current.beginning_of_month : params[:date].to_date
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day] # 対象の月の日数を代入します。
    # ユーザーに紐付く一ヶ月分のレコードを検索し取得します。
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    unless one_month.count == @attendances.count # それぞれの件数（日数）が一致するか評価します。
      ActiveRecord::Base.transaction do # トランザクションを開始します。
        # 繰り返し処理により、1ヶ月分の勤怠データを生成します。
        one_month.each { |day| @user.attendances.create!(worked_on: day) }
      end
      @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    end
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "ページ情報の取得に失敗しました、再アクセスしてください。"
    redirect_to root_url
  end
end
