require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
  end
  
  test "should be valid" do
    assert @user.valid?
    #@userがあった場合、妥当となるテスト
  end
  
  test "name should be present" do
    @user.name=" "
    assert_not@user.valid?
    #nameが空だったら、妥当ではないことを示すテスト
    #validationすることで、nameが空だったら、falseを返すように設定する
  end
  
  test "email should be present" do
    @user.email=" "
    assert_not@user.valid?
    #emailが空だったら、妥当ではないことを示すテスト
  end
  test "name should not be too long" do
    @user.name="a"*51
    #a * 51 = aaaaaaa...n
    assert_not@user.valid?
    #nameの長さが51以上なら妥当ではないことを示すテスト
  end
  
  test "email should not be too long" do
    @user.email="a"*255+"@example.com"
    assert_not@user.valid?
    #emailの長さが255以上なら妥当ではないことを示すテスト
  end
  test "email validation should accept valid addresses" do
    valid_addresses =  %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    #配列内に、受け付けたいemailのアドレスの要素を記述する。
    #%w[foo bar baz] =  ["foo", "bar", "baz"],つまりパーセント記法を用いて配列を生成
    valid_addresses.each do |valid_address|
      #valid_adderssesの要素を順にループしてブロック変数に渡す。
      @user.email = valid_address
      #@user.emailにブロック変数を渡す。
      assert @user.valid?, "#{valid_address.inspect}should be valid"
      #valid_addressesのアドレスのみ受け取ることが妥当であることを示すテスト
    end
  end
  
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    #わかりづらいタイポミスを行い、受け付けたくないアドレスを生成
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
      #invalid_addressesのアドレスなら妥当ではないことを示すテスト
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    #@user.dupのdupメソッドはレシーバのオブジェクトのコピーを生成して返します。
    #オブジェクトのコピーとは、同じ内容をもつオブジェクトです。
    duplicate_user.email= @user.email.upcase
    #dupメソッドで、duplicate_userに@userのコピーを渡したのでemailメソッドが使える。
    #DBに保存するときに大文字だと困るので、upcaseメソッドでその状態のemailを受け付けないようにする
    @user.save
    assert_not duplicate_user.valid?
    #emailアドレスがユニークでなければ妥当ではないことを示すテスト
    #同じemailは受け付けへんよということ。
  end
  test "password should be present (noblank)" do
    @user.password = @user.password_confirmation = "" * 6
    assert_not @user.valid?
    #パスワードが空だったら妥当ではないこと示すテスト
    # 0 * 6なのは、6文字以上のパスワードの文字列が妥当なテストを書いたため。
  end
  
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
    #パスワードが5文字よりも短ければ妥当ではないことを示すテスト
  end
  
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end
  
  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end
  
  test "should follow and unfollow a user" do
    michael  = users(:michael)
    archer   = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followers.include?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end
  
  test "feed should have the right posts" do
    michael = users(:michael)
    archer  = users(:archer)
    lana    = users(:lana)
    # Posts from followed user
    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    # Posts from self
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
    end
    # Posts from unfollowed user
    archer.microposts.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)
    end
  end
end
