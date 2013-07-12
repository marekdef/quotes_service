class Quote < ActiveRecord::Base
  attr_accessible :content, :user_id
  attr_readonly :user_id

  belongs_to :user

  def as_json(options = {})
    super(include: { user: {
        except: [ :password_digest ]}})

  end
end
