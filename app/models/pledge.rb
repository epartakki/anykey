class Pledge < ApplicationRecord
  
  before_create :ensure_signed_on_set
    
  validates_presence_of    :first_name,
                           :last_name,
                           :email
  validates_uniqueness_of  :email,
                           case_sensitive: false
  validates_format_of      :email,
                           with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/,
                           if: lambda { |x| x.email.present? } 
                             
  
  belongs_to :referrer, class_name: :Pledge, foreign_key: :referrer_id, optional: true
  has_many :referrals, class_name: :Pledge, foreign_key: :referrer_id

  # Non-sequential identifier scheme   
  uniquify :identifier, length: 8, chars: ('A'..'Z').to_a + ('0'..'9').to_a

  def to_param
    identifier
  end
  
  def display_name
    if !self.twitch_display_name.blank?
      return self.twitch_display_name
    else
      return self.first_name + ' ' + self.last_name.first + '.'
    end
  end
  
  private
    def ensure_signed_on_set
      if !self.signed_on.present?
        self.signed_on = Time.now
      end
    end
      
end
