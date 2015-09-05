require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
 test 'invalid signup information' do
   get signup_path
   #signup_pathにアクセスした時
   assert_no_difference 'User.count' do
   #下記条件のuserがsignupした時、userにはカウントしない。
   #nameが空 emailが違う passwordが違う passwordconfirmationが違う
     post users_path, user:{ name: "", email: "user@invalid", password: "foo", password_confirmation:
     "bar"}
   end
   assert_template 'users/new'
   #表示されるビューテンプレートがuser/newであることが妥当かを試すテスト
 end
 
 test 'valid signup information' do
   get signup_path
   #signup_pathのページにアクセスしたとき
   assert_difference 'User.count', 1 do
   #ブロックで評価された式の戻り値の数値に違いがあるかをテストする 
   #post_via_redirect　sign-upのpostリクエストを受けた後、users_pathにリダイレクトする
   #要約 ユーザーのカウント数がuser.countとブロックの戻り値と同等であるかとテスト
   
      post_via_redirect users_path, user: { name:  "Example User",
                                            email: "user@example.com",
                                            password:              "password",
                                            password_confirmation: "password" }
   end
   assert_template 'users/show'
   assert is_logged_in?
   #表示されるビューテンプレートがusrs/showであることが妥当かを試すテスト
 end
end
