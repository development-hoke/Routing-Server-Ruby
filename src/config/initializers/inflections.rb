# 複数形への変換制御
ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.uncountable %w( staff )
end
