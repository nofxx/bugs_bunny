module BugsBunny
  module Helper

    # http://gist.github.com/72234
    def print_table(title, items, *fields)
      return if items.empty?
      puts title
      #find max length for each field; start with the field names themselves
      fields = items.first.class.column_names unless fields.any?
      max_len = Hash[*fields.map {|f| [f, f.to_s.length]}.flatten]
      items.each do |item|
        fields.each do |field|
          len = item.send(field).to_s.length
          max_len[field] = len if len > max_len[field]
        end
      end

      border = '+-' + fields.map {|f| '-' * max_len[f] }.join('-+-') + '-+'
      title_row = '| ' + fields.map do |f|
        sprintf("%-#{max_len[f]}s", f.to_s.capitalize)
      end.join(' | ') + ' |'

      puts border
      puts title_row
      puts border

      items.each do |item|
        row = '| ' + fields.map do |f|
          sprintf("%-#{max_len[f]}s", item.send(f))
        end.join(' | ') + ' |'
        puts row
      end

      puts border
      puts "#{items.length} rows in set\n"
    end
  end
end
