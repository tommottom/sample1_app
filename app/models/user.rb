class User < ActiveRecord::Base
  before_save {self.email = email.downcase}
  #downcaseメソッドを用いて、emailが保存される前に小文字に変換する。
  #selfを用いて、emailオブジェクトそれ自体を呼び出すのを忘れずに
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false}# 大文字小文字を無視する
   
  has_secure_password      
  validates :password, presence: true, length: {minimum: 6}
end

