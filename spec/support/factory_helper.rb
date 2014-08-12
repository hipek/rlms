module FactoryHelper
  def build(*args)
    ::FactoryGirl.build(*args)
  end

  def create(*args)
    ::FactoryGirl.create(*args)
  end  
end
