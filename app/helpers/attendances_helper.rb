module AttendancesHelper

  def attendance_state(attendance) # 10.6.1
    # 受け取ったAttendanceオブジェクトが当日と一致するか評価します。
    if Date.current == attendance.worked_on
      return '出勤' if attendance.started_at.nil?
      return '退勤' if attendance.started_at.present? && attendance.finished_at.nil?
    end
    # どれにも当てはまらなかった場合はfalseを返します。(出勤ボタンも退勤ボタンも登録済みの場合等)
    false
  end
  
  # 出勤時間と退勤時間を受け取り、在社時間を計算して返します。 10.8
  # attendanceヘルパーで定義したメソッドを、users/show.html にて使用している → 可能なのか？
  # モデルを関連付けしている為可能？
  def working_times(start, finish)
    format("%.2f", (((finish - start) / 60) / 60.0))
  end
  
     # 不正な値があるか確認する 旧勤怠_10章_不正な値があるか確認する項参照
  def attendances_invalid?
    attendances = true
    attendances_params.each do |id, item|
      if item[:started_at].blank? && item[:finished_at].blank?
        next
      elsif item[:started_at].blank? || item[:finished_at].blank?
        attendances = false
        break
      elsif item[:started_at] > item[:finished_at]
        attendances = false
        break
      end
    end
    return attendances
  end
end
