module SystemHelper
  def select_datetime(datetime, options = {})
    field = options[:from]
    base_id = find('label', text: field)['for'].gsub(/_\di$/, '')

    select datetime.year.to_s, from: "#{base_id}_1i" # year
    select datetime.strftime('%B'), from: "#{base_id}_2i" # month
    select datetime.day.to_s, from: "#{base_id}_3i" # day
    select datetime.hour.to_s.rjust(2, '0'), from: "#{base_id}_4i" # hour
    select datetime.min.to_s.rjust(2, '0'),  from: "#{base_id}_5i" # minute
  end
end
