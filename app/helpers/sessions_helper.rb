module SessionsHelper
  
  # 引数に渡されたユーザーオブジェクトでログインします。6.3.1
  # user.id を 一時的セッションに記憶するメソッド
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # 引数に渡されたユーザーオブジェクトでログインします。6.3.1
  # def log_in(user)
  #   session[:user_id] = user.id  # sessionはハッシュ
  #   # ↑ のsession[:user_id] は下記のようなハッシュにuser.idを代入するイメージ 
  #   # session = {user_id: 1, age: 29} 
  #   # ruby の基礎 ハッシュ編参考
  #   # ⓶  session_cont create アクションのuserから渡された引数(user)を受け取り、session[:user_idに代入]
  #   #     session(ブラウザの一時保存先(cookie))
  # end
  
  # 永続的セッションを記憶します（Userモデルを参照）
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # 永続的セッションを破棄します remember me
  def forget(user)
    user.forget # Userモデル参照
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  # セッションと@current_userを破棄します 6.6
  def log_out
    forget(current_user) # remember me
    session.delete(:user_id)
    @current_user = nil
  end

  # 一時的セッションにいるユーザーを返します。6.3.2
  # それ以外の場合はcookiesに対応するユーザーを返します。
  # remember_me でややこしくなっている ※下記ｺﾒﾝﾄｱｳﾄ＝元のやつ →分かりやすい!!
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  
  # 現在ログイン中のユーザーがいる場合オブジェクトを返します。
  # def current_user
  #   if session[:user_id]
  #     @current_user ||= User.find_by(id: session[:user_id])
  #   end
  # end
  
  #  def current_user 6.3.2
  #    if session[:user_id] # cookieにidがあれば(ログインしてれば)
  #      if @current_user.nil? 
  #        @current_user = User.find_by(id: session[:user_id]) # cookieのid で Usersテーブル(DB)のレコードを取得
  #          find だとエラーが出る場合がある 6.3.2
  #      else
  #        @current_user
  #      end
  #    end
  #  end
  
  # 渡されたユーザーがログイン済みのユーザーであればtrueを返します。8.2.2
  def current_user?(user)
    user == current_user
  end  
  
  # 現在ログイン中のユーザーがいればtrue、そうでなければfalseを返します。
  def logged_in?
    !current_user.nil?
  end
  
  # 記憶しているURL(またはデフォルトURL)にリダイレクトします。 ﾌﾚﾝﾄﾞﾘｰﾌｫﾜｰﾃﾞｨﾝｸﾞ
  def redirect_back_or(default_url)
    redirect_to(session[:forwarding_url] || default_url)
    session.delete(:forwarding_url)
  end

  # アクセスしようとしたURLを記憶します。 ﾌﾚﾝﾄﾞﾘｰﾌｫﾜｰﾃﾞｨﾝｸ
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
