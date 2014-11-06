module Features
  def select_datetime(year, month, day, hour, minute, from:)
    id = find_field(from)[:id].sub(/_1i$/, "")
    select year, from: "#{id}_1i"
    select t("date.month_names")[month], from: "#{id}_2i"
    select day, from: "#{id}_3i"
    select hour, from: "#{id}_4i"
    select minute, from: "#{id}_5i"
  end
end
