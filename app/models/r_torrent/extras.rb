module NumExt
  def to_kb
    format (self/1024.0), 'kB'
  end
  def to_mb
    return self.to_kb if self < (1024*1024)
    format (self/(1024.0*1024.0)), 'MB'
  end
  def format num, sign
    sprintf("%.1f", num).to_s + sign
  end
end

class Bignum
  include NumExt
end

class Fixnum
  include NumExt
end


class Float
  include NumExt
end
