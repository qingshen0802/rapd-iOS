class I18n
  
  def self.translate(word)
    vocabulary[word.to_s.downcase]
  end
  
  def self.vocabulary
    {
      "january" => "Janeiro",
      "february" => "Fevereiro",
      "march" => "Março",
      "april" => "Abril",
      "may" => "Maio",
      "june" => "Junho",
      "july" => "Julho",
      "august" => "Agosto",
      "september" => "Setembro",
      "october" => "Outubro",
      "november" => "Novembro",
      "december" => "Dezembro",
    }
  end
  
end