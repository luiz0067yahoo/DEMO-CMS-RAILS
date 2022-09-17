require 'test_helper'

class NoticiaVideosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @noticia_video = noticia_videos(:one)
  end

  test "should get index" do
    get noticia_videos_url
    assert_response :success
  end

  test "should get new" do
    get new_noticia_video_url
    assert_response :success
  end

  test "should create noticia_video" do
    assert_difference('NoticiaVideo.count') do
      post noticia_videos_url, params: { noticia_video: { Noticia_id: @noticia_video.Noticia_id, descricao: @noticia_video.descricao, link_youtube: @noticia_video.link_youtube, nome: @noticia_video.nome } }
    end

    assert_redirected_to noticia_video_url(NoticiaVideo.last)
  end

  test "should show noticia_video" do
    get noticia_video_url(@noticia_video)
    assert_response :success
  end

  test "should get edit" do
    get edit_noticia_video_url(@noticia_video)
    assert_response :success
  end

  test "should update noticia_video" do
    patch noticia_video_url(@noticia_video), params: { noticia_video: { Noticia_id: @noticia_video.Noticia_id, descricao: @noticia_video.descricao, link_youtube: @noticia_video.link_youtube, nome: @noticia_video.nome } }
    assert_redirected_to noticia_video_url(@noticia_video)
  end

  test "should destroy noticia_video" do
    assert_difference('NoticiaVideo.count', -1) do
      delete noticia_video_url(@noticia_video)
    end

    assert_redirected_to noticia_videos_url
  end
end
