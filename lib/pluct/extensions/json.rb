module JSON
  def self.is_json?(string)
    begin
      parse(string)
    rescue ParserError
      false
    end
  end
end