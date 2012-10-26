require 'net/http'
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  has_many :albums
  
  def self.locate_mobile_numbers(number)
    uri = URI("http://mobile-number-locator.com")
    params = { :number => number }
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)
    response = res.body
    start_index = response.index("Location / Area")
    temp = response.slice(start_index,response.length)
    br_index = temp.index("<br>")
    location_string = temp.slice(0,br_index)
    temp = temp.slice(br_index+4,temp.length)
    br_index = temp.index("<br>")
    operator_string = temp.slice(0,br_index)
    location_string = location_string.slice(0,location_string.index("<b>"))+location_string.slice(location_string.index("<b>")+3,location_string.length)
    location_string = location_string.slice(0,location_string.index("</b>"))+location_string.slice(location_string.index("</b>")+4,location_string.length)
    operator_string = operator_string.slice(0,operator_string.index("<b>"))+operator_string.slice(operator_string.index("<b>")+3,operator_string.length)
    operator_string = operator_string.slice(0,operator_string.index("</b>"))+operator_string.slice(operator_string.index("</b>")+4,operator_string.length)
    location_string = location_string.slice(location_string.index("Location / Area:")+"Location / Area:".length,location_string.length)
    operator_string = operator_string.slice(operator_string.index("Operator:")+"Operator:".length,operator_string.length)
    return location_string, operator_string
  end
  
  def self.read_file
    # file = File.open("/home/amit/Desktop/numbers.csv")
    # writeFile = File.open("/home/amit/Desktop/number_detail","w")
    # file.each_line {|line|
      # line = line.chomp
      # location_string, operator_string = self.locate_mobile_numbers(line)
      # if location_string.index("NA").nil? and operator_string.index("NA").nil?
        # writeFile.write(line+"\t"+location_string+"\t"+operator_string+"\n")
      # end
    # }
    # writeFile.close
    writeFile = File.open("/home/amit/Desktop/number_detail","w")
    i=0
    while i<10000
      line = 9700000000+rand(9899999999-9700000000)
      location_string, operator_string = self.locate_mobile_numbers(line)
      if location_string.index("NA").nil? and operator_string.index("NA").nil? and location_string.index("Delhi")
        writeFile.write(line.to_s+"\t"+location_string+"\t"+operator_string+"\n")
        i=i+1
        puts i
      end
    end
    writeFile.close
  end
end
