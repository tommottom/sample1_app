require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "layout links" do
    #rootのページを開く
    get root_path
    #assert_templateメソッドは、homepageに正しいviewが描画されているかを実証する
    assert_template 'static_pages/home'
    #今回の場合assert_selectメソッドは、[href=?]の?部分に後述の名前付きルートが存在するかを
    #テストする
    #Railsは自動的に、?マークに指定した値であるabout_pathを挿入する。
    #a[href=?]は自動的に、<a href"/about"></a>に変換される
    assert_select "a[href=?]",root_path, count: 2
    assert_select "a[href=?]",help_path
    assert_select "a[href=?]",about_path
    assert_select "a[href=?]",contact_path
  end
end
