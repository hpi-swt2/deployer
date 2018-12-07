module TagsHelper
  def format_log(text, placeholder=nil)
    # <details>
    #     <summary>Placeholder text</summary>
    #     <p>Long text that is collapsed and hidden</p>
    # </details>
    out = ''
    text = remove_ansi_color_codes(text)
    split = text.split("\n") + ['end']
    split.reject! { |s| s.strip.empty? }
    last = split[0]
    same = false
    split[1..-1].each do |line|
        if line.start_with?(last[0..4]) and !line.start_with? '---'
            out += "<details><summary>#{placeholder || last[0..4] + '...'}</summary><p>" if !same
            same = true
            out += last + "<br>"
        else
            out += last + "<br>"
            out += '</p></details>' if same
            same = false
        end
        last = line
    end
    return out.html_safe
  end

  def remove_ansi_color_codes(str)
    str.gsub! "\e[32m", ''
    str.gsub! "\e[31m", ''
    str.gsub! "\e[96m", ''
    str.gsub! "\e[0m", ''
    return str
  end
end