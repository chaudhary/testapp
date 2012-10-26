class Album < ActiveRecord::Base
  attr_accessible :title
  has_many :photos
  
  accepts_nested_attributes_for :photos
end
