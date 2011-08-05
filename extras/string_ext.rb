# encoding: UTF-8

class String
  PL_CHARS = { 
    'ą' => 'a', 'ę' => 'e', 'ó' => 'o',
    'ż' => 'z', 'ź' => 'z', 'ć' => 'c',
    'ś' => 's', 'ł' => 'l', 'ń' => 'n',
    'Ą' => 'A', 'Ę' => 'E', 'Ó' => 'O',
    'Ź' => 'Z', 'Ż' => 'Z', 'Ć' => 'C',
    'Ś' => 'S', 'Ł' => 'L', 'Ń' => 'N',
  }
  
  def latinize
    s = self.dup
    PL_CHARS.each{|k,v| s.gsub!(k,v)}
    s
  end
end
